From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: Re: umad_send with service level higher than 0 does not work
Date: Sat, 15 Dec 2012 03:24:01 +0900
Message-ID: <1B48E229-0016-4829-BC73-372CB5B6F21F@m.titech.ac.jp>
References: <0D9917EC-D7A3-4786-BE38-60F6990BA3E1@m.titech.ac.jp> <50CB2DF3.7020409@dev.mellanox.co.il> <53BC3D57-0D23-488F-A3A5-DFB2EEAB3016@m.titech.ac.jp> <50CB56E9.70900@dev.mellanox.co.il>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CB56E9.70900-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Hal,

On Dec 15, 2012, at 1:42 AM, Hal Rosenstock wrote:

> Hi again,
>=20
> On 12/14/2012 10:17 AM, Jens Domke wrote:
>> Hello Hal,
>>=20
>> thank you for the fast response. I will try to clarify some points.
>>=20
>>>> d) OpenMPI runs are executed with "--mca btl_openib_ib_path_record=
_service_level 1"
>>>=20
>>> I'm not familiar with what DFSSSP does to figure out SLs exactly bu=
t
>>> there should be no need to set this. The proper SL for querying the=
 SA
>>> for PathRecords, etc. is always in PortInfo.SMSL. In the case of DF=
SSSP
>>> (and other QoS based routing algorithms), it calculates that and th=
e SM
>>> pushes this into each port. That should be used. It's possible that=
 SL1
>>> is not a valid SL for port <-> SA querying using DFSSSP.
>> The OpenMPI parameter btl_openib_ib_path_record_service_level does n=
ot specify the SL for querying the PathRecords.
>> It just enables the functionality. And the ompi processes use the Po=
rtInfo.SMSL to send the request.
>> For the request "port -> SA" every 0<=3DSL<=3D7 was used in the test=
, and the SA received the requests. =20
>>>=20
>>>> e) kernel 2.6.32-220.13.1.el6.x86_64
>>>>=20
>>>> As far as I understand the whole system:
>>>> 1. the OMPI processes are sending MAD requests (SubnAdmGet:PathRec=
ord) to the OpenSM
>>>> 2. the SA receives the request on QP1
>>>=20
>>> There is the SL in the query itself. This should be the SMSL that t=
he SM
>>> set for that port.
>> Hmm, there you might have a point. I think I saw that the query itse=
lf had SL=3D0 specified.
>> In fact OpenMPI sets everthing to 0 except for slid and dlid.
>>>=20
>>>> 3. SA asks the routing algorithm (like LASH, DFSSSP or Torus_2QoS)=
 about a special service level for the slid/dlid path
>>>=20
>>> This is a (potentially) different SL (for MPI<->MPI port communicat=
ion)
>>> than the one the query used and is the one returned inside the
>>> PathRecord attribute/data.
>> Yes, it can be different, but DFSSSP sets the same SL, because the S=
M is running on a port which is also used for MPI comm.
>=20
> With DFSSSP are all SLs same from source port to get to any destinati=
on ?
No, not necessarily. In general DFSSSP does not enforce SL(LID1->LID2) =
=3D=3D SL(LID2->LID1) or SL(LID1->LID2) =3D=3D SL(LID1->LID3).
>=20
>>>=20
>>>> 4. SA sends the PathRecord back to the OMPI process via umad_send =
in libvendor/osm_vendor_ibumad.c
>>>=20
>>> By the response reversibility rule, I think this is returned on the=
 SL
>>> of the original query but haven't verified this in the code base ye=
t.
>> Ok, I was not aware of that rule. But if this is true, then the SA s=
hould also be able to send via SL>0.
>=20
> I doubled checked and indeed the SA response does use the SL that the
> incoming request was received on.
>=20
>>>=20
>>>> The osm_vendor_send() function builds the MAD packet with the foll=
owing attributes:
>>>>       /* GS classes */
>>>>       umad_set_addr_net(p_vw->umad, p_mad_addr->dest_lid,
>>>>                         p_mad_addr->addr_type.gsi.remote_qp,
>>>>                         p_mad_addr->addr_type.gsi.service_level,
>>>>                         IB_QP1_WELL_KNOWN_Q_KEY);
>>>> So, the SL is the same like the one which was used by the OMPI pro=
cess. The Q_Key matches the Q_key on the OMPI process, and remote_qp an=
d dest_lid is correct, too.
>>>> Afterwards umad_send(=85) is used to send the reply with the PathR=
ecord, and this send does not work (except for SL=3D0).
>>>=20
>>> By not working, what do you mean ? Do you mean it's not received at=
 the
