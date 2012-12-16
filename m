From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: Re: umad_send with service level higher than 0 does not work
Date: Sun, 16 Dec 2012 21:03:44 +0900
Message-ID: <195255BB-E0F4-4F0E-A69A-4FC9A041ECC0@m.titech.ac.jp>
References: <0D9917EC-D7A3-4786-BE38-60F6990BA3E1@m.titech.ac.jp> <50CB2DF3.7020409@dev.mellanox.co.il> <53BC3D57-0D23-488F-A3A5-DFB2EEAB3016@m.titech.ac.jp> <50CB56E9.70900@dev.mellanox.co.il> <1B48E229-0016-4829-BC73-372CB5B6F21F@m.titech.ac.jp> <50CB76F2.70003@dev.mellanox.co.il> <BAADC764-74C8-48EB-B45B-DFB83A313258@m.titech.ac.jp> <50CB8F90.1030701@dev.mellanox.co.il>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CB8F90.1030701-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Hal,

On Dec 15, 2012, at 5:44 AM, Hal Rosenstock wrote:

> Hi,
>=20
> On 12/14/2012 3:32 PM, Jens Domke wrote:
>> Hello Hal,
>>=20
>> On Dec 15, 2012, at 3:58 AM, Hal Rosenstock wrote:
>>=20
>>> Hi,
>>>=20
>>> On 12/14/2012 1:24 PM, Jens Domke wrote:
>>>> Hello Hal,
>>>>=20
>>>> On Dec 15, 2012, at 1:42 AM, Hal Rosenstock wrote:
>>>>=20
>>>>> Hi again,
>>>>>=20
>>>>> On 12/14/2012 10:17 AM, Jens Domke wrote:
>>>>>> Hello Hal,
>>>>>>=20
>>>>>> thank you for the fast response. I will try to clarify some poin=
ts.
>>>>>>=20
>>>>>>>> d) OpenMPI runs are executed with "--mca btl_openib_ib_path_re=
cord_service_level 1"
>>>>>>>=20
>>>>>>> I'm not familiar with what DFSSSP does to figure out SLs exactl=
y but
>>>>>>> there should be no need to set this. The proper SL for querying=
 the SA
>>>>>>> for PathRecords, etc. is always in PortInfo.SMSL. In the case o=
f DFSSSP
>>>>>>> (and other QoS based routing algorithms), it calculates that an=
d the SM
>>>>>>> pushes this into each port. That should be used. It's possible =
that SL1
>>>>>>> is not a valid SL for port <-> SA querying using DFSSSP.
>>>>>> The OpenMPI parameter btl_openib_ib_path_record_service_level do=
es not specify the SL for querying the PathRecords.
>>>>>> It just enables the functionality. And the ompi processes use th=
e PortInfo.SMSL to send the request.
>>>>>> For the request "port -> SA" every 0<=3DSL<=3D7 was used in the =
test, and the SA received the requests. =20
>>>>>>>=20
>>>>>>>> e) kernel 2.6.32-220.13.1.el6.x86_64
>>>>>>>>=20
>>>>>>>> As far as I understand the whole system:
>>>>>>>> 1. the OMPI processes are sending MAD requests (SubnAdmGet:Pat=
hRecord) to the OpenSM
>>>>>>>> 2. the SA receives the request on QP1
>>>>>>>=20
>>>>>>> There is the SL in the query itself. This should be the SMSL th=
at the SM
>>>>>>> set for that port.
>>>>>> Hmm, there you might have a point. I think I saw that the query =
itself had SL=3D0 specified.
>>>>>> In fact OpenMPI sets everthing to 0 except for slid and dlid.
>>>>>>>=20
>>>>>>>> 3. SA asks the routing algorithm (like LASH, DFSSSP or Torus_2=
QoS) about a special service level for the slid/dlid path
>>>>>>>=20
>>>>>>> This is a (potentially) different SL (for MPI<->MPI port commun=
ication)
>>>>>>> than the one the query used and is the one returned inside the
>>>>>>> PathRecord attribute/data.
>>>>>> Yes, it can be different, but DFSSSP sets the same SL, because t=
he SM is running on a port which is also used for MPI comm.
>>>>>=20
>>>>> With DFSSSP are all SLs same from source port to get to any desti=
nation ?
>>>> No, not necessarily. In general DFSSSP does not enforce SL(LID1->L=
ID2) =3D=3D SL(LID2->LID1) or SL(LID1->LID2) =3D=3D SL(LID1->LID3).
>>>=20
>>> If SL(LID1->LID2) !=3D SL(LID2->LID1), that's not a reversible path=
=2E
>> True. But i don't think that the SA asks the DFSSSP routing about th=
e SL for the reversible path.
>> So, the SA could use any SL which is a valid SL, even if the DFSSSP =
would recommend another SL.
>>=20
>> I just read the IB Specs and it says, that "SL specified in the rece=
ived packet is used as the SL in the response packet" for MAD packets.
>> So, its most likely, that there is a mismatch in the way how OMPI do=
es the setup of the PathRequest and the way how the SA does build the r=
espond packet.
>> OMPI always specifies SL=3D0 (lets say SL_a) inside of the PathReque=
st packet,=20
>=20
> So CompMask in the query has the SL bit on and SL is set to 0 inside =
the
> SubAdmGet of PatchRecord ?

