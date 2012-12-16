From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: umad_send with service level higher than 0 does not work
Date: Sun, 16 Dec 2012 08:48:04 -0500
Message-ID: <50CDD114.2090706@dev.mellanox.co.il>
References: <0D9917EC-D7A3-4786-BE38-60F6990BA3E1@m.titech.ac.jp> <50CB2DF3.7020409@dev.mellanox.co.il> <53BC3D57-0D23-488F-A3A5-DFB2EEAB3016@m.titech.ac.jp> <50CB56E9.70900@dev.mellanox.co.il> <1B48E229-0016-4829-BC73-372CB5B6F21F@m.titech.ac.jp> <50CB76F2.70003@dev.mellanox.co.il> <BAADC764-74C8-48EB-B45B-DFB83A313258@m.titech.ac.jp> <50CB8F90.1030701@dev.mellanox.co.il> <195255BB-E0F4-4F0E-A69A-4FC9A041ECC0@m.titech.ac.jp> <50CDBF61.3080100@dev.mellanox.co.il> <396B5E4F-211E-405A-8D39-EF34BE565CFD@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <396B5E4F-211E-405A-8D39-EF34BE565CFD@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/16/2012 8:39 AM, Jens Domke wrote:
> Hi,
>=20
> On Dec 16, 2012, at 9:32 PM, Hal Rosenstock wrote:
>=20
>> Hi,
>>
>> On 12/16/2012 7:03 AM, Jens Domke wrote:
>>> Hello Hal,
>>>
>>> On Dec 15, 2012, at 5:44 AM, Hal Rosenstock wrote:
>>>
>>>> Hi,
>>>>
>>>> On 12/14/2012 3:32 PM, Jens Domke wrote:
>>>>> Hello Hal,
>>>>>
>>>>> On Dec 15, 2012, at 3:58 AM, Hal Rosenstock wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> On 12/14/2012 1:24 PM, Jens Domke wrote:
>>>>>>> Hello Hal,
>>>>>>>
>>>>>>> On Dec 15, 2012, at 1:42 AM, Hal Rosenstock wrote:
>>>>>>>
>>>>>>>> Hi again,
>>>>>>>>
>>>>>>>> On 12/14/2012 10:17 AM, Jens Domke wrote:
>>>>>>>>> Hello Hal,
>>>>>>>>>
>>>>>>>>> thank you for the fast response. I will try to clarify some p=
oints.
>>>>>>>>>
>>>>>>>>>>> d) OpenMPI runs are executed with "--mca btl_openib_ib_path=
_record_service_level 1"
>>>>>>>>>>
>>>>>>>>>> I'm not familiar with what DFSSSP does to figure out SLs exa=
ctly but
>>>>>>>>>> there should be no need to set this. The proper SL for query=
ing the SA
>>>>>>>>>> for PathRecords, etc. is always in PortInfo.SMSL. In the cas=
e of DFSSSP
>>>>>>>>>> (and other QoS based routing algorithms), it calculates that=
 and the SM
>>>>>>>>>> pushes this into each port. That should be used. It's possib=
le that SL1
>>>>>>>>>> is not a valid SL for port <-> SA querying using DFSSSP.
>>>>>>>>> The OpenMPI parameter btl_openib_ib_path_record_service_level=
 does not specify the SL for querying the PathRecords.
>>>>>>>>> It just enables the functionality. And the ompi processes use=
 the PortInfo.SMSL to send the request.
>>>>>>>>> For the request "port -> SA" every 0<=3DSL<=3D7 was used in t=
he test, and the SA received the requests. =20
>>>>>>>>>>
>>>>>>>>>>> e) kernel 2.6.32-220.13.1.el6.x86_64
>>>>>>>>>>>
>>>>>>>>>>> As far as I understand the whole system:
>>>>>>>>>>> 1. the OMPI processes are sending MAD requests (SubnAdmGet:=
PathRecord) to the OpenSM
>>>>>>>>>>> 2. the SA receives the request on QP1
>>>>>>>>>>
>>>>>>>>>> There is the SL in the query itself. This should be the SMSL=
 that the SM
