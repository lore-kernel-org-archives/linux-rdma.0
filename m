From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: help trying to track down issue with opensm port
Date: Fri, 11 Jun 2010 15:15:44 -0400
Message-ID: <AANLkTilmg1NoBZkhzNU6kRZN0xTa89mCPtYGuzIQxWuw@mail.gmail.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F643455@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F643455-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 11, 2010 at 2:29 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> The following opensm log is from a windows port of opensm 3.3.6. =C2=A0=
Can anyone familiar with the error messages explain whether the errors =
that are reported should ever happen? =C2=A0Error 9 is a timeout, so I'=
m not concerned about that. =C2=A0I am concerned about the 'failed to o=
btain request madw' errors.

It means that the umad vendor layer was unable to find a transaction
ID match in the match table. I'm not sure why since there were no
error messages relating to match table overflow. Looks like they are
on GetTableResp methods (RMPP). Not sure how that works in Windows.

-- Hal

>
> - Sean
>
> [Jun-10-2010 15:45:37:486][0C2C] 0x03 -> OpenSM 3.3.6 UMAD
> [Jun-10-2010 15:45:37:486][0C2C] 0x80 -> OpenSM 3.3.6 UMAD
> [Jun-10-2010 15:45:37:501][0C2C] 0x02 -> osm_vendor_init: 1000 pendin=
g umads specified
> [Jun-10-2010 15:45:37:501][0C2C] 0x80 -> Entering DISCOVERING state
> [Jun-10-2010 15:45:37:501][0C2C] 0x02 -> osm_vendor_bind: Binding to =
port 0x2c9020000409d
> [Jun-10-2010 15:45:37:548][0C2C] 0x02 -> osm_vendor_bind: Binding to =
port 0x2c9020000409d
> [Jun-10-2010 15:45:37:548][0C2C] 0x02 -> osm_opensm_bind: Setting IS_=
SM on port 0x0002c9020000409d
> [Jun-10-2010 15:45:38:375][08E0] 0x01 -> umad_receiver: ERR 5411: DR =
SMP Send completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Method 0x1, Attr 0x20, TID 0x12a5, Hop Ptr: 0x0
> [Jun-10-2010 15:45:38:375][08E0] 0x01 -> Received SMP on a 2 hop path=
: Initial path =3D 0,1,10, Return path =C2=A0=3D 0,0,0
> [Jun-10-2010 15:45:38:375][08E0] 0x01 -> sm_mad_ctrl_send_err_cb: ERR=
 3113: MAD completed in error (IB_TIMEOUT): SubnGet(SMInfo), attr_mod 0=
x0, TID 0x12a5
> [Jun-10-2010 15:45:38:375][08E0] 0x01 -> umad_receiver: ERR 5411: DR =
SMP Send completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Method 0x1, Attr 0x20, TID 0x12a8, Hop Ptr: 0x0
> [Jun-10-2010 15:45:38:375][08E0] 0x01 -> Received SMP on a 2 hop path=
: Initial path =3D 0,1,14, Return path =C2=A0=3D 0,0,0
> [Jun-10-2010 15:45:38:375][08E0] 0x01 -> sm_mad_ctrl_send_err_cb: ERR=
 3113: MAD completed in error (IB_TIMEOUT): SubnGet(SMInfo), attr_mod 0=
x0, TID 0x12a8
> [Jun-10-2010 15:45:38:375][0CCC] 0x80 -> Entering MASTER state
> [Jun-10-2010 15:45:38:375][0CCC] 0x02 -> osm_ucast_mgr_process: minho=
p tables configured on all switches
> [Jun-10-2010 15:45:38:375][0A1C] 0x01 -> log_trap_info: Received Gene=
ric Notice type:4 num:144 (CapabilityMask, NodeDescription, Link [Width=
|Speed] Enabled, SM priority changed) Producer:1 (Channel Adapter) from=
 LID:7 TID:0x0000000000000010
