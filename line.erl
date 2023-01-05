-module(line).

-include_lib("kernel/include/file.hrl").

-export([len/0]).
-export([len/1]).


len() -> len(".").

len(DirOrFile) ->
    input_to_files(DirOrFile).



input_to_files(Name) ->
    case read_file_info(Name) of
        #file_info{type = directory} ->
            list_src_files(Name);
        #file_info{type = regular} ->
            [Name];
        Err ->
            {error, Err}
    end.

read_file_info(Name) ->
    ok_de_wrap(file:read_file_info(Name)).

list_src_files(Name) ->
    lists:filter(fun is_src_file/1, ok_de_wrap(file:list_dir(Name))).

ok_de_wrap({ok, Res}) -> Res;
ok_de_wrap(Res) -> Res.

is_src_file(F) ->
    is_src_file_ext(filename:extension(F)).

is_src_file_ext(".erl") -> true;
is_src_file_ext(".c") -> true;
is_src_file_ext(".java") -> true;
is_src_file_ext(_) -> false.
