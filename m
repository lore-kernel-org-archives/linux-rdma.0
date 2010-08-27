From: Chris Worley <worleys@gmail.com>
Subject: Re: What is an IOC device ID and what is DriverStore
Date: Fri, 27 Aug 2010 17:43:59 -0600
Message-ID: <AANLkTinJ8qK8dARDEMM4qzOyTm7sMaLYRt5QmKAsBV6j@mail.gmail.com>
References: <AANLkTikvA8oaksoszCoAvUs=sHp7uap-q+d9=f+AoQ96@mail.gmail.com>
	<946F457324732742B1457FAFC8CF1ECB012DD2B083B6@EXCHANGE2.sbcounty.gov>
	<AANLkTi=PM+ecJ9g_RbUibM-+cx-pZvPiSj5OXZz7DFN-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0335174290=="
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <AANLkTi=PM+ecJ9g_RbUibM-+cx-pZvPiSj5OXZz7DFN-@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Mime-version: 1.0
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Sufficool, Stanley" <ssufficool@rov.sbcounty.gov>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, OFED mailing list <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--===============0335174290==
Content-Type: multipart/alternative; boundary=e0cb4e8878115a4597048ed6b06b

--e0cb4e8878115a4597048ed6b06b
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Aug 27, 2010 at 5:02 PM, Chris Worley <worleys@gmail.com> wrote:
> On Fri, Aug 27, 2010 at 4:45 PM, Sufficool, Stanley
> <ssufficool@rov.sbcounty.gov> wrote:
>>
>>
>>>-----Original Message-----
>>>From: ofw-bounces@lists.openfabrics.org
>>>[mailto:ofw-bounces@lists.openfabrics.org] On Behalf Of Chris Worley
>>>Sent: Friday, August 27, 2010 1:52 PM
>>>To: ofw@lists.openfabrics.org; OFED mailing list
>>>Subject: [ofw] What is an IOC device ID and what is DriverStore
>>>
>>>
>>>In scouring the many manuals with the Window's IB drivers I
>>>found a clue as to why I can't get SRP working in WinOF:
>>>
>>>  Windows PNP (Plug-n-Play) will match the IOC device ID with
>>>DriverStore installed drives and then will load the IBiou.sys driver
>>>
>>>How do I set the "IOC device ID" and what is DriverStore?
>>
>> Not sure what this is, but I have never had to set any values on the
OFED-W initiator.
>>
>>>
>>>I can make the Windows SRP miniport devices appear and
>>>disappear by removing/reloading ib_srpt on the target (at
>>>least with the 2.1.1 driver from Mellanox; the latest at
>>>openfabrics.org panics the WS2008R2 system when ib_srpt is rmmod'ed).
>>>
>>>Beyond that, Windows never sees the drives... Linux initiators
>>>don't have an issue.
>>
>> What messages do you get on the target? It it even receiving the request?
>
> Yes:
>
> ib_srpt: ***ERROR***: received unrecognized IB CM event 10
> ib_srpt: Received DREQ and sent DREP for session
> 0x00247100000002c100247100000003d8.
> ib_srpt: Received SRP_LOGIN_REQ with i_port_id
> 0x247100000002c1:0x247100000003d8, t_port_id
> 0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 1
> (guid=0xfe80000000000000:0x247100000002bf)
> ib_srpt: disconnected session 0x00247100000002c100247100000003d8
> because a new SRP_LOGIN_REQ has been received.
> ib_srpt: Session : kernel thread ib_srpt_compl (PID 31542) started
> scst: Using security group "Default" for initiator
> "0x00247100000002c100247100000003d8"

There is more to it than that.  I'm going to do this as HTML so I can fix
the font:

ib_srpt: Received SRP_LOGIN_REQ with i_port_id
0x247100000002c1:0x247100000003d8, t_port_id
0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 2
(guid=0xfe80000000000000:0x247100000002c3)
ib_srpt: Session : kernel thread ib_srpt_compl (PID 1109) started
scst: Using security group "Default" for initiator
"0x00247100000002c100247100000003d8"
scst: Processing thread fio-719570_0 (PID 1110) started
scst: Processing thread fio-719570_1 (PID 1111) started
scst: Processing thread fio-719620_0 (PID 1112) started
scst: Processing thread fio-719620_1 (PID 1113) started
scst: Processing thread fio-719650_0 (PID 1114) started
scst: Processing thread fio-719650_1 (PID 1115) started
scst: Processing thread fio-719640_0 (PID 1116) started
scst: Processing thread fio-719640_1 (PID 1117) started
scst: Processing thread fio-410000_0 (PID 1118) started
scst: Processing thread fio-410000_1 (PID 1119) started
scst: Processing thread fio-410020_0 (PID 1120) started
scst: Processing thread fio-410020_1 (PID 1121) started
scst: Processing thread fio-409480_0 (PID 1122) started
scst: Processing thread fio-409480_1 (PID 1123) started
scst: Processing thread fio-410010_0 (PID 1124) started
scst: Processing thread fio-410010_1 (PID 1125) started
ib_srpt: ***ERROR***: received unrecognized IB CM event 10
ib_srpt: Received DREQ and sent DREP for session
0x00247100000002c100247100000003d8.
ib_srpt: Received InfiniBand TimeWait exit for cm_id ffff81030b7c6c00.
ib_srpt: Session 0x00247100000002c100247100000003d8: kernel thread
ib_srpt_compl (PID 1109) stopped
scst: Processing thread fio-719570_0 (PID 1110) finished
scst: Processing thread fio-719570_1 (PID 1111) finished
scst: Processing thread fio-719620_0 (PID 1112) finished
scst: Processing thread fio-719620_1 (PID 1113) finished
scst: Processing thread fio-719650_0 (PID 1114) finished
scst: Processing thread fio-719650_1 (PID 1115) finished
scst: Processing thread fio-719640_0 (PID 1116) finished
scst: Processing thread fio-719640_1 (PID 1117) finished
scst: Processing thread fio-410000_0 (PID 1118) finished
scst: Processing thread fio-410000_1 (PID 1119) finished
scst: Processing thread fio-410020_0 (PID 1120) finished
scst: Processing thread fio-410020_1 (PID 1121) finished
scst: Processing thread fio-409480_0 (PID 1122) finished
scst: Processing thread fio-409480_1 (PID 1123) finished
scst: Processing thread fio-410010_0 (PID 1124) finished
scst: Processing thread fio-410010_1 (PID 1125) finished
ib_srpt: Received SRP_LOGIN_REQ with i_port_id
0x247100000002c1:0x24710000000390, t_port_id
0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 2
(guid=0xfe80000000000000:0x247100000002c0)
ib_srpt: Session : kernel thread ib_srpt_compl (PID 1138) started
scst: Using security group "Default" for initiator
"0x00247100000002c10024710000000390"
scst: Processing thread fio-719570_0 (PID 1139) started
scst: Processing thread fio-719570_1 (PID 1140) started
scst: Processing thread fio-719620_0 (PID 1141) started
scst: Processing thread fio-719620_1 (PID 1142) started
scst: Processing thread fio-719650_0 (PID 1143) started
scst: Processing thread fio-719650_1 (PID 1144) started
scst: Processing thread fio-719640_0 (PID 1145) started
scst: Processing thread fio-719640_1 (PID 1146) started
scst: Processing thread fio-410000_0 (PID 1147) started
scst: Processing thread fio-410000_1 (PID 1148) started
scst: Processing thread fio-410020_0 (PID 1149) started
scst: Processing thread fio-410020_1 (PID 1150) started
scst: Processing thread fio-409480_0 (PID 1151) started
scst: Processing thread fio-409480_1 (PID 1152) started
scst: Processing thread fio-410010_0 (PID 1153) started
scst: Processing thread fio-410010_1 (PID 1154) started
ib_srpt: ***ERROR***: received unrecognized IB CM event 10
ib_srpt: Received DREQ and sent DREP for session
0x00247100000002c10024710000000390.
ib_srpt: Received InfiniBand TimeWait exit for cm_id ffff810191ae5400.
ib_srpt: Session 0x00247100000002c10024710000000390: kernel thread
ib_srpt_compl (PID 1138) stopped
scst: Processing thread fio-719570_0 (PID 1139) finished
scst: Processing thread fio-719570_1 (PID 1140) finished
scst: Processing thread fio-719620_0 (PID 1141) finished
scst: Processing thread fio-719620_1 (PID 1142) finished
scst: Processing thread fio-719650_0 (PID 1143) finished
scst: Processing thread fio-719650_1 (PID 1144) finished
scst: Processing thread fio-719640_0 (PID 1145) finished
scst: Processing thread fio-719640_1 (PID 1146) finished
scst: Processing thread fio-410000_0 (PID 1147) finished
scst: Processing thread fio-410000_1 (PID 1148) finished
scst: Processing thread fio-410020_0 (PID 1149) finished
scst: Processing thread fio-410020_1 (PID 1150) finished
scst: Processing thread fio-409480_0 (PID 1151) finished
scst: Processing thread fio-409480_1 (PID 1152) finished
scst: Processing thread fio-410010_0 (PID 1153) finished
scst: Processing thread fio-410010_1 (PID 1154) finished

While I do have two HCA's in both the target and initiator, I have tried it
with just one in the initiator.

Hopefully that doesn't cause the email to bounce and makes it more readable.

Thanks,

Chris
>
>>
>> Does windows disk management show a broken LUN?
>
> No.  Nothing (except local drives).
>>
>>>
>>>Someone throw me a bone!  The SRP initiator seems to have been
>>>broken for many months on WinDoh's.
>>
>> I have had no problems with the SRP initiator as long as I start the
target _after_ the windows systems boot.
>
> I've tried five different revs of the Windows driver, and no drives are
seen.
>
> Thanks,
>
> Chris
>>
>>>
>>>Thanks,
>>>
>>>Chris
>>>_______________________________________________
>>>ofw mailing list
>>>ofw@lists.openfabrics.org
>>>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>>>
>>
>

--e0cb4e8878115a4597048ed6b06b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 27, 2010 at 5:02 PM, Chris Worley &lt;<a href=3D"mailto:worleys=
@gmail.com">worleys@gmail.com</a>&gt; wrote:<br>&gt; On Fri, Aug 27, 2010 a=
t 4:45 PM, Sufficool, Stanley<br>&gt; &lt;<a href=3D"mailto:ssufficool@rov.=
sbcounty.gov">ssufficool@rov.sbcounty.gov</a>&gt; wrote:<br>
&gt;&gt;<br>&gt;&gt;<br>&gt;&gt;&gt;-----Original Message-----<br>&gt;&gt;&=
gt;From: <a href=3D"mailto:ofw-bounces@lists.openfabrics.org">ofw-bounces@l=
ists.openfabrics.org</a><br>&gt;&gt;&gt;[mailto:<a href=3D"mailto:ofw-bounc=
es@lists.openfabrics.org">ofw-bounces@lists.openfabrics.org</a>] On Behalf =
Of Chris Worley<br>
&gt;&gt;&gt;Sent: Friday, August 27, 2010 1:52 PM<br>&gt;&gt;&gt;To: <a hre=
f=3D"mailto:ofw@lists.openfabrics.org">ofw@lists.openfabrics.org</a>; OFED =
mailing list<br>&gt;&gt;&gt;Subject: [ofw] What is an IOC device ID and wha=
t is DriverStore<br>
&gt;&gt;&gt;<br>&gt;&gt;&gt;<br>&gt;&gt;&gt;In scouring the many manuals wi=
th the Window&#39;s IB drivers I<br>&gt;&gt;&gt;found a clue as to why I ca=
n&#39;t get SRP working in WinOF:<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; =A0Window=
s PNP (Plug-n-Play) will match the IOC device ID with<br>
&gt;&gt;&gt;DriverStore installed drives and then will load the IBiou.sys d=
river<br>&gt;&gt;&gt;<br>&gt;&gt;&gt;How do I set the &quot;IOC device ID&q=
uot; and what is DriverStore?<br>&gt;&gt;<br>&gt;&gt; Not sure what this is=
, but I have never had to set any values on the OFED-W initiator.<br>
&gt;&gt;<br>&gt;&gt;&gt;<br>&gt;&gt;&gt;I can make the Windows SRP miniport=
 devices appear and<br>&gt;&gt;&gt;disappear by removing/reloading ib_srpt =
on the target (at<br>&gt;&gt;&gt;least with the 2.1.1 driver from Mellanox;=
 the latest at<br>
&gt;&gt;&gt;<a href=3D"http://openfabrics.org">openfabrics.org</a> panics t=
he WS2008R2 system when ib_srpt is rmmod&#39;ed).<br>&gt;&gt;&gt;<br>&gt;&g=
t;&gt;Beyond that, Windows never sees the drives... Linux initiators<br>&gt=
;&gt;&gt;don&#39;t have an issue.<br>
&gt;&gt;<br>&gt;&gt; What messages do you get on the target? It it even rec=
eiving the request?<br>&gt;<br>&gt; Yes:<br>&gt;<br>&gt; ib_srpt: ***ERROR*=
**: received unrecognized IB CM event 10<br>&gt; ib_srpt: Received DREQ and=
 sent DREP for session<br>
&gt; 0x00247100000002c100247100000003d8.<br>&gt; ib_srpt: Received SRP_LOGI=
N_REQ with i_port_id<br>&gt; 0x247100000002c1:0x247100000003d8, t_port_id<b=
r>&gt; 0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 1<br>
&gt; (guid=3D0xfe80000000000000:0x247100000002bf)<br>&gt; ib_srpt: disconne=
cted session 0x00247100000002c100247100000003d8<br>&gt; because a new SRP_L=
OGIN_REQ has been received.<br>&gt; ib_srpt: Session : kernel thread ib_srp=
t_compl (PID 31542) started<br>
&gt; scst: Using security group &quot;Default&quot; for initiator<br>&gt; &=
quot;0x00247100000002c100247100000003d8&quot;<br><br>There is more to it th=
an that. =A0I&#39;m going to do this as HTML so I can fix the font:<br><br>
<font face=3D"courier new,monospace">ib_srpt: Received SRP_LOGIN_REQ with i=
_port_id 0x247100000002c1:0x247100000003d8, t_port_id 0x247100000002c1:0x24=
7100000002c1 and it_iu_len 4148 on port 2 (guid=3D0xfe80000000000000:0x2471=
00000002c3)<br>
ib_srpt: Session : kernel thread ib_srpt_compl (PID 1109) started<br>scst: =
Using security group &quot;Default&quot; for initiator &quot;0x002471000000=
02c100247100000003d8&quot;<br>scst: Processing thread fio-719570_0 (PID 111=
0) started<br>
scst: Processing thread fio-719570_1 (PID 1111) started<br>scst: Processing=
 thread fio-719620_0 (PID 1112) started<br>scst: Processing thread fio-7196=
20_1 (PID 1113) started<br>scst: Processing thread fio-719650_0 (PID 1114) =
started<br>
scst: Processing thread fio-719650_1 (PID 1115) started<br>scst: Processing=
 thread fio-719640_0 (PID 1116) started<br>scst: Processing thread fio-7196=
40_1 (PID 1117) started<br>scst: Processing thread fio-410000_0 (PID 1118) =
started<br>
scst: Processing thread fio-410000_1 (PID 1119) started<br>scst: Processing=
 thread fio-410020_0 (PID 1120) started<br>scst: Processing thread fio-4100=
20_1 (PID 1121) started<br>scst: Processing thread fio-409480_0 (PID 1122) =
started<br>
scst: Processing thread fio-409480_1 (PID 1123) started<br>scst: Processing=
 thread fio-410010_0 (PID 1124) started<br>scst: Processing thread fio-4100=
10_1 (PID 1125) started<br>ib_srpt: ***ERROR***: received unrecognized IB C=
M event 10<br>
ib_srpt: Received DREQ and sent DREP for session 0x00247100000002c100247100=
000003d8.<br>ib_srpt: Received InfiniBand TimeWait exit for cm_id ffff81030=
b7c6c00.<br>ib_srpt: Session 0x00247100000002c100247100000003d8: kernel thr=
ead ib_srpt_compl (PID 1109) stopped<br>
scst: Processing thread fio-719570_0 (PID 1110) finished<br>scst: Processin=
g thread fio-719570_1 (PID 1111) finished<br>scst: Processing thread fio-71=
9620_0 (PID 1112) finished<br>scst: Processing thread fio-719620_1 (PID 111=
3) finished<br>
scst: Processing thread fio-719650_0 (PID 1114) finished<br>scst: Processin=
g thread fio-719650_1 (PID 1115) finished<br>scst: Processing thread fio-71=
9640_0 (PID 1116) finished<br>scst: Processing thread fio-719640_1 (PID 111=
7) finished<br>
scst: Processing thread fio-410000_0 (PID 1118) finished<br>scst: Processin=
g thread fio-410000_1 (PID 1119) finished<br>scst: Processing thread fio-41=
0020_0 (PID 1120) finished<br>scst: Processing thread fio-410020_1 (PID 112=
1) finished<br>
scst: Processing thread fio-409480_0 (PID 1122) finished<br>scst: Processin=
g thread fio-409480_1 (PID 1123) finished<br>scst: Processing thread fio-41=
0010_0 (PID 1124) finished<br>scst: Processing thread fio-410010_1 (PID 112=
5) finished<br>
ib_srpt: Received SRP_LOGIN_REQ with i_port_id 0x247100000002c1:0x247100000=
00390, t_port_id 0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on po=
rt 2 (guid=3D0xfe80000000000000:0x247100000002c0)<br>ib_srpt: Session : ker=
nel thread ib_srpt_compl (PID 1138) started<br>
scst: Using security group &quot;Default&quot; for initiator &quot;0x002471=
00000002c10024710000000390&quot;<br>scst: Processing thread fio-719570_0 (P=
ID 1139) started<br>scst: Processing thread fio-719570_1 (PID 1140) started=
<br>
scst: Processing thread fio-719620_0 (PID 1141) started<br>scst: Processing=
 thread fio-719620_1 (PID 1142) started<br>scst: Processing thread fio-7196=
50_0 (PID 1143) started<br>scst: Processing thread fio-719650_1 (PID 1144) =
started<br>
scst: Processing thread fio-719640_0 (PID 1145) started<br>scst: Processing=
 thread fio-719640_1 (PID 1146) started<br>scst: Processing thread fio-4100=
00_0 (PID 1147) started<br>scst: Processing thread fio-410000_1 (PID 1148) =
started<br>
scst: Processing thread fio-410020_0 (PID 1149) started<br>scst: Processing=
 thread fio-410020_1 (PID 1150) started<br>scst: Processing thread fio-4094=
80_0 (PID 1151) started<br>scst: Processing thread fio-409480_1 (PID 1152) =
started<br>
scst: Processing thread fio-410010_0 (PID 1153) started<br>scst: Processing=
 thread fio-410010_1 (PID 1154) started<br>ib_srpt: ***ERROR***: received u=
nrecognized IB CM event 10<br>ib_srpt: Received DREQ and sent DREP for sess=
ion 0x00247100000002c10024710000000390.<br>
ib_srpt: Received InfiniBand TimeWait exit for cm_id ffff810191ae5400.<br>i=
b_srpt: Session 0x00247100000002c10024710000000390: kernel thread ib_srpt_c=
ompl (PID 1138) stopped<br>scst: Processing thread fio-719570_0 (PID 1139) =
finished<br>
scst: Processing thread fio-719570_1 (PID 1140) finished<br>scst: Processin=
g thread fio-719620_0 (PID 1141) finished<br>scst: Processing thread fio-71=
9620_1 (PID 1142) finished<br>scst: Processing thread fio-719650_0 (PID 114=
3) finished<br>
scst: Processing thread fio-719650_1 (PID 1144) finished<br>scst: Processin=
g thread fio-719640_0 (PID 1145) finished<br>scst: Processing thread fio-71=
9640_1 (PID 1146) finished<br>scst: Processing thread fio-410000_0 (PID 114=
7) finished<br>
scst: Processing thread fio-410000_1 (PID 1148) finished<br>scst: Processin=
g thread fio-410020_0 (PID 1149) finished<br>scst: Processing thread fio-41=
0020_1 (PID 1150) finished<br>scst: Processing thread fio-409480_0 (PID 115=
1) finished<br>
scst: Processing thread fio-409480_1 (PID 1152) finished<br>scst: Processin=
g thread fio-410010_0 (PID 1153) finished<br>scst: Processing thread fio-41=
0010_1 (PID 1154) finished<br></font><br>While I do have two HCA&#39;s in b=
oth the target and initiator, I have tried it with just one in the initiato=
r.<br>
<br>Hopefully that doesn&#39;t cause the email to bounce and makes it more =
readable.<br><br>Thanks,<br><br>Chris<br>&gt;<br>&gt;&gt;<br>&gt;&gt; Does =
windows disk management show a broken LUN?<br>&gt;<br>&gt; No. =A0Nothing (=
except local drives).<br>
&gt;&gt;<br>&gt;&gt;&gt;<br>&gt;&gt;&gt;Someone throw me a bone! =A0The SRP=
 initiator seems to have been<br>&gt;&gt;&gt;broken for many months on WinD=
oh&#39;s.<br>&gt;&gt;<br>&gt;&gt; I have had no problems with the SRP initi=
ator as long as I start the target _after_ the windows systems boot.<br>
&gt;<br>&gt; I&#39;ve tried five different revs of the Windows driver, and =
no drives are seen.<br>&gt;<br>&gt; Thanks,<br>&gt;<br>&gt; Chris<br>&gt;&g=
t;<br>&gt;&gt;&gt;<br>&gt;&gt;&gt;Thanks,<br>&gt;&gt;&gt;<br>&gt;&gt;&gt;Ch=
ris<br>
&gt;&gt;&gt;_______________________________________________<br>&gt;&gt;&gt;=
ofw mailing list<br>&gt;&gt;&gt;<a href=3D"mailto:ofw@lists.openfabrics.org=
">ofw@lists.openfabrics.org</a><br>&gt;&gt;&gt;<a href=3D"http://lists.open=
fabrics.org/cgi-bin/mailman/listinfo/ofw">http://lists.openfabrics.org/cgi-=
bin/mailman/listinfo/ofw</a><br>
&gt;&gt;&gt;<br>&gt;&gt;<br>&gt;<br><br>

--e0cb4e8878115a4597048ed6b06b--

--===============0335174290==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ofw mailing list
ofw@lists.openfabrics.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
--===============0335174290==--
