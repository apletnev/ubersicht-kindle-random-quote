BEGIN {
  clipping = "";
  i=0;
  srand();
}
{
  if ($0 !~ /==========/) {
    if ($0 !~ /- /) {
      clipping = clipping $0 "\r\n";
    }
  } else {
  clippings[i++] = clipping;
  clipping = "";
}
}
END {
  print clippings[int(rand()*i)];
}
