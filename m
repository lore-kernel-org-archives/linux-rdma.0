From: neutron <neutronsharc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: back to back RDMA read fail?
Date: Wed, 11 Nov 2009 12:02:01 -0500
Message-ID: <7d5928b30911110902q58d58ae3n9dc86c6ad2ed587b@mail.gmail.com>
References: <7d5928b30911092036v6d1196a8m53287dc5eebb654d@mail.gmail.com>
	 <7d5928b30911092103r5b730091jd2ca2581f540ea3d@mail.gmail.com>
	 <00ca01ca61d3$fd4dd290$f7e977b0$@com>
	 <7d5928b30911100731o24941445wfb8be19e2b0cc1fb@mail.gmail.com>
	 <4AFA8969.501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AFA8969.501-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2009 at 4:52 AM, Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi.
>
> how do you connect the QPs?
> via CM/CMA or by sockets (and you actually call the ibv_modify_qp)?
>

I exchange the initial QP infortion (lid, qpn, psn) via sockets.  No
CM is used. I manually take are of everything.

Thanks!

> Dotan
>
> neutron wrote:
>>
>> Hi Paul, thanks a lot for your quick reply!
>>
>> In my test, =A0client informs the server of its local memory (rkey,
>> addr, size) by sending 4 back to back messages, =A0each message elic=
its
>> a RDMA read request (RR) from the server.
>>
>> In other words, client exposes its memory to the server, and server
>> RDMA reads it.
>>
>> As far as RDMA read is concerned, server is a requester, and client =
is
>> a responder, right?
>>
>> The error I encountered happens at the initial phase, when client
>> sends 4 back to back messages to server(using ibv_post_send ),
>> containing (rkey, addr, size) client's local memory.
>>
>> In these 4 ibv_post_send(), client will see one failure. =A0 At serv=
er
>> side, server has already posted enough WQs in the RQ. =A0The failure=
s
>> are included in my first email.
>>
>> Looking at the program output, it appears that, server gets messages
>> 1, issues RR 1, gets message 2, issues RR 2. =A0 =A0But somehow clie=
nt
>> reports that "send message 2" fails.
>>
>> On the contrary, server reports "receive message 3" fails.
>>
>> As a result, server gets message 1,2,4, and succeeds with RR 1,2,4.
>> But clients sees that message 2 fails, and succeed with message 1,3,=
4.
>> =A0This inconsistency is the problem that puzzled me.
>>
>> ------------
>> By the way, how to interpret the parameters for RDMA, and what are
>> parameters that control RDMA behavior? =A0Below are something I can
>> find, there must be more....
>>
>> =A0 max_qp_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 4
>> =A0 max_res_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0258048
>> =A0 max_qp_init_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0128
>>
>> =A0 qp_attr.max_dest_rd_atomic
>> =A0 qp_attr.max_rd_atomic
>>
>>
>>
>> -neutron
>>
>>
>>
>> On Tue, Nov 10, 2009 at 2:04 AM, Paul Grun <pgrun@systemfabricworks.=
com>
>> wrote:
>>
>>>
>>> Is it possible that you exceeded the number of available RDMA Read
>>> Resources
>>> available on the server? =A0There is an expectation that the client=
 knows
>>> how
>>> many outstanding RDMA Read Requests the responder (server) is capab=
le of
>>> handling; if the requester (client) exceeds that number, the respon=
der
>>> will
>>> indeed return a NAK-Invalid Request. =A0Sounds like your server is
>>> configured
>>> to accept three outstanding RDMA Read Requests.
>>> This also explains why it works when you pause the program
>>> periodically...it
>>> gives the responder time to generate the RDMA Read Responses and
>>> therefore
>>> free up some resources to be used in receiving the next incoming RD=
MA
>>> Read
>>> Request.
>>>
>>> -Paul
>>>
>>> -----Original Message-----
>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of neutron
>>> Sent: Monday, November 09, 2009 9:04 PM
>>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Subject: back to back RDMA read fail?
>>>
>>> Hi all,
>>>
>>> I have a simple program that test back to back RDMA read performanc=
e.
>>> However I encountered errors for unknown reasons.
>>>
>>> The basic flow of my program is:
>>>
>>> client:
>>> ibv_post_send() to send 4 back to back messages to server (no delay
>>> inbetween). Each message contains the (rkey, addr, size) of a local
>>> buffer. The buffer is registered with remote-read/write/ permission=
s.
>>> After that, ibv_poll_cq() is called to wait for completion.
>>>
>>> server:
>>> First, enough receive WRs are posted to the RQ. =A0Upon receipt of =
each
>>> message, immediately post a RDMA read request, using the (rkey, add=
r,
>>> size) information contained in the originating message.
>>>
>>> --------------
>>> Both client and server use RC QP. =A0Some errors are observed.
>>>
>>> On client side, =A0ibv_poll_cq() gets 4 CQE, one out of the 4 CQE i=
s an
>>> error:
>>> CQ:: =A0wr_id=3D0x0, wc_opcode=3DIBV_WC_SEND, wc_status=3Dremote in=
valid RD
>>> request, wc_flag=3D0x3b
>>> =A0 =A0 byte_len=3D11338758, immdata=3D1110104528, qp_num=3D0x0, sr=
c_qp=3D2290530758
>>>
>>> The other 3 CQE are success.
>>>
>>> On server side,
>>> 3 of the 4 messages are successfully received. One message produces=
 an
