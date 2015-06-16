class dw.Game
{
   var XMAX = 32;
   var YMAX = 28;
   var pmax = 7;
   var user = 0;
   var put_dice = 3;
   var STOCK_MAX = 64;
   function Game()
   {
      var _loc2_ = undefined;
      var _loc3_ = undefined;
      this.AREA_MAX = 32;
      this.adat = new Array(32);
      this.player = new Array(8);
      this.jun = new Array(8);
      this.cel_max = this.XMAX * this.YMAX;
      this.cel = new Array(this.cel_max);
      this.num = new Array(this.cel_max);
      this.rcel = new Array(this.cel_max);
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         this.num[_loc2_] = _loc2_;
         _loc2_ = _loc2_ + 1;
      }
      this.join = new Array(this.cel_max);
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         this.join[_loc2_] = new dw.JoinData();
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            this.join[_loc2_].dir[_loc3_] = this.next_cel(_loc2_,_loc3_);
            _loc3_ = _loc3_ + 1;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function start_game()
   {
      var _loc2_ = undefined;
      _loc2_ = 0;
      while(_loc2_ < 8)
      {
         this.jun[_loc2_] = _loc2_;
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.pmax)
      {
         var _loc3_ = Math.floor(Math.random() * this.pmax);
         var _loc4_ = this.jun[_loc2_];
         this.jun[_loc2_] = this.jun[_loc3_];
         this.jun[_loc3_] = _loc4_;
         _loc2_ = _loc2_ + 1;
      }
      this.ban = 0;
      _loc2_ = 0;
      while(_loc2_ < 8)
      {
         this.player[_loc2_] = new dw.PlayerData();
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < 8)
      {
         this.set_area_tc(_loc2_);
         _loc2_ = _loc2_ + 1;
      }
      this.his = new Array();
      this.his_c = 0;
      this.his_arm = new Array(this.AREA_MAX);
      this.his_dice = new Array(this.AREA_MAX);
      _loc2_ = 0;
      while(_loc2_ < this.AREA_MAX)
      {
         this.his_arm[_loc2_] = this.adat[_loc2_].arm;
         this.his_dice[_loc2_] = this.adat[_loc2_].dice;
         _loc2_ = _loc2_ + 1;
      }
   }
   function get_pn()
   {
      return this.jun[this.ban];
   }
   function make_map()
   {
      var _loc2_ = undefined;
      var _loc3_ = undefined;
      var _loc6_ = undefined;
      var _loc12_ = undefined;
      var _loc22_ = undefined;
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         var _loc19_ = Math.floor(Math.random() * this.cel_max);
         var _loc23_ = this.num[_loc2_];
         this.num[_loc2_] = this.num[_loc19_];
         this.num[_loc19_] = _loc23_;
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         this.cel[_loc2_] = 0;
         this.rcel[_loc2_] = 0;
         _loc2_ = _loc2_ + 1;
      }
      _loc22_ = 1;
      this.rcel[Math.floor(Math.random() * this.cel_max)] = 1;
      while(!false)
      {
         var _loc4_ = undefined;
         var _loc14_ = 9999;
         _loc2_ = 0;
         while(_loc2_ < this.cel_max)
         {
            if(this.cel[_loc2_] <= 0)
            {
               if(this.num[_loc2_] <= _loc14_)
               {
                  if(this.rcel[_loc2_] != 0)
                  {
                     _loc14_ = this.num[_loc2_];
                     _loc4_ = _loc2_;
                  }
               }
            }
            _loc2_ = _loc2_ + 1;
         }
         if(_loc14_ == 9999)
         {
            break;
         }
         var _loc21_ = this.percolate(_loc4_,8,_loc22_);
         if(_loc21_ == 0)
         {
            break;
         }
         _loc22_ = _loc22_ + 1;
         if(!(_loc22_ < this.AREA_MAX))
         {
            break;
         }
      }
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         if(this.cel[_loc2_] <= 0)
         {
            var _loc10_ = 0;
            var _loc16_ = 0;
            _loc6_ = 0;
            while(_loc6_ < 6)
            {
               _loc4_ = this.join[_loc2_].dir[_loc6_];
               if(_loc4_ >= 0)
               {
                  if(this.cel[_loc4_] == 0)
                  {
                     _loc10_ = 1;
                  }
                  else
                  {
                     _loc16_ = this.cel[_loc4_];
                  }
               }
               _loc6_ = _loc6_ + 1;
            }
            if(_loc10_ == 0)
            {
               this.cel[_loc2_] = _loc16_;
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.AREA_MAX)
      {
         this.adat[_loc2_] = new dw.AreaData();
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         _loc22_ = this.cel[_loc2_];
         if(_loc22_ > 0)
         {
            this.adat[_loc22_].size = this.adat[_loc22_].size + 1;
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 1;
      while(_loc2_ < this.AREA_MAX)
      {
         if(!(this.adat[_loc2_].size > 5))
         {
            this.adat[_loc2_].size = 0;
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         _loc22_ = this.cel[_loc2_];
         if(this.adat[_loc22_].size == 0)
         {
            this.cel[_loc2_] = 0;
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 1;
      while(_loc2_ < this.AREA_MAX)
      {
         this.adat[_loc2_].left = this.XMAX;
         this.adat[_loc2_].right = -1;
         this.adat[_loc2_].top = this.YMAX;
         this.adat[_loc2_].bottom = -1;
         this.adat[_loc2_].len_min = 9999;
         _loc2_ = _loc2_ + 1;
      }
      _loc12_ = 0;
      _loc2_ = 0;
      while(_loc2_ < this.YMAX)
      {
         _loc3_ = 0;
         while(_loc3_ < this.XMAX)
         {
            _loc22_ = this.cel[_loc12_];
            if(_loc22_ > 0)
            {
               if(_loc3_ < this.adat[_loc22_].left)
               {
                  this.adat[_loc22_].left = _loc3_;
               }
               if(_loc3_ > this.adat[_loc22_].right)
               {
                  this.adat[_loc22_].right = _loc3_;
               }
               if(_loc2_ < this.adat[_loc22_].top)
               {
                  this.adat[_loc22_].top = _loc2_;
               }
               if(_loc2_ > this.adat[_loc22_].bottom)
               {
                  this.adat[_loc22_].bottom = _loc2_;
               }
            }
            _loc12_ = _loc12_ + 1;
            _loc3_ = _loc3_ + 1;
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 1;
      while(_loc2_ < this.AREA_MAX)
      {
         this.adat[_loc2_].cx = Math.floor((this.adat[_loc2_].left + this.adat[_loc2_].right) / 2);
         this.adat[_loc2_].cy = Math.floor((this.adat[_loc2_].top + this.adat[_loc2_].bottom) / 2);
         _loc2_ = _loc2_ + 1;
      }
      _loc12_ = 0;
      var _loc8_ = undefined;
      var _loc7_ = undefined;
      var _loc11_ = undefined;
      _loc2_ = 0;
      while(_loc2_ < this.YMAX)
      {
         _loc3_ = 0;
         while(_loc3_ < this.XMAX)
         {
            _loc22_ = this.cel[_loc12_];
            if(_loc22_ > 0)
            {
               _loc8_ = this.adat[_loc22_].cx - _loc3_;
               if(_loc8_ < 0)
               {
                  _loc8_ = - _loc8_;
               }
               _loc7_ = this.adat[_loc22_].cy - _loc2_;
               if(_loc7_ < 0)
               {
                  _loc7_ = - _loc7_;
               }
               _loc11_ = _loc8_ + _loc7_;
               _loc10_ = 0;
               _loc6_ = 0;
               while(_loc6_ < 6)
               {
                  _loc4_ = this.join[_loc12_].dir[_loc6_];
                  if(_loc4_ > 0)
                  {
                     var _loc5_ = this.cel[_loc4_];
                     if(!(_loc5_ == _loc22_))
                     {
                        _loc10_ = 1;
                        this.adat[_loc22_].join[_loc5_] = 1;
                     }
                  }
                  _loc6_ = _loc6_ + 1;
               }
               if(_loc10_)
               {
                  _loc11_ = _loc11_ + 4;
               }
               if(_loc11_ < this.adat[_loc22_].len_min)
               {
                  this.adat[_loc22_].len_min = _loc11_;
                  this.adat[_loc22_].cpos = _loc2_ * this.XMAX + _loc3_;
               }
            }
            _loc12_ = _loc12_ + 1;
            _loc3_ = _loc3_ + 1;
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.AREA_MAX)
      {
         this.adat[_loc2_].arm = -1;
         _loc2_ = _loc2_ + 1;
      }
      var _loc18_ = 0;
      var _loc20_ = new Array(this.AREA_MAX);
      while(!false)
      {
         _loc12_ = 0;
         _loc2_ = 1;
         while(_loc2_ < this.AREA_MAX)
         {
            if(this.adat[_loc2_].size != 0)
            {
               if(this.adat[_loc2_].arm < 0)
               {
                  _loc20_[_loc12_] = _loc2_;
                  _loc12_ = _loc12_ + 1;
               }
            }
            _loc2_ = _loc2_ + 1;
         }
         if(_loc12_ == 0)
         {
            break;
         }
         _loc22_ = _loc20_[Math.floor(Math.random() % _loc12_)];
         this.adat[_loc22_].arm = _loc18_;
         _loc18_ = _loc18_ + 1;
         if(!(_loc18_ < this.pmax))
         {
            _loc18_ = 0;
         }
      }
      this.chk = new Array(this.AREA_MAX);
      _loc2_ = 0;
      while(_loc2_ < this.AREA_MAX)
      {
         this.chk[_loc2_] = 0;
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         var _loc9_ = this.cel[_loc2_];
         if(_loc9_ != 0)
         {
            if(!this.chk[_loc9_])
            {
               _loc6_ = 0;
               while(_loc6_ < 6)
               {
                  if(this.chk[_loc9_])
                  {
                     break;
                  }
                  var _loc13_ = this.join[_loc2_].dir[_loc6_];
                  if(!(_loc13_ < 0))
                  {
                     if(!(this.cel[_loc13_] == _loc9_))
                     {
                        this.set_area_line(_loc2_,_loc6_);
                        this.chk[_loc9_] = 1;
                     }
                  }
                  _loc6_ = _loc6_ + 1;
               }
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      var _loc24_ = 0;
      _loc2_ = 1;
      while(_loc2_ < this.AREA_MAX)
      {
         if(this.adat[_loc2_].size > 0)
         {
            _loc24_ = _loc24_ + 1;
            this.adat[_loc2_].dice = 1;
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc24_ = _loc24_ * (this.put_dice - 1);
      var _loc15_ = 0;
      _loc2_ = 0;
      while(_loc2_ < _loc24_)
      {
         var _loc17_ = new Array(this.AREA_MAX);
         _loc12_ = 0;
         _loc3_ = 1;
         while(_loc3_ < this.AREA_MAX)
         {
            if(this.adat[_loc3_].size != 0)
            {
               if(this.adat[_loc3_].arm == _loc15_)
               {
                  if(this.adat[_loc3_].dice < 8)
                  {
                     _loc17_[_loc12_] = _loc3_;
                     _loc12_ = _loc12_ + 1;
                  }
               }
            }
            _loc3_ = _loc3_ + 1;
         }
         if(_loc12_ == 0)
         {
            break;
         }
         _loc22_ = _loc17_[Math.floor(Math.random() * _loc12_)];
         this.adat[_loc22_].dice = this.adat[_loc22_].dice + 1;
         _loc15_ = _loc15_ + 1;
         if(!(_loc15_ < this.pmax))
         {
            _loc15_ = 0;
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < this.AREA_MAX)
      {
         _loc2_ = _loc2_ + 1;
      }
   }
   function percolate(pt, cmax, an)
   {
      if(cmax < 3)
      {
         cmax = 3;
      }
      var _loc2_ = undefined;
      var _loc11_ = undefined;
      var _loc3_ = undefined;
      var _loc6_ = pt;
      this.next_f = new Array(this.cel_max);
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         this.next_f[_loc2_] = 0;
         _loc2_ = _loc2_ + 1;
      }
      var _loc7_ = 0;
      while(!false)
      {
         this.cel[_loc6_] = an;
         _loc7_ = _loc7_ + 1;
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            var _loc4_ = this.join[_loc6_].dir[_loc2_];
            if(_loc4_ >= 0)
            {
               this.next_f[_loc4_] = 1;
            }
            _loc2_ = _loc2_ + 1;
         }
         var _loc5_ = 9999;
         _loc2_ = 0;
         while(_loc2_ < this.cel_max)
         {
            if(this.next_f[_loc2_] != 0)
            {
               if(this.cel[_loc2_] <= 0)
               {
                  if(this.num[_loc2_] <= _loc5_)
                  {
                     _loc5_ = this.num[_loc2_];
                     _loc6_ = _loc2_;
                  }
               }
            }
            _loc2_ = _loc2_ + 1;
         }
         if(_loc5_ == 9999)
         {
            break;
         }
         if(!(_loc7_ < cmax))
         {
            break;
         }
      }
      _loc2_ = 0;
      while(_loc2_ < this.cel_max)
      {
         if(this.next_f[_loc2_] != 0)
         {
            if(this.cel[_loc2_] <= 0)
            {
               this.cel[_loc2_] = an;
               _loc7_ = _loc7_ + 1;
               _loc3_ = 0;
               while(_loc3_ < 6)
               {
                  _loc4_ = this.join[_loc2_].dir[_loc3_];
                  if(_loc4_ >= 0)
                  {
                     this.rcel[_loc4_] = 1;
                  }
                  _loc3_ = _loc3_ + 1;
               }
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      return _loc7_;
   }
   function set_area_line(old_cel, old_dir)
   {
      var _loc4_ = old_cel;
      var _loc2_ = old_dir;
      var _loc7_ = this.cel[_loc4_];
      var _loc6_ = 0;
      this.adat[_loc7_].line_cel[_loc6_] = _loc4_;
      this.adat[_loc7_].line_dir[_loc6_] = _loc2_;
      _loc6_ = _loc6_ + 1;
      var _loc5_ = 0;
      while(_loc5_ < 100)
      {
         _loc2_ = _loc2_ + 1;
         if(!(_loc2_ < 6))
         {
            _loc2_ = 0;
         }
         var _loc3_ = this.join[_loc4_].dir[_loc2_];
         if(!(_loc3_ < 0))
         {
            if(this.cel[_loc3_] == _loc7_)
            {
               _loc4_ = _loc3_;
               _loc2_ = _loc2_ - 2;
               if(_loc2_ < 0)
               {
                  _loc2_ = _loc2_ + 6;
               }
            }
         }
         this.adat[_loc7_].line_cel[_loc6_] = _loc4_;
         this.adat[_loc7_].line_dir[_loc6_] = _loc2_;
         _loc6_ = _loc6_ + 1;
         if(_loc4_ == old_cel && _loc2_ == old_dir)
         {
            break;
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function next_cel(opos, dir)
   {
      var _loc8_ = opos % this.XMAX;
      var _loc7_ = Math.floor(opos / this.XMAX);
      var _loc4_ = _loc7_ % 2;
      var _loc2_ = 0;
      var _loc3_ = 0;
      switch(dir)
      {
         case 0:
            _loc2_ = !_loc4_?0:1;
            _loc3_ = -1;
            break;
         case 1:
            _loc2_ = 1;
            break;
         case 2:
            _loc2_ = !_loc4_?0:1;
            _loc3_ = 1;
            break;
         case 3:
            _loc2_ = !_loc4_?-1:0;
            _loc3_ = 1;
            break;
         case 4:
            _loc2_ = -1;
            break;
         case 5:
            _loc2_ = !_loc4_?-1:0;
            _loc3_ = -1;
            break;
      }
      var _loc6_ = _loc8_ + _loc2_;
      var _loc5_ = _loc7_ + _loc3_;
      if(_loc6_ < 0 || _loc5_ < 0 || !(_loc6_ < this.XMAX) || !(_loc5_ < this.YMAX))
      {
         return -1;
      }
      return _loc5_ * this.XMAX + _loc6_;
   }
   function set_area_tc(pn)
   {
      this.player[pn].area_tc = 0;
      var _loc2_ = undefined;
      var _loc3_ = undefined;
      this.chk = new Array(this.AREA_MAX);
      _loc2_ = 0;
      while(_loc2_ < this.AREA_MAX)
      {
         this.chk[_loc2_] = _loc2_;
         _loc2_ = _loc2_ + 1;
      }
      while(!false)
      {
         var _loc4_ = 0;
         _loc2_ = 1;
         while(_loc2_ < this.AREA_MAX)
         {
            if(this.adat[_loc2_].size != 0)
            {
               if(this.adat[_loc2_].arm == pn)
               {
                  _loc3_ = 1;
                  while(_loc3_ < this.AREA_MAX)
                  {
                     if(this.adat[_loc3_].size != 0)
                     {
                        if(this.adat[_loc3_].arm == pn)
                        {
                           if(this.adat[_loc2_].join[_loc3_] != 0)
                           {
                              if(this.chk[_loc3_] != this.chk[_loc2_])
                              {
                                 if(this.chk[_loc2_] > this.chk[_loc3_])
                                 {
                                    this.chk[_loc2_] = this.chk[_loc3_];
                                 }
                                 else
                                 {
                                    this.chk[_loc3_] = this.chk[_loc2_];
                                 }
                                 _loc4_ = 1;
                                 break;
                              }
                           }
                        }
                     }
                     _loc3_ = _loc3_ + 1;
                  }
                  if(_loc4_)
                  {
                     break;
                  }
               }
            }
            _loc2_ = _loc2_ + 1;
         }
         if(_loc4_ == 0)
         {
            break;
         }
      }
      this.tc = new Array(this.AREA_MAX);
      _loc2_ = 0;
      while(_loc2_ < this.AREA_MAX)
      {
         this.tc[_loc2_] = 0;
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 1;
      while(_loc2_ < this.AREA_MAX)
      {
         if(this.adat[_loc2_].size != 0)
         {
            if(this.adat[_loc2_].arm == pn)
            {
               this.tc[this.chk[_loc2_]]++;
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      var _loc6_ = 0;
      _loc2_ = 0;
      while(_loc2_ < this.AREA_MAX)
      {
         if(this.tc[_loc2_] > _loc6_)
         {
            _loc6_ = this.tc[_loc2_];
         }
         _loc2_ = _loc2_ + 1;
      }
      this.player[pn].area_tc = _loc6_;
   }
   function com_thinking()
   {
      var _loc2_ = undefined;
      var _loc3_ = undefined;
      _loc2_ = 0;
      while(_loc2_ < 8)
      {
         this.player[_loc2_].area_c = 0;
         this.player[_loc2_].dice_c = 0;
         _loc2_ = _loc2_ + 1;
      }
      var _loc11_ = 0;
      _loc2_ = 1;
      while(_loc2_ < this.AREA_MAX)
      {
         if(this.adat[_loc2_].size != 0)
         {
            var _loc10_ = this.adat[_loc2_].arm;
            this.player[_loc10_].area_c = this.player[_loc10_].area_c + 1;
            this.player[_loc10_].dice_c = this.player[_loc10_].dice_c + this.adat[_loc2_].dice;
            _loc11_ = _loc11_ + this.adat[_loc2_].dice;
         }
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < 8)
      {
         this.player[_loc2_].dice_jun = _loc2_;
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      while(_loc2_ < 7)
      {
         _loc3_ = _loc2_ + 1;
         while(_loc3_ < 8)
         {
            if(this.player[_loc2_].dice_c < this.player[_loc3_].dice_c)
            {
               var _loc7_ = this.player[_loc2_].dice_jun;
               this.player[_loc2_].dice_jun = this.player[_loc3_].dice_jun;
               this.player[_loc3_].dice_jun = _loc7_;
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc2_ = _loc2_ + 1;
      }
      var _loc5_ = -1;
      _loc2_ = 0;
      while(_loc2_ < 8)
      {
         if(this.player[_loc2_].dice_c > _loc11_ * 2 / 5)
         {
            _loc5_ = _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      this.list_from = new Array(this.AREA_MAX * this.AREA_MAX);
      this.list_to = new Array(this.AREA_MAX * this.AREA_MAX);
      var _loc6_ = 0;
      var _loc9_ = this.jun[this.ban];
      _loc2_ = 1;
      while(_loc2_ < this.AREA_MAX)
      {
         if(this.adat[_loc2_].size != 0)
         {
            if(this.adat[_loc2_].arm == _loc9_)
            {
               if(this.adat[_loc2_].dice > 1)
               {
                  _loc3_ = 1;
                  for(; _loc3_ < this.AREA_MAX; _loc3_ = _loc3_ + 1)
                  {
                     if(this.adat[_loc3_].size != 0)
                     {
                        if(this.adat[_loc3_].arm != _loc9_)
                        {
                           if(this.adat[_loc2_].join[_loc3_] != 0)
                           {
                              if(!(_loc5_ < 0))
                              {
                                 if(!(this.adat[_loc2_].arm == _loc5_) && !(this.adat[_loc3_].arm == _loc5_))
                                 {
                                    continue;
                                 }
                              }
                              if(this.adat[_loc3_].dice <= this.adat[_loc2_].dice)
                              {
                                 if(this.adat[_loc3_].dice == this.adat[_loc2_].dice)
                                 {
                                    var _loc8_ = this.adat[_loc3_].arm;
                                    var _loc4_ = 0;
                                    if(this.player[_loc9_].dice_jun == 0)
                                    {
                                       _loc4_ = 1;
                                    }
                                    if(this.player[_loc8_].dice_jun == 0)
                                    {
                                       _loc4_ = 1;
                                    }
                                    if(Math.random() * 10 > 1)
                                    {
                                       _loc4_ = 1;
                                    }
                                    if(_loc4_ == 0)
                                    {
                                       continue;
                                    }
                                 }
                                 this.list_from[_loc6_] = _loc2_;
                                 this.list_to[_loc6_] = _loc3_;
                                 _loc6_ = _loc6_ + 1;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      if(_loc6_ == 0)
      {
         return 0;
      }
      var _loc12_ = Math.floor(Math.random() * _loc6_);
      this.area_from = this.list_from[_loc12_];
      this.area_to = this.list_to[_loc12_];
   }
   function set_his(from, to, res)
   {
      this.his[this.his_c] = new dw.HistoryData();
      this.his[this.his_c].from = from;
      this.his[this.his_c].to = to;
      this.his[this.his_c].res = res;
      this.his_c = this.his_c + 1;
   }
}