No, the CompMask didn't had the SL bit and the SL was set to 0.
I tried to follow the path of the SL bit (IB_PR_COMPMASK_SL) and the on=
ly reference I found was in osm_sa_path_record.c
The SA just treats the SL in the PathRequest as a "I would like to use =
this SL" in case the SL bit is set.
But the routing engine can overwrite the requested SL before the reply =
is send.

Nevertheless, I have changed the code of OMPI so that it sets the SL bi=
t in the CompMask and sets the SL to SMSL for the PathRequest, so that =
SL_a =3D=3D SL_b.
Sadly, the reply send by the SA does not leave the node (for SL_b>0). O=
nly if I change the SL to 0 in the MAD right before umad_send is called=
 by the SA, the paket is able to leave the node and reaches the OMPI pr=
ocess.

>=20
>> and sends the packet on SL_b (PortInfo.SMSL).
>=20
> Good.
>=20
>> The SA uses p_mad_addr->addr_type.gsi.service_level, which is SL_b, =
for the response.
>> If SL_b is not 0, then the packet can't reach the OMPI process. Righ=
t?
>=20
> Depends. It may be that both SLs work but maybe not.
>=20
>> If I analyse this correctly, then there are two bugs. One is in OMPI=
, that it does not specify the SL within the PathRequest in a appropria=
te way (which would be a SL suggested by DFSSSP for the reversible path=
). And the second bug is that the SA uses the SL, on which the PathRequ=
est packet was send, and not the SL specified within the packet.
>> What do you think?
>=20
> Yes, it might be better to wildcard the SL in the query. The only
> scenario that would fail with the query you are making if there's no =
SL
> 0 path between the src/dest LIDs or GIDs in the OMPI PathRecord query=
=2E
> If that's the case, SA should return MAD status 0xc (status code 3 -
> ERR_NO_RECORDS). But the response doesn't make it back to the request=
er
> OMPI node so it's not even getting that far.

Yes, exactly. So, do you have an idea why the response hands in the SA =
node?
I have no inside of the underlying layer (kernel driver and fireware). =
Maybe there are some implementations, which prevent the SA from sending=
 MADs back on SL>0?

>=20
>> I can try to change the PathRequest of OMPI tomorrow, so that it mat=
ches addr_type.gsi.service_level.
>> Maybe, with this change the packets of the SA will reach the OMPI pr=
ocess on a SL>0.
>>>=20
>>>>>=20
>>>>>>>=20
>>>>>>>> 4. SA sends the PathRecord back to the OMPI process via umad_s=
end in libvendor/osm_vendor_ibumad.c
>>>>>>>=20
>>>>>>> By the response reversibility rule, I think this is returned on=
 the SL
