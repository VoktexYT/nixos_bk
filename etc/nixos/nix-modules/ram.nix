{ config, ... }:

{
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
  zramSwap.algorithm = "zstd";
}
