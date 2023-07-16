# ActiveStorage Send Stream Investigation

A minified example of the issue:
```sh
curl -v localhost:3000/broken
```

Some examples on how to get past the issue:
```sh
curl -v localhost:3000/working_simulating_partial_write
curl -v localhost:3000/working_with_partial_write
curl -v localhost:3000/working_with_full_write
```