>>> error CQE:
>>> CQ:: =A0wr_id=3D0x8000000000, wc_opcode=3DUnknow-wc-opcode,
>>> wc_status=3Dunknown, wc_flag=3D0x0
>>> =A0 =A0 byte_len=3D9569287, immdata=3D0, qp_num=3D0x0, src_qp=3D265=
551872
>>>
>>> The 3 RDMA read corresponding to the successful receive all succeed=
=2E
>>>
>>> But, if I pause the client program for a short while( usleep(100) f=
or
>>> example ) after calling ibv_post_send(), then no error occurs.
>>> Anyone can point out the pitfall here? Thanks!
>>>
>>>
>>> -----------
>>> On both client and server, I'm using =A0'mthca0' type MT25208. =A0T=
he QPs
>>> are initialized with "qp_attr.max_dest_rd_atomic=3D4,
>>> qp_attr.max_rd_atomic =3D 4". =A0The QP's "devinfo -v" gives the
>>> information:
>>>
>>> hca_id: mthca0
>>> =A0 =A0 =A0 fw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 5.1.400
>>> =A0 =A0 =A0 node_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00=
002:c902:0023:c04c
>>> =A0 =A0 =A0 sys_image_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0002:c9=
02:0023:c04f
>>> =A0 =A0 =A0 vendor_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00=
x02c9
>>> =A0 =A0 =A0 vendor_part_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 25218
>>> =A0 =A0 =A0 hw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0xA0
>>> =A0 =A0 =A0 board_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 M=
T_0370130002
>>> =A0 =A0 =A0 phys_port_cnt: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02
>>> =A0 =A0 =A0 max_mr_size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xf=
fffffffffffffff
>>> =A0 =A0 =A0 page_size_cap: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xfff=
ff000
>>> =A0 =A0 =A0 max_qp: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 64512
>>> =A0 =A0 =A0 max_qp_wr: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01=
6384
>>> =A0 =A0 =A0 device_cap_flags: =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00001c7=
6
>>> =A0 =A0 =A0 max_sge: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
27
>>> =A0 =A0 =A0 max_sge_rd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
>>> =A0 =A0 =A0 max_cq: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 65408
>>> =A0 =A0 =A0 max_cqe: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
131071
>>> =A0 =A0 =A0 max_mr: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 131056
>>> =A0 =A0 =A0 max_pd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 32764
>>> =A0 =A0 =A0 max_qp_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 4
>>> =A0 =A0 =A0 max_ee_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
>>> =A0 =A0 =A0 max_res_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0258048
>>> =A0 =A0 =A0 max_qp_init_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0128
>>> =A0 =A0 =A0 max_ee_init_rd_atom: =A0 =A0 =A0 =A0 =A0 =A00
>>> =A0 =A0 =A0 atomic_cap: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ATO=
MIC_HCA (1)
>>> =A0 =A0 =A0 max_ee: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0
>>> =A0 =A0 =A0 max_rdd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0
>>> =A0 =A0 =A0 max_mw: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0
>>> =A0 =A0 =A0 max_raw_ipv6_qp: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
>>> =A0 =A0 =A0 max_raw_ethy_qp: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
>>> =A0 =A0 =A0 max_mcast_grp: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A08192
>>> =A0 =A0 =A0 max_mcast_qp_attach: =A0 =A0 =A0 =A0 =A0 =A056
>>> =A0 =A0 =A0 max_total_mcast_qp_attach: =A0 =A0 =A0458752
>>> =A0 =A0 =A0 max_ah: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0
>>> =A0 =A0 =A0 max_fmr: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0
>>> =A0 =A0 =A0 max_srq: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
960
>>> =A0 =A0 =A0 max_srq_wr: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 163=
84
>>> =A0 =A0 =A0 max_srq_sge: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A027
>>> =A0 =A0 =A0 max_pkeys: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A06=
4
>>> =A0 =A0 =A0 local_ca_ack_delay: =A0 =A0 =A0 =A0 =A0 =A0 15
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>>
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