>>>>>>> of the original query but haven't verified this in the code bas=
e yet.
>>>>>> Ok, I was not aware of that rule. But if this is true, then the =
SA should also be able to send via SL>0.
>>>>>=20
>>>>> I doubled checked and indeed the SA response does use the SL that=
 the
>>>>> incoming request was received on.
>>>>>=20
>>>>>>>=20
>>>>>>>> The osm_vendor_send() function builds the MAD packet with the =
following attributes:
>>>>>>>>     /* GS classes */
>>>>>>>>     umad_set_addr_net(p_vw->umad, p_mad_addr->dest_lid,
>>>>>>>>                       p_mad_addr->addr_type.gsi.remote_qp,
>>>>>>>>                       p_mad_addr->addr_type.gsi.service_level,
>>>>>>>>                       IB_QP1_WELL_KNOWN_Q_KEY);
>>>>>>>> So, the SL is the same like the one which was used by the OMPI=
 process. The Q_Key matches the Q_key on the OMPI process, and remote_q=
p and dest_lid is correct, too.
>>>>>>>> Afterwards umad_send(=85) is used to send the reply with the P=
athRecord, and this send does not work (except for SL=3D0).
>>>>>>>=20
>>>>>>> By not working, what do you mean ? Do you mean it's not receive=
d at the
>>>>>>> requester with no message in the OpenSM log or not received at =
the
>>>>>>> OpenSM or something else ? It could be due to the wrong SL bein=
g used in
>>>>>>> the original request (forcing it to SL 1). That could cause it =
not to be
>>>>>>> received at the SM or the response not to make it back to the r=
equester
>>>>>>> from the SA if the SL used is not "reversible".
>>>>>> By "not working" I mean, that the MPI process does not receive a=
ny response from the SA.
>>>>>> I get messages from the MPI process like the following:
>>>>>> [rc011][[14851,1],1][connect/btl_openib_connect_sl.c:301:get_pat=
hrecord_info] No response from SA after 20 retries
>>>>>> The log of OpenSM shows that the SA received the PathRequest que=
ry, dumps the query into the log, and sends the reply back.
>>>>>> And I think I was some messages in the log about "=851 outstandi=
ng MAD=85".
>>>>>>>=20
>>>>>>>> If I look into the MAD before it is send, then it looks like t=
his:
>>>>>>>> Breakpoint 2, umad_send (fd=3D9, agentid=3D2, umad=3D0x7fffe80=
12530, length=3D120, timeout_ms=3D0, retries=3D3)
>>>>>>>> at src/umad.c:791
>>>>>>>> 791             if (umaddebug > 1)
>>>>>>>> (gdb) p *mad
>>>>>>>> $1 =3D {agent_id =3D 2, status =3D 0, timeout_ms =3D 0, retrie=
s =3D 3, length =3D 0, addr =3D {qpn =3D 1325427712, qkey =3D 384,=20
>>>>>>>> lid =3D 4096, sl =3D 6 '\006', path_bits =3D 0 '\000', grh_pre=
sent =3D 0 '\000', gid_index =3D 0 '\000',=20
>>>>>>>> hop_limit =3D 0 '\000', traffic_class =3D 0 '\000', gid =3D '\=
000' <repeats 15 times>, flow_label =3D 0,=20
>>>>>>>> pkey_index =3D 0, reserved =3D "\000\000\000\000\000"}, data =3D=
 0x7fffe8012530 "\002"}