>>> requester with no message in the OpenSM log or not received at the
>>> OpenSM or something else ? It could be due to the wrong SL being us=
ed in
>>> the original request (forcing it to SL 1). That could cause it not =
to be
>>> received at the SM or the response not to make it back to the reque=
ster
>>> from the SA if the SL used is not "reversible".
>> By "not working" I mean, that the MPI process does not receive any r=
esponse from the SA.
>> I get messages from the MPI process like the following:
>> [rc011][[14851,1],1][connect/btl_openib_connect_sl.c:301:get_pathrec=
ord_info] No response from SA after 20 retries
>> The log of OpenSM shows that the SA received the PathRequest query, =
dumps the query into the log, and sends the reply back.
>> And I think I was some messages in the log about "=851 outstanding M=
AD=85".
>>>=20
>>>> If I look into the MAD before it is send, then it looks like this:
>>>> Breakpoint 2, umad_send (fd=3D9, agentid=3D2, umad=3D0x7fffe801253=
0, length=3D120, timeout_ms=3D0, retries=3D3)
>>>>   at src/umad.c:791
>>>> 791             if (umaddebug > 1)
>>>> (gdb) p *mad
>>>> $1 =3D {agent_id =3D 2, status =3D 0, timeout_ms =3D 0, retries =3D=
 3, length =3D 0, addr =3D {qpn =3D 1325427712, qkey =3D 384,=20
>>>>   lid =3D 4096, sl =3D 6 '\006', path_bits =3D 0 '\000', grh_prese=
nt =3D 0 '\000', gid_index =3D 0 '\000',=20
>>>>   hop_limit =3D 0 '\000', traffic_class =3D 0 '\000', gid =3D '\00=
0' <repeats 15 times>, flow_label =3D 0,=20
>>>>   pkey_index =3D 0, reserved =3D "\000\000\000\000\000"}, data =3D=
 0x7fffe8012530 "\002"}
>>>=20
>>> Is this the PathRecord query on the OpenMPI side or the response on=
 the