>>>>>>>>>> set for that port.
>>>>>>>>> Hmm, there you might have a point. I think I saw that the que=
ry itself had SL=3D0 specified.
>>>>>>>>> In fact OpenMPI sets everthing to 0 except for slid and dlid.
>>>>>>>>>>
>>>>>>>>>>> 3. SA asks the routing algorithm (like LASH, DFSSSP or Toru=
s_2QoS) about a special service level for the slid/dlid path
>>>>>>>>>>
>>>>>>>>>> This is a (potentially) different SL (for MPI<->MPI port com=
munication)
>>>>>>>>>> than the one the query used and is the one returned inside t=
he
>>>>>>>>>> PathRecord attribute/data.
>>>>>>>>> Yes, it can be different, but DFSSSP sets the same SL, becaus=
e the SM is running on a port which is also used for MPI comm.
>>>>>>>>
>>>>>>>> With DFSSSP are all SLs same from source port to get to any de=
stination ?
>>>>>>> No, not necessarily. In general DFSSSP does not enforce SL(LID1=
->LID2) =3D=3D SL(LID2->LID1) or SL(LID1->LID2) =3D=3D SL(LID1->LID3).
>>>>>>
>>>>>> If SL(LID1->LID2) !=3D SL(LID2->LID1), that's not a reversible p=
ath.
>>>>> True. But i don't think that the SA asks the DFSSSP routing about=
 the SL for the reversible path.
>>>>> So, the SA could use any SL which is a valid SL, even if the DFSS=
SP would recommend another SL.
>>>>>
>>>>> I just read the IB Specs and it says, that "SL specified in the r=
eceived packet is used as the SL in the response packet" for MAD packet=
s.
>>>>> So, its most likely, that there is a mismatch in the way how OMPI=
 does the setup of the PathRequest and the way how the SA does build th=
e respond packet.
>>>>> OMPI always specifies SL=3D0 (lets say SL_a) inside of the PathRe=
quest packet,=20
>>>>
>>>> So CompMask in the query has the SL bit on and SL is set to 0 insi=
de the
>>>> SubAdmGet of PatchRecord ?
>>>
>>> No, the CompMask didn't had the SL bit and the SL was set to 0.
>>
>> That means the SL in the request is wildcarded so the SA/SM fills in=
 a
>> valid one in the response.
> Ok.
>>
>>> I tried to follow the path of the SL bit (IB_PR_COMPMASK_SL) and th=
e only reference I found was in osm_sa_path_record.c
>>> The SA just treats the SL in the PathRequest as a "I would like to =
use this SL" in case the SL bit is set.
>>> But the routing engine can overwrite the requested SL before the re=
ply is send.
>>>
>>> Nevertheless, I have changed the code of OMPI so that it sets the S=
L bit in the CompMask and sets the SL to SMSL for the PathRequest, so t=
hat SL_a =3D=3D SL_b.
>>> Sadly, the reply send by the SA does not leave the node (for SL_b>0=
). Only if I change the SL to 0 in the MAD right before umad_send is ca=
lled by the SA, the paket is able to leave the node and reaches the OMP=
I process.
>>
>> Are you sure the response doesn't leave the SA node or it's not rece=
ived
>> at the requester (OMPI node) ?
> No, I'm not sure. Is there any possibility to check that? As far as I=
 know, ibdump does not show MAD pakets which leave a port, it only show=
s the pakets when they are received on the other end.
>>
>>>
>>>>
>>>>> and sends the packet on SL_b (PortInfo.SMSL).
>>>>
>>>> Good.
>>>>
>>>>> The SA uses p_mad_addr->addr_type.gsi.service_level, which is SL_=
b, for the response.
>>>>> If SL_b is not 0, then the packet can't reach the OMPI process. R=
ight?
>>>>
>>>> Depends. It may be that both SLs work but maybe not.
>>>>
>>>>> If I analyse this correctly, then there are two bugs. One is in O=
MPI, that it does not specify the SL within the PathRequest in a approp=
riate way (which would be a SL suggested by DFSSSP for the reversible p=
ath). And the second bug is that the SA uses the SL, on which the PathR=
equest packet was send, and not the SL specified within the packet.
>>>>> What do you think?
>>>>
>>>> Yes, it might be better to wildcard the SL in the query. The only
>>>> scenario that would fail with the query you are making if there's =
no SL
>>>> 0 path between the src/dest LIDs or GIDs in the OMPI PathRecord qu=
ery.
>>>> If that's the case, SA should return MAD status 0xc (status code 3=
 -
