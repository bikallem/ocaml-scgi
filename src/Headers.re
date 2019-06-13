type t = list((string, string));

let null = Char.chr(0);

let of_string = s => {
  let rec loop = (lst, index) => {
    let f = () => {
      let next = String.index_from(s, index, null);
      let name = String.sub(s, index, next - index);
      let index = next + 1;
      let next = String.index_from(s, index, null);
      let value = String.sub(s, index, next - index);
      loop([(name, value), ...lst], next + 1);
    };

    try (f()) {
    | Not_found => List.rev(lst)
    };
  };

  loop([], 0);
};
