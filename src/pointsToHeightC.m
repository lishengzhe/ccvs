function Height = pointsToHeightC(C,yFoot,yHead)

Height = C.*(yFoot-yHead)./yHead;