>>>> ERR_NO_RECORDS). But the response doesn't make it back to the requ=
ester
>>>> OMPI node so it's not even getting that far.
>>>
>>> Yes, exactly. So, do you have an idea why the response hands in the=
 SA node?
>>> I have no inside of the underlying layer (kernel driver and firewar=
e). Maybe there are some implementations, which prevent the SA from sen=
ding MADs back on SL>0?
>>
>> If you're sure this response doesn't get out of the SA node, please
>> contact Mellanox support with the details.
> Ok, I can do this, if it turns out to be true.
>>
>>>>
>>>>> I can try to change the PathRequest of OMPI tomorrow, so that it =
matches addr_type.gsi.service_level.
>>>>> Maybe, with this change the packets of the SA will reach the OMPI=
 process on a SL>0.
>>>>>>
>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> 4. SA sends the PathRecord back to the OMPI process via uma=
d_send in libvendor/osm_vendor_ibumad.c
>>>>>>>>>>
>>>>>>>>>> By the response reversibility rule, I think this is returned=
 on the SL
>>>>>>>>>> of the original query but haven't verified this in the code =
base yet.
>>>>>>>>> Ok, I was not aware of that rule. But if this is true, then t=
he SA should also be able to send via SL>0.
>>>>>>>>
>>>>>>>> I doubled checked and indeed the SA response does use the SL t=
hat the
>>>>>>>> incoming request was received on.
>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> The osm_vendor_send() function builds the MAD packet with t=
he following attributes:
>>>>>>>>>>>    /* GS classes */
>>>>>>>>>>>    umad_set_addr_net(p_vw->umad, p_mad_addr->dest_lid,
>>>>>>>>>>>                      p_mad_addr->addr_type.gsi.remote_qp,
>>>>>>>>>>>                      p_mad_addr->addr_type.gsi.service_leve=
l,
>>>>>>>>>>>                      IB_QP1_WELL_KNOWN_Q_KEY);
>>>>>>>>>>> So, the SL is the same like the one which was used by the O=
MPI process. The Q_Key matches the Q_key on the OMPI process, and remot=
e_qp and dest_lid is correct, too.
>>>>>>>>>>> Afterwards umad_send(=85) is used to send the reply with th=
e PathRecord, and this send does not work (except for SL=3D0).
>>>>>>>>>>
>>>>>>>>>> By not working, what do you mean ? Do you mean it's not rece=
ived at the
>>>>>>>>>> requester with no message in the OpenSM log or not received =
at the
>>>>>>>>>> OpenSM or something else ? It could be due to the wrong SL b=
eing used in
>>>>>>>>>> the original request (forcing it to SL 1). That could cause =
it not to be
>>>>>>>>>> received at the SM or the response not to make it back to th=
e requester
>>>>>>>>>> from the SA if the SL used is not "reversible".
>>>>>>>>> By "not working" I mean, that the MPI process does not receiv=
e any response from the SA.
>>>>>>>>> I get messages from the MPI process like the following:
>>>>>>>>> [rc011][[14851,1],1][connect/btl_openib_connect_sl.c:301:get_=
pathrecord_info] No response from SA after 20 retries
>>>>>>>>> The log of OpenSM shows that the SA received the PathRequest =
query, dumps the query into the log, and sends the reply back.
>>>>>>>>> And I think I was some messages in the log about "=851 outsta=
nding MAD=85".
>>>>>>>>>>
>>>>>>>>>>> If I look into the MAD before it is send, then it looks lik=
e this:
>>>>>>>>>>> Breakpoint 2, umad_send (fd=3D9, agentid=3D2, umad=3D0x7fff=
e8012530, length=3D120, timeout_ms=3D0, retries=3D3)
>>>>>>>>>>> at src/umad.c:791
>>>>>>>>>>> 791             if (umaddebug > 1)
>>>>>>>>>>> (gdb) p *mad
>>>>>>>>>>> $1 =3D {agent_id =3D 2, status =3D 0, timeout_ms =3D 0, ret=
ries =3D 3, length =3D 0, addr =3D {qpn =3D 1325427712, qkey =3D 384,=20
>>>>>>>>>>> lid =3D 4096, sl =3D 6 '\006', path_bits =3D 0 '\000', grh_=
present =3D 0 '\000', gid_index =3D 0 '\000',=20
>>>>>>>>>>> hop_limit =3D 0 '\000', traffic_class =3D 0 '\000', gid =3D=
 '\000' <repeats 15 times>, flow_label =3D 0,=20
>>>>>>>>>>> pkey_index =3D 0, reserved =3D "\000\000\000\000\000"}, dat=
a =3D 0x7fffe8012530 "\002"}
>>>>>>>>>>
>>>>>>>>>> Is this the PathRecord query on the OpenMPI side or the resp=
onse on the
>>>>>>>>>> OpenSM side ? SL is 6 rather than 1 here.
>>>>>>>>> This is the response on the OpenSM side (inside the umad_send=
 function, right before it is written to the device with write(fd, =85)=
=2E
>>>>>>>>> SL=3D6 indicates, that the MPI process was sending the reques=
t on SL 6.
>>>>>>>>
>>>>>>>> What is SMSL for the requester ? Was it SL 6 ?
>>>>>>> Yes, it was SL 6.
>>>>>>> Here is a content of a similar packet which was received by the=
 SA. I have used ibdump on the port where the OpenSM was running:
>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>> No.     Time        Source                Destination          =
 Protocol Length Info
>>>>>>>  785 14.352168   LID: 384              LID: 4140             In=
finiBand 290    UD Send Only SubnAdmGet(PathRecord)
>>>>>>>
>>>>>>> Frame 785: 290 bytes on wire (2320 bits), 290 bytes captured (2=
320 bits)
>>>>>>>  Arrival Time: Dec 13, 2012 18:09:44.437633332 JST
>>>>>>>  Epoch Time: 1355389784.437633332 seconds
>>>>>>>  [Time delta from previous captured frame: 4.332020528 seconds]
>>>>>>>  [Time delta from previous displayed frame: 4.332020528 seconds=
]
>>>>>>>  [Time since reference or first frame: 14.352168681 seconds]
>>>>>>>  Frame Number: 785
>>>>>>>  Frame Length: 290 bytes (2320 bits)
>>>>>>>  Capture Length: 290 bytes (2320 bits)
>>>>>>>  [Frame is marked: False]
>>>>>>>  [Frame is ignored: False]
>>>>>>>  [Protocols in frame: erf:infiniband]
>>>>>>> Extensible Record Format
>>>>>>>  [ERF Header]
>>>>>>>      Timestamp: 0x50c99b587008bcf2
>>>>>>>      [Header type]
>>>>>>>          .001 0101 =3D type: INFINIBAND (21)
>>>>>>>          0... .... =3D Extension header present: 0
>>>>>>>      0000 0100 =3D flags: 4
>>>>>>>          .... ..00 =3D capture interface: 0
>>>>>>>          .... .1.. =3D varying record length: 1
>>>>>>>          .... 0... =3D truncated: 0
>>>>>>>          ...0 .... =3D rx error: 0
>>>>>>>          ..0. .... =3D ds error: 0
>>>>>>>          00.. .... =3D reserved: 0
>>>>>>>      record length: 306
>>>>>>>      loss counter: 0
>>>>>>>      wire length: 290
>>>>>>> InfiniBand
>>>>>>>  Local Route Header
>>>>>>>      0110 .... =3D Virtual Lane: 0x06
>>>>>>>      .... 0000 =3D Link Version: 0
>>>>>>>      0110 .... =3D Service Level: 6
>>>>>>>      .... 00.. =3D Reserved (2 bits): 0
>>>>>>>      .... ..10 =3D Link Next Header: 0x02
>>>>>>>      Destination Local ID: 19
>>>>>>>      0000 0... .... .... =3D Reserved (5 bits): 0
>>>>>>>      .... .000 0100 1000 =3D Packet Length: 72
>>>>>>>      Source Local ID: 16
>>>>>>>  Base Transport Header
>>>>>>>      Opcode: 100
>>>>>>>      1... .... =3D Solicited Event: True
>>>>>>>      .1.. .... =3D MigReq: True
>>>>>>>      ..00 .... =3D Pad Count: 0
>>>>>>>      .... 0000 =3D Header Version: 0
>>>>>>>      Partition Key: 65535
>>>>>>>      Reserved (8 bits): 0
>>>>>>>      Destination Queue Pair: 0x000001
>>>>>>>      0... .... =3D Acknowledge Request: False
>>>>>>>      .000 0000 =3D Reserved (7 bits): 0
>>>>>>>      Packet Sequence Number: 0
>>>>>>>  DETH - Datagram Extended Transport Header
>>>>>>>      Queue Key: 2147549184
>>>>>>>      Reserved (8 bits): 0
>>>>>>>      Source Queue Pair: 0x00380050
>>>>>>>  MAD Header - Common Management Datagram
>>>>>>>      Base Version: 0x01
>>>>>>>      Management Class: 0x03
>>>>>>>      Class Version: 0x02
>>>>>>>      Method: Get() (0x01)
>>>>>>>      Status: 0x0000
>>>>>>>      Class Specific: 0x0000
>>>>>>>      Transaction ID: 0x0010000f38005000
>>>>>>>      Attribute ID: 0x0035
>>>>>>>      Reserved: 0x0000
>>>>>>>      Attribute Modifier: 0x00000000
>>>>>>>      MAD Data Payload: 0000000000000000000000000000000000000000=
00000000...
>>>>>>>   Illegal RMPP Type (0)!=20
>>>>>>>      RMPP Type: 0x00
>>>>>>>      RMPP Type: 0x00
>>>>>>>      0000 .... =3D R Resp Time: 0x00
>>>>>>>      .... 0000 =3D RMPP Flags: Unknown (0x00)
>>>>>>>      RMPP Status:  (Normal) (0x00)
>>>>>>>      RMPP Data 1: 0x00000000
>>>>>>>      RMPP Data 2: 0x00000000
>>>>>>>  SMASubnAdmGet(PathRecord)
>>>>>>>      SM_Key (Verification Key): 0x0000000000000000
>>>>>>>      Attribute Offset: 0x0000
>>>>>>>      Reserved: 0x0000
>>>>>>>      Component Mask: 0x0000003000000000
>>>>>>>      Attribute (PathRecord)
>>>>>>>          PathRecord
>>>>>>>              DGID: :: (::)
>>>>>>>              SGID: ::0.15.0.16 (::0.15.0.16)
>>>>>>>              DLID: 0x0000
>>>>>>>              SLID: 0x0000
>>>>>>>              0... .... =3D RawTraffic: 0x00
>>>>>>>              .... 0000 0000 0000 0000 0000 =3D FlowLabel: 0x000=
000
>>>>>>>              HopLimit: 0x00
>>>>>>>              TClass: 0x00
>>>>>>>              0... .... =3D Reversible: 0x00
>>>>>>>              .000 0000 =3D NumbPath: 0x00
>>>>>>>              P_Key: 0x0000
>>>>>>>              .... .... .... 0000 =3D SL: 0x0000
>>>>>>>              00.. .... =3D MTUSelector: 0x00
>>>>>>>              ..00 0000 =3D MTU: 0x00
>>>>>>>              00.. .... =3D RateSelector: 0x00
>>>>>>>              ..00 0000 =3D Rate: 0x00
>>>>>>>              00.. .... =3D PacketLifeTimeSelector: 0x00
>>>>>>>              ..00 0000 =3D PacketLifeTime: 0x00
>>>>>>>              Preference: 0x00
>>>>>>>  Variant CRC: 0xad4e
>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>
>>>>>> And the SubnAdmGetResp(PathRecord) is not seen ? If not, it does=
n't get
>>>>>> out that machine and the issue is internal to that machine. It c=
ould be
>>>>>> because of the underlying issue which hangs OpenSM when some IB =
program
>>>>>> tried to unregister from the MAD layer but there were outstandin=
g work
>>>>>> completions. That's based on your original email earlier this AM=
=2E
>>>>> No, the SubnAdmGetResp does not show up, if I use ibdump on the O=
MPI side and the SA uses a SL>0.
>>>>
>>>> Can ibdump be used to capture output on the SM port ?
>>>
>>> Yes, that works quite well, despite the warning in the ibdump manua=
l.
>>> But I have started ibdump before opensm, maybe that makes a differe=
nce, not sure.
>>>
>>> Regards,
>>> Jens
>>>
>>> PS: I have seen a small bug. Not sure if its a bug in wireshark or =
ibdump, but the response received by the OMPI node isn't shown correctl=
y. The PathRecord contains an offset which is either missing in the dum=
p or is not treated correctly be wireshark. But it causes wireshark to =
show the PathRecord data with wrong values.
>>> Maybe you could redirect this to the developer of ibdump, so that h=
e can check/fix it.
>>
>> Are you referring to the fields after the SA AttributeOffset or
>> something else ?
> Yes, after the SMASubnAdmGet Attribute Offset. Here an example:
> I get on the OMPI side:
>     SMASubnAdmGetResp(PathRecord)
>         SM_Key (Verification Key): 0x0000000000000000
>         Attribute Offset: 0x0008
>         Reserved: 0x0000
>         Component Mask: 0x0000803000000000
>         Attribute (PathRecord)
>             PathRecord
>                 DGID: ::8:f104:399:ebb5:fe80:0 (::8:f104:399:ebb5:fe8=
0:0)
>                 SGID: ::8:f104:399:ecd5:4:8 (::8:f104:399:ecd5:4:8)
>                 DLID: 0x0000
>                 SLID: 0x0000
>                 0... .... =3D RawTraffic: 0x00
>                 .... 0000 1000 0000 1111 1111 =3D FlowLabel: 0x0080ff
>                 HopLimit: 0xff
>                 TClass: 0x00
>                 0... .... =3D Reversible: 0x00
>                 .000 0011 =3D NumbPath: 0x03
>                 P_Key: 0x8486
>                 .... .... .... 0000 =3D SL: 0x0000
>                 00.. .... =3D MTUSelector: 0x00
>                 ..00 0000 =3D MTU: 0x00
>                 00.. .... =3D RateSelector: 0x00
>                 ..00 0000 =3D Rate: 0x00
>                 00.. .... =3D PacketLifeTimeSelector: 0x00
>                 ..00 0000 =3D PacketLifeTime: 0x00
>                 Preference: 0x00
>=20
> But it should show (see the difference in SLID, DLID, SL which are no=
w correct):
>     SMASubnAdmGetResp(PathRecord)
>         SM_Key (Verification Key): 0x0000000000000000
>         Attribute Offset: 0x0008
>         Reserved: 0x0000
>         Component Mask: 0x0000803000000000
>         Attribute (PathRecord)
>             PathRecord
>                 DGID: ::8:f104:399:ebb5 (::8:f104:399:ebb5)
>                 SGID: fe80::8:f104:399:ecd5 (fe80::8:f104:399:ecd5)
>                 DLID: 0x0004
>                 SLID: 0x0008
>                 0... .... =3D RawTraffic: 0x00
>                 .... 0000 0000 0000 0000 0000 =3D FlowLabel: 0x000000
>                 HopLimit: 0x00
>                 TClass: 0x00
>                 1... .... =3D Reversible: 0x01
>                 .000 0000 =3D NumbPath: 0x00
>                 P_Key: 0xffff
>                 .... .... .... 0011 =3D SL: 0x0003
>                 10.. .... =3D MTUSelector: 0x02
>                 ..00 0100 =3D MTU: 0x04
>                 10.. .... =3D RateSelector: 0x02
>                 ..00 0110 =3D Rate: 0x06
>                 10.. .... =3D PacketLifeTimeSelector: 0x02
>                 ..01 0010 =3D PacketLifeTime: 0x12
>                 Preference: 0x00


I think everything after AttributeOffset is off by 2 bytes. DGID doesn'=
t
look right to me (no subnet prefix fe80:: in front of GUID).

-- Hal

>=20
> Regards,
> Jens
>=20
>>
>> -- Hal
>>
>>>>
>>>> -- Hal
>>>>
>>>>>>
>>>>>>>>
>>>>>>>> One would need to walk the SLToVLMappingTables from requester =
(OMPI
>>>>>>>> port) to SA and back to see whether SL6 would even have a chan=
ce of
>>>>>>>> working (not dropping) aside from whether it's really the corr=
ect SL to use.
>>>>>>> All SL2VL tables look the same. I checked the output of OpenSM.
>>>>>>> 	SL: |  0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | =
11 | 12 | 13 | 14 | 15 |
>>>>>>> 	VL: | 0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |0x0 |0x1 |0x2 |0=
x3 |0x4 |0x5 |0x6 |0x7 |
>>>>>>> But this is also as expected, because I have set the QoS in the=
 opensm config as follows:
>>>>>>> 	qos_sl2vl 0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
>>>>>>> This was set for "default", "CA" and "Switch external ports". I=
 have not touched the config for "Switch Port 0" and "Router ports", th=
ey remained: qos_[sw0 | rtr]_sl2vl (null)
>>>>>>
>>>>>> That works as long as all links have (at least) 8 data VLs (VLCa=
p 4).
>>>>> Yes, all VL_CAP show 4 in the OpenSM log file.
>>>>>
>>>>> Regards
>>>>> Jens
>>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> -- Hal
>>>>>>
>>>>>>> Regards
>>>>>>> Jens
>>>>>>>
>>>>>>>>
>>>>>>>> -- Hal
>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> The output of OpenMPI or OpenSM's log file don't show any u=
seful information for this problem, even with higher debug levels.
>>>>>>>>>>
>>>>>>>>>> So nothing interesting logged relative to the PathRecord que=
ries ?
>>>>>>>>> In the OpenSM log, only that it was received, how the request=
 looks like, and that it was send back.
>>>>>>>>> And a few "outstanding MADs" a few lines later in the log.
>>>>>>>>>>
>>>>>>>>>>> So, right now I'm stuck, and have no idea if there is an er=
ror in the kernel driver, the HCA firmware or something completely diff=
erent. Or if umad_send basically does not support SL>0.
>>>>>>>>>>> A workaround for the moment is to set the SL in the umad_se=
t_addr_net(...) call to 0.
>>>>>>>>>>
>>>>>>>>>> So SL 0 works between all nodes and SA for querying/response=
s. Wonder if
>>>>>>>>>> that's how SMSL is set by DFSSSP.
>>>>>>>>> No, the SMSL set by DFSSSP is different from 0, I have checke=
d this. In our case (OpenSM running on a compute node), it sets the sam=
e SL, which is used
>>>>>>>> for MPI<->MPI traffic, to ensure deadlock freedom.
>>>>>>>>>
>>>>>>>>> Regards
>>>>>>>>> Jens
>>>>>>>>>
>>>>>>>>> --------------------------------
>>>>>>>>> Dipl.-Math. Jens Domke
>>>>>>>>> Researcher - Tokyo Institute of Technology
>>>>>>>>> Satoshi MATSUOKA Laboratory
>>>>>>>>> Global Scientific Information and Computing Center
>>>>>>>>> 2-12-1-E2-7 Ookayama, Meguro-ku,=20
>>>>>>>>> Tokyo, 152-8550, JAPAN
>>>>>>>>> Tel/Fax: +81-3-5734-3876
>>>>>>>>> E-Mail: domke.j.aa@m.titech.ac.jp
>>>>>>>>> --------------------------------
>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linu=
x-rdma" in
>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.=
html
>>>>>>>
>>>>>>> --------------------------------
>>>>>>> Dipl.-Math. Jens Domke
>>>>>>> Researcher - Tokyo Institute of Technology
>>>>>>> Satoshi MATSUOKA Laboratory
>>>>>>> Global Scientific Information and Computing Center
>>>>>>> 2-12-1-E2-7 Ookayama, Meguro-ku,=20
>>>>>>> Tokyo, 152-8550, JAPAN
>>>>>>> Tel/Fax: +81-3-5734-3876
>>>>>>> E-Mail: domke.j.aa@m.titech.ac.jp
>>>>>>> --------------------------------
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
rdma" in
>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.ht=
ml
>>>>>
>>>>> --------------------------------
>>>>> Dipl.-Math. Jens Domke
>>>>> Researcher - Tokyo Institute of Technology
>>>>> Satoshi MATSUOKA Laboratory
>>>>> Global Scientific Information and Computing Center
>>>>> 2-12-1-E2-7 Ookayama, Meguro-ku,=20
>>>>> Tokyo, 152-8550, JAPAN
>>>>> Tel/Fax: +81-3-5734-3876
>>>>> E-Mail: domke.j.aa@m.titech.ac.jp
>>>>> --------------------------------
>>>>>
>>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> --------------------------------
>>> Dipl.-Math. Jens Domke
>>> Researcher - Tokyo Institute of Technology
>>> Satoshi MATSUOKA Laboratory
>>> Global Scientific Information and Computing Center
>>> 2-12-1-E2-7 Ookayama, Meguro-ku,=20
>>> Tokyo, 152-8550, JAPAN
>>> Tel/Fax: +81-3-5734-3876
>>> E-Mail: domke.j.aa@m.titech.ac.jp
>>> --------------------------------
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
