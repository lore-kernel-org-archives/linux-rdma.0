From: neutron <neutronsharc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: back to back RDMA read fail?
Date: Tue, 10 Nov 2009 00:03:53 -0500
Message-ID: <7d5928b30911092103r5b730091jd2ca2581f540ea3d@mail.gmail.com>
References: <7d5928b30911092036v6d1196a8m53287dc5eebb654d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7d5928b30911092036v6d1196a8m53287dc5eebb654d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

I have a simple program that test back to back RDMA read performance.
However I encountered errors for unknown reasons.

The basic flow of my program is:

client:
ibv_post_send() to send 4 back to back messages to server (no delay
inbetween). Each message contains the (rkey, addr, size) of a local
buffer. The buffer is registered with remote-read/write/ permissions.
After that, ibv_poll_cq() is called to wait for completion.

server:
=46irst, enough receive WRs are posted to the RQ. =A0Upon receipt of ea=
ch
message, immediately post a RDMA read request, using the (rkey, addr,
size) information contained in the originating message.

--------------
Both client and server use RC QP. =A0Some errors are observed.

On client side, =A0ibv_poll_cq() gets 4 CQE, one out of the 4 CQE is an=
 error:
CQ:: =A0wr_id=3D0x0, wc_opcode=3DIBV_WC_SEND, wc_status=3Dremote invali=
d RD
request, wc_flag=3D0x3b
=A0 =A0 =A0byte_len=3D11338758, immdata=3D1110104528, qp_num=3D0x0, src=
_qp=3D2290530758

The other 3 CQE are success.

On server side,
3 of the 4 messages are successfully received. One message produces an
error CQE:
CQ:: =A0wr_id=3D0x8000000000, wc_opcode=3DUnknow-wc-opcode,
wc_status=3Dunknown, wc_flag=3D0x0
=A0 =A0 =A0byte_len=3D9569287, immdata=3D0, qp_num=3D0x0, src_qp=3D2655=
51872

The 3 RDMA read corresponding to the successful receive all succeed.

But, if I pause the client program for a short while( usleep(100) for
example ) after calling ibv_post_send(), then no error occurs.
Anyone can point out the pitfall here? Thanks!


-----------
On both client and server, I'm using =A0'mthca0' type MT25208. =A0The Q=
Ps
are initialized with "qp_attr.max_dest_rd_atomic=3D4,
qp_attr.max_rd_atomic =3D 4". =A0The QP's "devinfo -v" gives the
information:

hca_id: mthca0
=A0 =A0 =A0 =A0fw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
5.1.400
=A0 =A0 =A0 =A0node_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A000=
02:c902:0023:c04c
=A0 =A0 =A0 =A0sys_image_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0002:c90=
2:0023:c04f
=A0 =A0 =A0 =A0vendor_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x=
02c9
=A0 =A0 =A0 =A0vendor_part_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 25218
=A0 =A0 =A0 =A0hw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0xA0
=A0 =A0 =A0 =A0board_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MT=
_0370130002
=A0 =A0 =A0 =A0phys_port_cnt: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02
=A0 =A0 =A0 =A0max_mr_size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xff=
ffffffffffffff
=A0 =A0 =A0 =A0page_size_cap: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xffff=
f000
=A0 =A0 =A0 =A0max_qp: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
64512
=A0 =A0 =A0 =A0max_qp_wr: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A016=
384
=A0 =A0 =A0 =A0device_cap_flags: =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00001c76
=A0 =A0 =A0 =A0max_sge: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
27
=A0 =A0 =A0 =A0max_sge_rd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
=A0 =A0 =A0 =A0max_cq: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
65408
=A0 =A0 =A0 =A0max_cqe: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
131071
=A0 =A0 =A0 =A0max_mr: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
131056
=A0 =A0 =A0 =A0max_pd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
32764
=A0 =A0 =A0 =A0max_qp_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 4
=A0 =A0 =A0 =A0max_ee_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
=A0 =A0 =A0 =A0max_res_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0258048
=A0 =A0 =A0 =A0max_qp_init_rd_atom: =A0 =A0 =A0 =A0 =A0 =A0128
=A0 =A0 =A0 =A0max_ee_init_rd_atom: =A0 =A0 =A0 =A0 =A0 =A00
=A0 =A0 =A0 =A0atomic_cap: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ATOM=
IC_HCA (1)
=A0 =A0 =A0 =A0max_ee: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0
=A0 =A0 =A0 =A0max_rdd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0
=A0 =A0 =A0 =A0max_mw: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0
=A0 =A0 =A0 =A0max_raw_ipv6_qp: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
=A0 =A0 =A0 =A0max_raw_ethy_qp: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
=A0 =A0 =A0 =A0max_mcast_grp: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A08192
=A0 =A0 =A0 =A0max_mcast_qp_attach: =A0 =A0 =A0 =A0 =A0 =A056
=A0 =A0 =A0 =A0max_total_mcast_qp_attach: =A0 =A0 =A0458752
=A0 =A0 =A0 =A0max_ah: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0
=A0 =A0 =A0 =A0max_fmr: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0
=A0 =A0 =A0 =A0max_srq: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
960
=A0 =A0 =A0 =A0max_srq_wr: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1638=
4
=A0 =A0 =A0 =A0max_srq_sge: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A027
=A0 =A0 =A0 =A0max_pkeys: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A064
=A0 =A0 =A0 =A0local_ca_ack_delay: =A0 =A0 =A0 =A0 =A0 =A0 15
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
