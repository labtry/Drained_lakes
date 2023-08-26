load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin


line_thick = (/0.01,8,0.01/)

type="PDF"
type@wkPaperWidthF  = 9.0
type@wkPaperHeightF = 15.0
wks = gsn_open_wks(type,"Fig5B")               ; send graphics to PNG file

gsn_define_colormap(wks,"userdefined")

res                      = True
res@gsnDraw              = False                ; Don't draw plot 
res@gsnFrame             = False                ; Don't advance frame   
res@xyLineThicknesses    = line_thick           ; Plot line thickness
res@xyDashPatterns    = (/0,0,0/)  
res@vpHeightF= 0.37                    ; change aspect ratio of plot
res@vpWidthF = 0.85   
res@vpXF = 0.12
res@vpYF = 0.95            
res@tmXBMinorOn          = False                ; Turn off x-axis (bottom) minor ticks
res@tmXTMinorOn          = False                ; Turn off x-axis (bottom)minor ticks
res@tmXTOn               = False                ; Turn off x-axis (top) major ticks
res@tmYRMinorOn          = False                ; Turn off y-axis (right) minor ticks
res@tmYLMinorOn          = False                ; Turn off y-axis (left) minor ticks
res@tmXBMode             = "Explicit"
res@tmYLLabelFont   = "times-roman"
res@tiYAxisFont     = "times-roman"
res@tiMainFont            = "times-roman"


x   =   ispan(-5,15,1)
res@tmXBValues           = ispan(-5,15,1)
res@tmXBLabels           = (/"-5","","","","","0","","","","","5","","","","","10","","","","","15"/)

res@trXMinF               = -5
res@trXMaxF               = 15


res@tiYAxisString        = ""        ; Y-axis title
res@tiYAxisFontHeightF   = 0.02               ; Y-axis string size (X0.025 for scaling)
res@tiMainFontHeightF    = 0.02               ; Title string size (X0.025 for scaling)
res@tmXBLabelFontHeightF = 0.02                ; Label font height (X0.020 for scaling)
res@tmYLLabelFontHeightF = 0.02                ; Label font height (X0.020 for scaling)


res@tmYLMajorOutwardLengthF = -0.00
res@tmYLMinorOutwardLengthF = -0.00
res@tmXBMajorOutwardLengthF = -0.00
res@tmXBMinorOutwardLengthF = -0.00

res@tmXBMajorLengthF  = 0.01	            ; set tickmarks 
res@tmYLMajorLengthF  = 0.01         	; set tickmarks 
res@tmYRMajorLengthF  = 0.01         	; set tickmarks 


res@tmBorderThicknessF  = 3.0
res@tmXBMajorThicknessF = 3.0	            ; set tickmarks 
res@tmYLMajorThicknessF = 3.0         	; set tickmarks 
res@tmYRMajorThicknessF = 3.0      	; set tickmarks



var1=(/(/-0.34,-0.34,-0.32,-0.31,-0.28,-0.23,-0.16,-0.10,-0.07,-0.06,-0.06,-0.06,-0.05,-0.05,-0.04,-0.05,-0.05,-0.04,-0.04,-0.04,-0.03/),\
(/-0.25,-0.24,-0.24,-0.22,-0.21,-0.12,-0.10,-0.05,-0.02,-0.01,-0.01,0.00,0.00,0.00,0.00,0.00,0.01,0.00,0.01,0.00,0.01/),\
(/-0.14,-0.13,-0.11,-0.10,-0.09,-0.05,-0.01,0.02,0.04,0.04,0.05,0.05,0.06,0.05,0.04,0.05,0.05,0.05,0.05,0.04,0.05/)/)

var2=(/(/-0.30,-0.30,-0.28,-0.29,-0.28,-0.28,-0.25,-0.22,-0.21,-0.22,-0.22,-0.21,-0.21,-0.19,-0.20,-0.18,-0.17,-0.17,-0.17,-0.18,-0.17/),\
(/-0.19,-0.19,-0.19,-0.19,-0.17,-0.15,-0.14,-0.13,-0.11,-0.11,-0.11,-0.10,-0.10,-0.10,-0.09,-0.09,-0.09,-0.08,-0.08,-0.08,-0.07/),\
(/-0.09,-0.09,-0.08,-0.09,-0.07,-0.07,-0.05,-0.03,-0.02,-0.02,-0.03,-0.02,-0.03,-0.03,-0.03,-0.01,-0.01,-0.02,-0.02,-0.01,-0.01/)/)

var3=(/(/-0.37,-0.35,-0.35,-0.36,-0.36,-0.32,-0.23,-0.11,-0.06,-0.04,-0.03,-0.02,-0.01,0.00,0.00,0.01,0.00,0.00,0.01,0.00,0.00/),\
(/-0.26,-0.26,-0.25,-0.25,-0.25,-0.22,-0.11,0.00,0.03,0.03,0.04,0.05,0.05,0.05,0.06,0.06,0.06,0.06,0.05,0.06,0.06/),\
(/-0.17,-0.16,-0.16,-0.16,-0.15,-0.10,0.00,0.07,0.10,0.10,0.11,0.11,0.11,0.10,0.12,0.11,0.10,0.11,0.11,0.09,0.10/)/)


plot = new(3,graphic)

res@tmYLMode             = "Manual"
res@tmYLTickStartF = -0.3
res@tmYLTickEndF = 0.1
res@tmYLTickSpacingF = 0.1
res@tmYLLabelStride = 1
res@trYMinF               = -0.38
res@trYMaxF               = 0.12
res@tmYLAutoPrecision = False
res@tmYLPrecision = 1

res@xyLineOpacities = (/0,1,0/)

res@tiYAxisString        = ""        ; Y-axis title

res@gsnXYFillOpacities = (/0.2,0.2/)
res@xyLineColors         = (/31,33,31/)          ; Plot line colors
res@gsnXYFillColors = (/33,33/)
plot(2) = gsn_csm_xy(wks,x,var1,res)

res@gsnXYFillOpacities = (/0.1,0.1/)
res@xyLineColors         = (/31,32,31/)          ; Plot line colors
res@gsnXYFillColors = (/32,32/)
plot(0) = gsn_csm_xy(wks,x,var2,res)

res@xyLineColors         = (/31,34,31/)          ; Plot line colors
res@gsnXYFillColors = (/34,34/)
plot(1) = gsn_csm_xy(wks,x,var3,res)


lnres               = True   
lnres@gsLineThicknessF = 1.5
lnres@gsLineColor      = "black" 
lnres@gsLineDashPattern = 1
dum_line = gsn_add_polyline(wks,plot(2),(/-5,15/),(/0,0/),lnres)

overlay(plot(0),plot(1))
overlay(plot(0),plot(2))

;Make panel plot       
resP             = True
resP@gsnMaximize = True
resP@gsnPanelYWhiteSpacePercent = 0.0
resP@gsnPanelXWhiteSpacePercent =   0.0
;resP@gsnPanelRight = 0.97
;resP@gsnPanelLeft = 0.02
resP@gsnPanelRowSpec = True
gsn_panel(wks,(/plot(0)/),(/1/),resP)

; END PROGRAM
end
