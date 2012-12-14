From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: Re: umad_send with service level higher than 0 does not work
Date: Sat, 15 Dec 2012 00:17:17 +0900
Message-ID: <53BC3D57-0D23-488F-A3A5-DFB2EEAB3016@m.titech.ac.jp>
References: <0D9917EC-D7A3-4786-BE38-60F6990BA3E1@m.titech.ac.jp> <50CB2DF3.7020409@dev.mellanox.co.il>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CB2DF3.7020409-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Hal,

thank you for the fast response. I will try to clarify some points.

>>  d) OpenMPI runs are executed with "--mca btl_openib_ib_path_record_=
service_level 1"
>=20
> I'm not familiar with what DFSSSP does to figure out SLs exactly but
> there should be no need to set this. The proper SL for querying the S=
A
> for PathRecords, etc. is always in PortInfo.SMSL. In the case of DFSS=
SP
> (and other QoS based routing algorithms), it calculates that and the =
SM
> pushes this into each port. That should be used. It's possible that S=
L1
> is not a valid SL for port <-> SA querying using DFSSSP.
The OpenMPI parameter btl_openib_ib_path_record_service_level does not =
specify the SL for querying the PathRecords.
It just enables the functionality. And the ompi processes use the PortI=
nfo.SMSL to send the request.
=46or the request "port -> SA" every 0<=3DSL<=3D7 was used in the test,=
 and the SA received the requests. =20
>=20
>>  e) kernel 2.6.32-220.13.1.el6.x86_64
>>=20
>> As far as I understand the whole system:
>>  1. the OMPI processes are sending MAD requests (SubnAdmGet:PathReco=
rd) to the OpenSM
>>  2. the SA receives the request on QP1
>=20
> There is the SL in the query itself. This should be the SMSL that the=
 SM
> set for that port.
Hmm, there you might have a point. I think I saw that the query itself =
had SL=3D0 specified.
In fact OpenMPI sets everthing to 0 except for slid and dlid.
>=20
>>  3. SA asks the routing algorithm (like LASH, DFSSSP or Torus_2QoS) =
about a special service level for the slid/dlid path
>=20
> This is a (potentially) different SL (for MPI<->MPI port communicatio=
n)
> than the one the query used and is the one returned inside the
> PathRecord attribute/data.
Yes, it can be different, but DFSSSP sets the same SL, because the SM i=
s running on a port which is also used for MPI comm.
>=20
>>  4. SA sends the PathRecord back to the OMPI process via umad_send i=
n libvendor/osm_vendor_ibumad.c
>=20
> By the response reversibility rule, I think this is returned on the S=
L
> of the original query but haven't verified this in the code base yet.
Ok, I was not aware of that rule. But if this is true, then the SA shou=
ld also be able to send via SL>0.
>=20
>> The osm_vendor_send() function builds the MAD packet with the follow=
ing attributes:
>>        /* GS classes */
>>        umad_set_addr_net(p_vw->umad, p_mad_addr->dest_lid,
>>                          p_mad_addr->addr_type.gsi.remote_qp,
>>                          p_mad_addr->addr_type.gsi.service_level,
>>                          IB_QP1_WELL_KNOWN_Q_KEY);
>> So, the SL is the same like the one which was used by the OMPI proce=
ss. The Q_Key matches the Q_key on the OMPI process, and remote_qp and =
dest_lid is correct, too.
>> Afterwards umad_send(=85) is used to send the reply with the PathRec=
ord, and this send does not work (except for SL=3D0).
>=20
> By not working, what do you mean ? Do you mean it's not received at t=
he
> requester with no message in the OpenSM log or not received at the
> OpenSM or something else ? It could be due to the wrong SL being used=
 in
> the original request (forcing it to SL 1). That could cause it not to=
 be
> received at the SM or the response not to make it back to the request=
er
> from the SA if the SL used is not "reversible".
By "not working" I mean, that the MPI process does not receive any resp=
onse from the SA.
I get messages from the MPI process like the following:
[rc011][[14851,1],1][connect/btl_openib_connect_sl.c:301:get_pathrecord=
_info] No response from SA after 20 retries
The log of OpenSM shows that the SA received the PathRequest query, dum=
ps the query into the log, and sends the reply back.
And I think I was some messages in the log about "=851 outstanding MAD=85=
".
>=20
>> If I look into the MAD before it is send, then it looks like this:
>> Breakpoint 2, umad_send (fd=3D9, agentid=3D2, umad=3D0x7fffe8012530,=
 length=3D120, timeout_ms=3D0, retries=3D3)
>>    at src/umad.c:791
>> 791             if (umaddebug > 1)
>> (gdb) p *mad
>> $1 =3D {agent_id =3D 2, status =3D 0, timeout_ms =3D 0, retries =3D =
3, length =3D 0, addr =3D {qpn =3D 1325427712, qkey =3D 384,=20
>>    lid =3D 4096, sl =3D 6 '\006', path_bits =3D 0 '\000', grh_presen=
t =3D 0 '\000', gid_index =3D 0 '\000',=20
>>    hop_limit =3D 0 '\000', traffic_class =3D 0 '\000', gid =3D '\000=
' <repeats 15 times>, flow_label =3D 0,=20
>>    pkey_index =3D 0, reserved =3D "\000\000\000\000\000"}, data =3D =
0x7fffe8012530 "\002"}
>=20
> Is this the PathRecord query on the OpenMPI side or the response on t=
he
> OpenSM side ? SL is 6 rather than 1 here.
This is the response on the OpenSM side (inside the umad_send function,=
 right before it is written to the device with write(fd, =85).
SL=3D6 indicates, that the MPI process was sending the request on SL 6.
>=20
>> The output of OpenMPI or OpenSM's log file don't show any useful inf=
ormation for this problem, even with higher debug levels.
>=20
> So nothing interesting logged relative to the PathRecord queries ?
In the OpenSM log, only that it was received, how the request looks lik=
e, and that it was send back.
And a few "outstanding MADs" a few lines later in the log.
>=20
>> So, right now I'm stuck, and have no idea if there is an error in th=
e kernel driver, the HCA firmware or something completely different. Or=
 if umad_send basically does not support SL>0.
>> A workaround for the moment is to set the SL in the umad_set_addr_ne=
t(...) call to 0.
>=20
> So SL 0 works between all nodes and SA for querying/responses. Wonder=
 if
> that's how SMSL is set by DFSSSP.
No, the SMSL set by DFSSSP is different from 0, I have checked this. In=
 our case (OpenSM running on a compute node), it sets the same SL, whic=
h is used for MPI<->MPI traffic, to ensure deadlock freedom.

Regards
Jens

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