>>> OpenSM side ? SL is 6 rather than 1 here.
>> This is the response on the OpenSM side (inside the umad_send functi=
on, right before it is written to the device with write(fd, =85).
>> SL=3D6 indicates, that the MPI process was sending the request on SL=
 6.
>=20
> What is SMSL for the requester ? Was it SL 6 ?
Yes, it was SL 6.
Here is a content of a similar packet which was received by the SA. I h=
ave used ibdump on the port where the OpenSM was running:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
No.     Time        Source                Destination           Protoco=
l Length Info
    785 14.352168   LID: 384              LID: 4140             InfiniB=
and 290    UD Send Only SubnAdmGet(PathRecord)

=46rame 785: 290 bytes on wire (2320 bits), 290 bytes captured (2320 bi=
ts)
    Arrival Time: Dec 13, 2012 18:09:44.437633332 JST
    Epoch Time: 1355389784.437633332 seconds
    [Time delta from previous captured frame: 4.332020528 seconds]
    [Time delta from previous displayed frame: 4.332020528 seconds]
    [Time since reference or first frame: 14.352168681 seconds]
    Frame Number: 785
    Frame Length: 290 bytes (2320 bits)
    Capture Length: 290 bytes (2320 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: erf:infiniband]
Extensible Record Format
    [ERF Header]
        Timestamp: 0x50c99b587008bcf2
        [Header type]
            .001 0101 =3D type: INFINIBAND (21)
            0... .... =3D Extension header present: 0
        0000 0100 =3D flags: 4
            .... ..00 =3D capture interface: 0
            .... .1.. =3D varying record length: 1
            .... 0... =3D truncated: 0
            ...0 .... =3D rx error: 0
            ..0. .... =3D ds error: 0
            00.. .... =3D reserved: 0
        record length: 306
        loss counter: 0
        wire length: 290
InfiniBand
    Local Route Header
        0110 .... =3D Virtual Lane: 0x06
        .... 0000 =3D Link Version: 0
        0110 .... =3D Service Level: 6
        .... 00.. =3D Reserved (2 bits): 0
        .... ..10 =3D Link Next Header: 0x02
        Destination Local ID: 19
        0000 0... .... .... =3D Reserved (5 bits): 0
        .... .000 0100 1000 =3D Packet Length: 72
        Source Local ID: 16
    Base Transport Header
        Opcode: 100
        1... .... =3D Solicited Event: True
        .1.. .... =3D MigReq: True
        ..00 .... =3D Pad Count: 0
        .... 0000 =3D Header Version: 0
        Partition Key: 65535
        Reserved (8 bits): 0
        Destination Queue Pair: 0x000001
        0... .... =3D Acknowledge Request: False
        .000 0000 =3D Reserved (7 bits): 0
        Packet Sequence Number: 0
    DETH - Datagram Extended Transport Header
        Queue Key: 2147549184
        Reserved (8 bits): 0
        Source Queue Pair: 0x00380050
    MAD Header - Common Management Datagram
        Base Version: 0x01
        Management Class: 0x03
        Class Version: 0x02
        Method: Get() (0x01)
        Status: 0x0000
        Class Specific: 0x0000
        Transaction ID: 0x0010000f38005000
        Attribute ID: 0x0035
        Reserved: 0x0000
        Attribute Modifier: 0x00000000
        MAD Data Payload: 000000000000000000000000000000000000000000000=
000...
     Illegal RMPP Type (0)!=20
        RMPP Type: 0x00
        RMPP Type: 0x00
        0000 .... =3D R Resp Time: 0x00
        .... 0000 =3D RMPP Flags: Unknown (0x00)
        RMPP Status:  (Normal) (0x00)
        RMPP Data 1: 0x00000000
        RMPP Data 2: 0x00000000
    SMASubnAdmGet(PathRecord)
        SM_Key (Verification Key): 0x0000000000000000
        Attribute Offset: 0x0000
        Reserved: 0x0000
        Component Mask: 0x0000003000000000
        Attribute (PathRecord)
            PathRecord
                DGID: :: (::)
                SGID: ::0.15.0.16 (::0.15.0.16)
                DLID: 0x0000
                SLID: 0x0000
                0... .... =3D RawTraffic: 0x00
                .... 0000 0000 0000 0000 0000 =3D FlowLabel: 0x000000
                HopLimit: 0x00
                TClass: 0x00
                0... .... =3D Reversible: 0x00
                .000 0000 =3D NumbPath: 0x00
                P_Key: 0x0000
                .... .... .... 0000 =3D SL: 0x0000
                00.. .... =3D MTUSelector: 0x00
                ..00 0000 =3D MTU: 0x00
                00.. .... =3D RateSelector: 0x00
                ..00 0000 =3D Rate: 0x00
                00.. .... =3D PacketLifeTimeSelector: 0x00
                ..00 0000 =3D PacketLifeTime: 0x00
                Preference: 0x00
    Variant CRC: 0xad4e
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> One would need to walk the SLToVLMappingTables from requester (OMPI
> port) to SA and back to see whether SL6 would even have a chance of
> working (not dropping) aside from whether it's really the correct SL =
to use.
All SL2VL tables look the same. I checked the output of OpenSM.
	SL: |  0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 =
| 13 | 14 | 15 |
	VL: | 0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x6 |0x7 |0x0 |0x1 |0x2 |0x3 |0x4 =
|0x5 |0x6 |0x7 |
But this is also as expected, because I have set the QoS in the opensm =
config as follows:
	qos_sl2vl 0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
This was set for "default", "CA" and "Switch external ports". I have no=
t touched the config for "Switch Port 0" and "Router ports", they remai=
ned: qos_[sw0 | rtr]_sl2vl (null)

Regards
Jens

>=20
> -- Hal
>=20
>>>=20
>>>> The output of OpenMPI or OpenSM's log file don't show any useful i=
nformation for this problem, even with higher debug levels.
>>>=20
>>> So nothing interesting logged relative to the PathRecord queries ?
>> In the OpenSM log, only that it was received, how the request looks =
like, and that it was send back.
>> And a few "outstanding MADs" a few lines later in the log.
>>>=20
>>>> So, right now I'm stuck, and have no idea if there is an error in =
the kernel driver, the HCA firmware or something completely different. =
Or if umad_send basically does not support SL>0.
>>>> A workaround for the moment is to set the SL in the umad_set_addr_=
net(...) call to 0.
>>>=20
>>> So SL 0 works between all nodes and SA for querying/responses. Wond=
er if
>>> that's how SMSL is set by DFSSSP.
>> No, the SMSL set by DFSSSP is different from 0, I have checked this.=
 In our case (OpenSM running on a compute node), it sets the same SL, w=
hich is used
> for MPI<->MPI traffic, to ensure deadlock freedom.
>>=20
>> Regards
>> Jens
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