> [Jun-10-2010 15:45:38:375][0A1C] 0x01 -> osm_get_port_by_mad_addr: ER=
R 7504: Lid is out of range: 0
> [Jun-10-2010 15:45:38:375][0A1C] 0x01 -> trap_rcv_process_request: ER=
R 3809: Failed to find source physical port for trap
> [Jun-10-2010 15:45:38:375][0A1C] 0x02 -> log_notice: Reporting Generi=
c Notice type:4 num:144 (CapabilityMask, NodeDescription, Link [Width|S=
peed] Enabled, SM priority changed) from LID:7 GID:fe80::2:c902:0:409d
>
> [Jun-10-2010 15:45:38:375][0CCC] 0x80 -> SUBNET UP
>
> [Jun-10-2010 15:45:38:609][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x11, TID 0x10001b90b, LID 1=
7
> [Jun-10-2010 15:45:38:609][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x11=
 tid=3D0x10001b90b) -- dropping
> [Jun-10-2010 15:45:38:609][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x35, TID 0x10001b90c, LID 1=
7
> [Jun-10-2010 15:45:38:609][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x35=
 tid=3D0x10001b90c) -- dropping
> [Jun-10-2010 15:45:38:609][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x11, TID 0x10000012a, LID 1
> [Jun-10-2010 15:45:38:609][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x11=
 tid=3D0x10000012a) -- dropping
> [Jun-10-2010 15:45:38:625][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x35, TID 0x100016375, LID 4
> [Jun-10-2010 15:45:38:625][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x35=
 tid=3D0x100016375) -- dropping
> [Jun-10-2010 15:45:38:625][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x11, TID 0x100016374, LID 4
> [Jun-10-2010 15:45:38:625][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x11=
 tid=3D0x100016374) -- dropping
> [Jun-10-2010 15:45:38:625][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x35, TID 0x100000d38, LID 6
> [Jun-10-2010 15:45:38:625][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x35=
 tid=3D0x100000d38) -- dropping
> [Jun-10-2010 15:45:38:625][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x11, TID 0x100000d37, LID 6
> [Jun-10-2010 15:45:38:625][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x11=
 tid=3D0x100000d37) -- dropping
> [Jun-10-2010 15:45:38:874][0D5C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:40=
1b:ffff::ffff:ffff
> [Jun-10-2010 15:45:38:874][0D5C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:40=
1b:ffff::1
> [Jun-10-2010 15:45:38:874][0630] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:40=
1b:ffff::7f:fffa
> [Jun-10-2010 15:45:38:874][0EF0] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:0:1
> [Jun-10-2010 15:45:38:874][0630] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:1:3
> [Jun-10-2010 15:45:38:874][0A1C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ffb7:99a9
> [Jun-10-2010 15:45:38:874][0EF0] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:40=
1b:ffff::fc
> [Jun-10-2010 15:45:38:874][0A1C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ffb8:a9ed
> [Jun-10-2010 15:45:38:874][0D5C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:0:c
> [Jun-10-2010 15:45:38:874][0630] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ffe9:b65e
> [Jun-10-2010 15:45:38:890][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x38, TID 0x1000003cd, LID 7
> [Jun-10-2010 15:45:38:890][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x38=
 tid=3D0x1000003cd) -- dropping
> [Jun-10-2010 15:45:38:890][0D5C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ffac:bad6
> [Jun-10-2010 15:45:38:890][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x38, TID 0x100000ddb, LID 1=
5
> [Jun-10-2010 15:45:38:890][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x38=
 tid=3D0x100000ddb) -- dropping
> [Jun-10-2010 15:45:38:890][0EF0] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ff4a:4b54
> [Jun-10-2010 15:45:38:890][0630] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::180:c200:3
> [Jun-10-2010 15:45:38:890][0A1C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ffc0:77dc
> [Jun-10-2010 15:45:38:890][0A1C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ff90:fd62
> [Jun-10-2010 15:45:38:890][0A1C] 0x01 -> mcmr_rcv_leave_mgrp: ERR 1B2=
5: Received an invalid delete request for MGID: ff12:401b:ffff::1 for P=
ortGID: fe80::2:c902:0:25a5
> [Jun-10-2010 15:45:38:890][0A1C] 0x01 -> mcmr_rcv_leave_mgrp: ERR 1B2=
5: Received an invalid delete request for MGID: ff12:1405:ffff::180:c20=
0:3 for PortGID: fe80::2:c902:0:25a5
> [Jun-10-2010 15:45:38:890][0EF0] 0x01 -> mcmr_rcv_leave_mgrp: ERR 1B2=
5: Received an invalid delete request for MGID: ff12:401b:ffff::ffff:ff=
ff for PortGID: fe80::2:c902:0:25a5
> [Jun-10-2010 15:45:38:890][0EF0] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:40=
1b:ffff::16
> [Jun-10-2010 15:45:38:890][0D5C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:0:16
> [Jun-10-2010 15:45:38:890][0D5C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ffeb:5867
> [Jun-10-2010 15:45:38:890][0EF0] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:ff70:431e
> [Jun-10-2010 15:45:38:937][0630] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:1:2
> [Jun-10-2010 15:45:39:202][08E0] 0x01 -> umad_receiver: ERR 5411: DR =
SMP Send completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Method 0x1, Attr 0x20, TID 0x130a, Hop Ptr: 0x0
> [Jun-10-2010 15:45:39:202][08E0] 0x01 -> Received SMP on a 2 hop path=
: Initial path =3D 0,1,14, Return path =C2=A0=3D 0,0,0
> [Jun-10-2010 15:45:39:202][08E0] 0x01 -> sm_mad_ctrl_send_err_cb: ERR=
 3113: MAD completed in error (IB_TIMEOUT): SubnGet(SMInfo), attr_mod 0=
x0, TID 0x130a
> [Jun-10-2010 15:45:39:202][08E0] 0x01 -> umad_receiver: ERR 5411: DR =
SMP Send completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Method 0x1, Attr 0x20, TID 0x130b, Hop Ptr: 0x0
> [Jun-10-2010 15:45:39:202][08E0] 0x01 -> Received SMP on a 2 hop path=
: Initial path =3D 0,1,10, Return path =C2=A0=3D 0,0,0
> [Jun-10-2010 15:45:39:202][08E0] 0x01 -> sm_mad_ctrl_send_err_cb: ERR=
 3113: MAD completed in error (IB_TIMEOUT): SubnGet(SMInfo), attr_mod 0=
x0, TID 0x130b
> [Jun-10-2010 15:45:39:202][0CCC] 0x02 -> osm_ucast_mgr_process: minho=
p tables configured on all switches
> [Jun-10-2010 15:45:39:217][0CCC] 0x02 -> SUBNET UP
> [Jun-10-2010 15:45:39:342][0630] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:14=
05:ffff::3333:0:2
> [Jun-10-2010 15:45:40:372][0A1C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:40=
1b:ffff::fb
> [Jun-10-2010 15:45:45:364][0EF0] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:60=
1b:ffff::fb
> [Jun-10-2010 15:45:45:379][0A1C] 0x02 -> log_notice: Reporting Generi=
c Notice type:3 num:66 (New mcast group created) from LID:7 GID:ff12:60=
1b:ffff::1:ff00:525d
> [Jun-10-2010 15:45:49:482][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x11, TID 0x400000002, LID 3
> [Jun-10-2010 15:45:49:482][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x11=
 tid=3D0x400000002) -- dropping
> [Jun-10-2010 15:45:50:481][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x11, TID 0x400000002, LID 3
> [Jun-10-2010 15:45:50:481][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x11=
 tid=3D0x400000002) -- dropping
> [Jun-10-2010 15:45:51:479][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x11, TID 0x400000002, LID 3
> [Jun-10-2010 15:45:51:479][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x11=
 tid=3D0x400000002) -- dropping
> [Jun-10-2010 15:45:52:477][08E0] 0x01 -> umad_receiver: ERR 5410: Sen=
d completed with error(9) -- dropping
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Class 0x3, Method 0x92, Attr 0x11, TID 0x400000002, LID 3
> [Jun-10-2010 15:45:52:477][08E0] 0x01 -> umad_receiver: ERR 5412: Fai=
led to obtain request madw for timed out MAD (method=3D0x92 attr=3D0x11=
 tid=3D0x400000002) -- dropping
> [Jun-10-2010 15:45:59:856][0C2C] 0x80 -> Exiting SM
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