>>>>>>>=20
>>>>>>> Is this the PathRecord query on the OpenMPI side or the respons=
e on the
>>>>>>> OpenSM side ? SL is 6 rather than 1 here.
>>>>>> This is the response on the OpenSM side (inside the umad_send fu=
nction, right before it is written to the device with write(fd, =85).
>>>>>> SL=3D6 indicates, that the MPI process was sending the request o=
n SL 6.
>>>>>=20
>>>>> What is SMSL for the requester ? Was it SL 6 ?
>>>> Yes, it was SL 6.
>>>> Here is a content of a similar packet which was received by the SA=
=2E I have used ibdump on the port where the OpenSM was running:
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> No.     Time        Source                Destination           Pr=
otocol Length Info
>>>>   785 14.352168   LID: 384              LID: 4140             Infi=
niBand 290    UD Send Only SubnAdmGet(PathRecord)
>>>>=20
>>>> Frame 785: 290 bytes on wire (2320 bits), 290 bytes captured (2320=
 bits)
>>>>   Arrival Time: Dec 13, 2012 18:09:44.437633332 JST
>>>>   Epoch Time: 1355389784.437633332 seconds
>>>>   [Time delta from previous captured frame: 4.332020528 seconds]
>>>>   [Time delta from previous displayed frame: 4.332020528 seconds]
>>>>   [Time since reference or first frame: 14.352168681 seconds]
>>>>   Frame Number: 785
>>>>   Frame Length: 290 bytes (2320 bits)
>>>>   Capture Length: 290 bytes (2320 bits)
>>>>   [Frame is marked: False]
>>>>   [Frame is ignored: False]
>>>>   [Protocols in frame: erf:infiniband]
>>>> Extensible Record Format
>>>>   [ERF Header]
>>>>       Timestamp: 0x50c99b587008bcf2
>>>>       [Header type]
>>>>           .001 0101 =3D type: INFINIBAND (21)
>>>>           0... .... =3D Extension header present: 0
>>>>       0000 0100 =3D flags: 4
>>>>           .... ..00 =3D capture interface: 0
>>>>           .... .1.. =3D varying record length: 1
>>>>           .... 0... =3D truncated: 0
>>>>           ...0 .... =3D rx error: 0
>>>>           ..0. .... =3D ds error: 0
>>>>           00.. .... =3D reserved: 0
>>>>       record length: 306
>>>>       loss counter: 0
>>>>       wire length: 290
>>>> InfiniBand
>>>>   Local Route Header
>>>>       0110 .... =3D Virtual Lane: 0x06
>>>>       .... 0000 =3D Link Version: 0
>>>>       0110 .... =3D Service Level: 6
>>>>       .... 00.. =3D Reserved (2 bits): 0
>>>>       .... ..10 =3D Link Next Header: 0x02
>>>>       Destination Local ID: 19
>>>>       0000 0... .... .... =3D Reserved (5 bits): 0
>>>>       .... .000 0100 1000 =3D Packet Length: 72
>>>>       Source Local ID: 16
>>>>   Base Transport Header
>>>>       Opcode: 100
>>>>       1... .... =3D Solicited Event: True
>>>>       .1.. .... =3D MigReq: True
>>>>       ..00 .... =3D Pad Count: 0
>>>>       .... 0000 =3D Header Version: 0
>>>>       Partition Key: 65535
>>>>       Reserved (8 bits): 0
>>>>       Destination Queue Pair: 0x000001
>>>>       0... .... =3D Acknowledge Request: False
>>>>       .000 0000 =3D Reserved (7 bits): 0
>>>>       Packet Sequence Number: 0
>>>>   DETH - Datagram Extended Transport Header
>>>>       Queue Key: 2147549184
>>>>       Reserved (8 bits): 0
>>>>       Source Queue Pair: 0x00380050
>>>>   MAD Header - Common Management Datagram
>>>>       Base Version: 0x01
>>>>       Management Class: 0x03
>>>>       Class Version: 0x02
>>>>       Method: Get() (0x01)
>>>>       Status: 0x0000
>>>>       Class Specific: 0x0000
>>>>       Transaction ID: 0x0010000f38005000
>>>>       Attribute ID: 0x0035
>>>>       Reserved: 0x0000
>>>>       Attribute Modifier: 0x00000000
>>>>       MAD Data Payload: 000000000000000000000000000000000000000000=
000000...
>>>>    Illegal RMPP Type (0)!=20
>>>>       RMPP Type: 0x00
>>>>       RMPP Type: 0x00
>>>>       0000 .... =3D R Resp Time: 0x00
>>>>       .... 0000 =3D RMPP Flags: Unknown (0x00)
>>>>       RMPP Status:  (Normal) (0x00)
>>>>       RMPP Data 1: 0x00000000
>>>>       RMPP Data 2: 0x00000000
>>>>   SMASubnAdmGet(PathRecord)
>>>>       SM_Key (Verification Key): 0x0000000000000000
>>>>       Attribute Offset: 0x0000
>>>>       Reserved: 0x0000
>>>>       Component Mask: 0x0000003000000000
>>>>       Attribute (PathRecord)
>>>>           PathRecord
>>>>               DGID: :: (::)
>>>>               SGID: ::0.15.0.16 (::0.15.0.16)
>>>>               DLID: 0x0000
>>>>               SLID: 0x0000
>>>>               0... .... =3D RawTraffic: 0x00
>>>>               .... 0000 0000 0000 0000 0000 =3D FlowLabel: 0x00000=
0
>>>>               HopLimit: 0x00
>>>>               TClass: 0x00
>>>>               0... .... =3D Reversible: 0x00
>>>>               .000 0000 =3D NumbPath: 0x00
>>>>               P_Key: 0x0000
>>>>               .... .... .... 0000 =3D SL: 0x0000
>>>>               00.. .... =3D MTUSelector: 0x00
>>>>               ..00 0000 =3D MTU: 0x00
>>>>               00.. .... =3D RateSelector: 0x00
>>>>               ..00 0000 =3D Rate: 0x00
>>>>               00.. .... =3D PacketLifeTimeSelector: 0x00
>>>>               ..00 0000 =3D PacketLifeTime: 0x00
>>>>               Preference: 0x00
>>>>   Variant CRC: 0xad4e
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>=20
>>> And the SubnAdmGetResp(PathRecord) is not seen ? If not, it doesn't=
 get
>>> out that machine and the issue is internal to that machine. It coul=
d be
>>> because of the underlying issue which hangs OpenSM when some IB pro=
gram
>>> tried to unregister from the MAD layer but there were outstanding w=
ork
>>> completions. That's based on your original email earlier this AM.
>> No, the SubnAdmGetResp does not show up, if I use ibdump on the OMPI=
 side and the SA uses a SL>0.
>=20
> Can ibdump be used to capture output on the SM port ?

Yes, that works quite well, despite the warning in the ibdump manual.
But I have started ibdump before opensm, maybe that makes a difference,=
 not sure.

Regards,
Jens

PS: I have seen a small bug. Not sure if its a bug in wireshark or ibdu=
mp, but the response received by the OMPI node isn't shown correctly. T=
he PathRecord contains an offset which is either missing in the dump or=
 is not treated correctly be wireshark. But it causes wireshark to show=
 the PathRecord data with wrong values.
Maybe you could redirect this to the developer of ibdump, so that he ca=
n check/fix it.

>=20
> -- Hal
>=20
>>>=20
>>>>>=20
>>>>> One would need to walk the SLToVLMappingTables from requester (OM=
PI
>>>>> port) to SA and back to see whether SL6 would even have a chance =
of
>>>>> working (not dropping) aside from whether it's really the correct=
 SL to use.
>>>> All SL2VL tables look the same. I checked the output of OpenSM.
>>>> 	SL: |  0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 =
| 12 | 13 | 14 | 15 |
>>>> 	VL: | 0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |0x0 |0x1 |0x2 |0x3 =
|0x4 |0x5 |0x6 |0x7 |
>>>> But this is also as expected, because I have set the QoS in the op=
ensm config as follows:
>>>> 	qos_sl2vl 0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
>>>> This was set for "default", "CA" and "Switch external ports". I ha=
ve not touched the config for "Switch Port 0" and "Router ports", they =
remained: qos_[sw0 | rtr]_sl2vl (null)
>>>=20
>>> That works as long as all links have (at least) 8 data VLs (VLCap 4=
).
>> Yes, all VL_CAP show 4 in the OpenSM log file.
>>=20
>> Regards
>> Jens
>>=20
>>=20
>>=20
>>>=20
>>> -- Hal
>>>=20
>>>> Regards
>>>> Jens
>>>>=20
>>>>>=20
>>>>> -- Hal
>>>>>=20
>>>>>>>=20
>>>>>>>> The output of OpenMPI or OpenSM's log file don't show any usef=
ul information for this problem, even with higher debug levels.
>>>>>>>=20
>>>>>>> So nothing interesting logged relative to the PathRecord querie=
s ?
>>>>>> In the OpenSM log, only that it was received, how the request lo=
oks like, and that it was send back.
>>>>>> And a few "outstanding MADs" a few lines later in the log.
>>>>>>>=20
>>>>>>>> So, right now I'm stuck, and have no idea if there is an error=
 in the kernel driver, the HCA firmware or something completely differe=
nt. Or if umad_send basically does not support SL>0.
>>>>>>>> A workaround for the moment is to set the SL in the umad_set_a=
ddr_net(...) call to 0.
>>>>>>>=20
>>>>>>> So SL 0 works between all nodes and SA for querying/responses. =
Wonder if
>>>>>>> that's how SMSL is set by DFSSSP.
>>>>>> No, the SMSL set by DFSSSP is different from 0, I have checked t=
his. In our case (OpenSM running on a compute node), it sets the same S=
L, which is used
>>>>> for MPI<->MPI traffic, to ensure deadlock freedom.
>>>>>>=20
>>>>>> Regards
>>>>>> Jens
>>>>>>=20
>>>>>> --------------------------------
>>>>>> Dipl.-Math. Jens Domke
>>>>>> Researcher - Tokyo Institute of Technology
>>>>>> Satoshi MATSUOKA Laboratory
>>>>>> Global Scientific Information and Computing Center
>>>>>> 2-12-1-E2-7 Ookayama, Meguro-ku,=20
>>>>>> Tokyo, 152-8550, JAPAN
>>>>>> Tel/Fax: +81-3-5734-3876
>>>>>> E-Mail: domke.j.aa@m.titech.ac.jp
>>>>>> --------------------------------
>>>>>>=20
>>>>>>=20
>>>>>=20
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-r=
dma" in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>>>>=20
>>>> --------------------------------
>>>> Dipl.-Math. Jens Domke
>>>> Researcher - Tokyo Institute of Technology
>>>> Satoshi MATSUOKA Laboratory
>>>> Global Scientific Information and Computing Center
>>>> 2-12-1-E2-7 Ookayama, Meguro-ku,=20
>>>> Tokyo, 152-8550, JAPAN
>>>> Tel/Fax: +81-3-5734-3876
>>>> E-Mail: domke.j.aa@m.titech.ac.jp
>>>> --------------------------------
>>>>=20
>>>>=20
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>> --------------------------------
>> Dipl.-Math. Jens Domke
>> Researcher - Tokyo Institute of Technology
>> Satoshi MATSUOKA Laboratory
>> Global Scientific Information and Computing Center
>> 2-12-1-E2-7 Ookayama, Meguro-ku,=20
>> Tokyo, 152-8550, JAPAN
>> Tel/Fax: +81-3-5734-3876
>> E-Mail: domke.j.aa@m.titech.ac.jp
>> --------------------------------
>>=20
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--------------------------------
Dipl.-Math. Jens Domke
Researcher - Tokyo Institute of Technology
Satoshi MATSUOKA Laboratory
Global Scientific Information and Computing Center
2-12-1-E2-7 Ookayama, Meguro-ku,=20
Tokyo, 152-8550, JAPAN
Tel/Fax: +81-3-5734-3876
E-Mail: domke.j.aa@m.titech.ac.jp
--------------------------------

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
