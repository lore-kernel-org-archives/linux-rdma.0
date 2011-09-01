From: Tommi T <tommi_t77-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: mlx ipoib error
Date: Thu, 1 Sep 2011 02:33:05 -0700 (PDT)
Message-ID: <1314869585.71072.YahooMailNeo@web113913.mail.gq1.yahoo.com>
Reply-To: Tommi T <tommi_t77-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello

Sometimes ipoib stops working and dmesg is full of following errors:

Mellanox OFED 1.5.3, kernel 2.6.18-238.19.1.el5 and adapter is=A0
MT26418, Firmware version: 2.8.0


ib0: failed to modify QP to INIT: -16
ib0: failed to modify QP to INIT: -16
ib0: failed to modify QP to INIT: -16
ib0: failed to modify QP to INIT: -16
ib0: failed to modify QP to INIT: -16
ib0: failed to modify QP to INIT: -16

Here I tried to lctl ping lustre servers, lustre still works fine.


LustreError: 28519:0:(o2iblnd.c:776:kiblnd_create_conn()) Can't create =
CQ: -16, cqe: 2074
LustreError: 28519:0:(o2iblnd.c:776:kiblnd_create_conn()) Can't create =
CQ: -16, cqe: 2074
LustreError: 28519:0:(o2iblnd.c:776:kiblnd_create_conn()) Can't create =
CQ: -16, cqe: 2074
LustreError: 28519:0:(o2iblnd.c:776:kiblnd_create_conn()) Can't create =
CQ: -16, cqe: 2074
LustreError: 28763:0:(o2iblnd.c:776:kiblnd_create_conn()) Can't create =
CQ: -16, cqe: 2074

I tried to rmmod ipoib module which hanged and after that adapter tried=
 to reset itself=20


ib0: ib_query_gid() failed
ib0: ib_detach_mcast failed (result =3D -16)
ib0: ib_query_port failed
ib0: ib_detach_mcast failed (result =3D -16)
ib0: ib_detach_mcast failed (result =3D -16)
ib0: ib_detach_mcast failed (result =3D -16)
ib0: Failed to modify QP to ERROR state
ib0: timing out; 0 sends 253 receives not completed
ib0: Failed to modify QP to RESET state
mlx4_ib: modify QP 000048 to RESET failed.
mlx4_core 0000:48:00.0: HW2SW_CQ failed (-16) for CQN 000083
mlx4_core 0000:48:00.0: HW2SW_CQ failed (-16) for CQN 000082
mlx4_core 0000:48:00.0: HW2SW_SRQ failed (-16) for SRQN 000040
mlx4_core 0000:48:00.0: HW2SW_MPT failed (-16)
mlx4_core 0000:48:00.0: HW2SW_CQ failed (-16) for CQN 000085
mlx4_core 0000:48:00.0: HW2SW_CQ failed (-16) for CQN 000084
mlx4_core 0000:48:00.0: HW2SW_SRQ failed (-16) for SRQN 000041
mlx4_core 0000:48:00.0: HW2SW_MPT failed (-16)
mlx4_0: ib_query_port 1 failed
mlx4_0: ib_query_port 2 failed


Is there any ipoib module options which I could tune?

BR, Tommi

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
