function bedrock = HbedrockFunctionTerraces(x,xmax,amp,p)
bedrock = abs(4*amp/p*(abs(mod((x-(xmax/2)),p)-p/2)-p/4)); %triangle wave
