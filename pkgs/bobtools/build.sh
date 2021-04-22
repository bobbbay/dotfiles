set -e
unset PATH
for p in $buildInputs; do
  export PATH=$p/bin${PATH:+:}$PATH
done

echo $PATH

mkdir $out/bin -p

cp -r $src/* $out/bin
