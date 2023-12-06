function data = load_helper(name)
     data = load(append('t' ,num2str(name) ,'.mat'));

%      switch name
%          case 1
%             data = load('t1.mat');
%          case 2 
%             data = load('t2.mat');
%          case 3
%             data = load('t3.mat');
%          case 4
%             data = load('t4.mat');
%          case 5 
%             data = load('t5.mat');
%          case 6
%             data = load('t6.mat');
%          case 7
%             data = load('t7.mat');
%          case 8 
%             data = load('t8.mat');
%          case 9
%             data = load('t9.mat');
%          case 10
%             data = load('t10.mat');
%          case 11 
%             data = load('t11.mat');
%          case 12
%             data = load('t12.mat');
%          case 13
%             data = load('t13.mat');
%          case 14 
%             data = load('t14.mat');
%          case 15
%             data = load('t15.mat');
%          case 16
%             data = load('t16.mat');
%          case 17 
%             data = load('t17.mat');
%          case 18
%             data = load('t18.mat');
%          case 19
%             data = load('t19.mat');
%          case 20 
%             data = load('t20.mat');
%          case 21
%             data = load('t21.mat');
%          case 22
%             data = load('t22.mat');
%          case 23 
%             data = load('t23.mat');
%          case 24
%             data = load('t24.mat');
%          case 25
%             data = load('t25.mat');
%          case 26 
%             data = load('t26.mat');
%          case 27
%             data = load('t27.mat');
%          case 28
%             data = load('t28.mat');
%          case 29 
%             data = load('t29.mat');
%          case 30
%             data = load('t30.mat');
%          case 31
%             data = load('t31.mat');
%          case 32 
%             data = load('t32.mat');
%          case 33
%             data = load('t33.mat');
%          case 34
%             data = load('t34.mat');
%          case 35 
%             data = load('t35.mat');
%          case 36
%             data = load('t36.mat');
%          case 37
%             data = load('t37.mat');
%          case 38 
%             data = load('t38.mat');
%          case 39
%             data = load('t39.mat');
%          case 40
%             data = load('t40.mat');
%          case 41 
%             data = load('t41.mat');
%          case 42
%             data = load('t42.mat');
%          case 43
%             data = load('t43.mat');
%          case 44 
%             data = load('t44.mat');
%          case 45
%             data = load('t45.mat');
%          case 46
%             data = load('t46.mat');
%          case 47 
%             data = load('t47.mat');
%          case 48
%             data = load('t48.mat');
%          case 49
%             data = load('t49.mat');
%          case 50
%             data = load('t50.mat');
%          case 51 
%             data = load('t51.mat');
%          case 52
%             data = load('t52.mat');
%          case 53
%             data = load('t53.mat');
%          case 54 
%             data = load('t54.mat');
%          case 55
%             data = load('t55.mat');
%          case 56
%             data = load('t56.mat');
%          case 57 
%             data = load('t57.mat');
%          case 58
%             data = load('t58.mat');
%          case 59
%             data = load('t59.mat');
%          case 60
%             data = load('t60.mat');
%          case 61 
%             data = load('t61.mat');
%          case 62
%             data = load('t62.mat');
%          case 63
%             data = load('t63.mat');
%          case 64 
%             data = load('t64.mat');
%          case 65
%             data = load('t65.mat');
%          case 66
%             data = load('t66.mat');
%          case 67 
%             data = load('t67.mat');
%          case 68
%             data = load('t68.mat');
%          case 69
%             data = load('t69.mat');
%          case 70
%             data = load('t70.mat');
%          case 71 
%             data = load('t71.mat');
%          case 72
%             data = load('t72.mat');
%          case 73
%             data = load('t73.mat');
%          case 74 
%             data = load('t74.mat');
%          case 75
%             data = load('t75.mat');
%          case 76
%             data = load('t76.mat');
%          case 77 
%             data = load('t77.mat');
%          case 78
%             data = load('t78.mat');
%          case 79
%             data = load('t79.mat');
%          case 80
%             data = load('t80.mat');
%          case 81 
%             data = load('t81.mat');
%          case 82
%             data = load('t82.mat');
%          case 83
%             data = load('t83.mat');
%          case 84 
%             data = load('t84.mat');
%          case 85
%             data = load('t85.mat');
%          case 86
%             data = load('t86.mat');
%          case 87 
%             data = load('t87.mat');
%          case 88
%             data = load('t88.mat');
%          case 89
%             data = load('t89.mat');
%          case 90
%             data = load('t90.mat');
%          case 91 
%             data = load('t91.mat');
%          case 92
%             data = load('t92.mat');
%          case 93
%             data = load('t93.mat');
%          case 94 
%             data = load('t94.mat');
%          case 95
%             data = load('t95.mat');
%          case 96
%             data = load('t96.mat');
%          case 97 
%             data = load('t97.mat');
%          case 98
%             data = load('t98.mat');
%          case 99
%             data = load('t99.mat');
%          case 100
%             data = load('t100.mat');
%          case 101 
%             data = load('t101.mat');
%          case 102
%             data = load('t102.mat');
%          case 103
%             data = load('t103.mat');
%          case 104 
%             data = load('t104.mat');
%          case 105
%             data = load('t105.mat');
%          case 106
%             data = load('t106.mat');
%          case 107 
%             data = load('t107.mat');
%          case 108
%             data = load('t108.mat');
%          case 109
%             data = load('t109.mat');
%          case 110
%             data = load('t110.mat');
%          case 111 
%             data = load('t111.mat');
%          case 112
%             data = load('t112.mat');
%          case 113
%             data = load('t113.mat');
%          case 114 
%             data = load('t114.mat');
%          case 115
%             data = load('t115.mat');
%          case 116
%             data = load('t116.mat');
%          case 117 
%             data = load('t117.mat');
%          case 118
%             data = load('t118.mat');
%          case 119
%             data = load('t119.mat');
%          case 120
%             data = load('t120.mat');
%          case 121 
%             data = load('t121.mat');
%          case 122
%             data = load('t122.mat');
%          case 123
%             data = load('t123.mat');
%          case 124 
%             data = load('t124.mat');
%          case 125
%             data = load('t125.mat');
%          case 126
%             data = load('t126.mat');
%          case 127 
%             data = load('t127.mat');
%          case 128
%             data = load('t128.mat');
%          case 129
%             data = load('t129.mat');
%          case 130
%             data = load('t130.mat');
%          case 131 
%             data = load('t131.mat');
%          case 132
%             data = load('t132.mat');
%          case 133
%             data = load('t133.mat');
%          case 134 
%             data = load('t134.mat');
%          case 135
%             data = load('t135.mat');
%          case 136
%             data = load('t136.mat');
%          case 137 
%             data = load('t137.mat');
%          case 138
%             data = load('t138.mat');
%          case 139
%             data = load('t139.mat');
%          case 140
%             data = load('t140.mat');
%          case 141 
%             data = load('t141.mat');
%          case 142
%             data = load('t142.mat');
%          case 143
%             data = load('t143.mat');
%          case 144 
%             data = load('t144.mat');
%          case 145
%             data = load('t145.mat');
%          case 146
%             data = load('t146.mat');
%          case 147 
%             data = load('t147.mat');
%          case 148
%             data = load('t148.mat');
%          case 149
%             data = load('t149.mat');
%          case 150
%             data = load('t150.mat');
%          case 151 
%             data = load('t151.mat');
%          case 152
%             data = load('t152.mat');
%          case 153
%             data = load('t153.mat');
%          case 154 
%             data = load('t154.mat');
%          case 155
%             data = load('t155.mat');
%          case 156
%             data = load('t156.mat');
%          case 157 
%             data = load('t157.mat');
%          case 158
%             data = load('t158.mat');
%          case 159
%             data = load('t159.mat');
%          case 160
%             data = load('t160.mat');
%          case 161 
%             data = load('t161.mat');
%          case 162
%             data = load('t162.mat');
%          case 163
%             data = load('t163.mat');
%          case 164 
%             data = load('t164.mat');
%          case 165
%             data = load('t165.mat');
%          case 166
%             data = load('t166.mat');
%          case 167 
%             data = load('t167.mat');
%          case 168
%             data = load('t168.mat');
%          case 169
%             data = load('t169.mat');
%          case 170
%             data = load('t170.mat');
%          case 171 
%             data = load('t171.mat');
%          case 172
%             data = load('t172.mat');
%          case 173
%             data = load('t173.mat');
%          case 174 
%             data = load('t174.mat');
%          case 175
%             data = load('t175.mat');
%          case 176
%             data = load('t176.mat');
%          case 177 
%             data = load('t177.mat');
%          case 178
%             data = load('t178.mat');
%          case 179
%             data = load('t179.mat');
%          case 180
%             data = load('t180.mat');
%          case 181 
%             data = load('t181.mat');
%          case 182
%             data = load('t182.mat');
%          case 183
%             data = load('t183.mat');
%          case 184 
%             data = load('t184.mat');
%          case 185
%             data = load('t185.mat');
%          case 186
%             data = load('t186.mat');
%          case 187 
%             data = load('t187.mat');
%          case 188
%             data = load('t188.mat');
%          case 189
%             data = load('t189.mat');
%          case 190
%             data = load('t190.mat');
%          case 191 
%             data = load('t191.mat');
%          case 192
%             data = load('t192.mat');
%          case 193
%             data = load('t193.mat');
%          case 194 
%             data = load('t194.mat');
%          case 195
%             data = load('t195.mat');
%          case 196
%             data = load('t196.mat');
%          case 197 
%             data = load('t197.mat');
%          case 198
%             data = load('t198.mat');
%          case 199
%             data = load('t199.mat');
%          case 200
%             data = load('t200.mat');
%          case 201
%             data = load('t201.mat');
%          otherwise
%             error('Invalid name');
%      end
     

end
