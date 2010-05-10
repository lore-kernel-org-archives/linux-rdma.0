From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Mon, 10 May 2010 13:34:13 +0300
Message-ID: <201005101334.14029.jackm@dev.mellanox.co.il>
References: <201002281102.21207.jackm@dev.mellanox.co.il> <adaaasearf5.fsf@roland-alpha.cisco.com> <201005101301.43113.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201005101301.43113.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Monday 10 May 2010 13:01, Jack Morgenstein wrote:
> I have an initial implementation of this which I will clean up and se=
nd you for review (actually, an
> implementation which has the ib_create_xrc_rcv_qp/ib_destroy_xrc_rcv_=
qp, and which does
> not need the low-level driver implementations of reg/unreg. =A0I star=
ted off with this
> implementation, and discontinued it when I noticed how different it w=
as from the original
> XRC RCV implementation... but saved it just in case).
>=20
I remember now why I discontinued developing this implementation.  Ther=
e is no provision for core-layer-only
verbs in the core driver.

To implement ib_reg_xrc_rcv_qp/ib_unreg_xrc_rcv_qp (when I still had th=
e create and destroy verbs),
I needed to declare these in the uverbs_cmd_mask in the low-level drive=
r.

(from procedure mlx4_ib_add, in file hw/mlx4/main.c:)
       	ibdev->ib_dev.uverbs_cmd_mask |=3D
			(1ull << IB_USER_VERBS_CMD_CREATE_XRC_SRQ)	|
			(1ull << IB_USER_VERBS_CMD_OPEN_XRCD)	|
			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD)	|
			(1ull << IB_USER_VERBS_CMD_CREATE_XRC_RCV_QP)	|
			(1ull << IB_USER_VERBS_CMD_MODIFY_XRC_RCV_QP)	|
			(1ull << IB_USER_VERBS_CMD_QUERY_XRC_RCV_QP)	|
			(1ull << IB_USER_VERBS_CMD_DESTROY_XRC_RCV_QP)  |
=3D=3D>			(1ull << IB_USER_VERBS_CMD_REG_XRC_RCV_QP)	|
=3D=3D>			(1ull << IB_USER_VERBS_CMD_UNREG_XRC_RCV_QP);

with use of this mask in ib_uverbs_write:
	if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << hdr.command)))
		return -ENOSYS;

In order to fix this layering violation,I would have needed to do fairl=
y ugly things in
ib_register_device -- to test if, say, the IB_USER_VERBS_CMD_CREATE_XRC=
_RCV_QP bit is
set -- and if yes, to also add bits at the core layer for IB_USER_VERBS=
_CMD_REG_XRC_RCV_QP and
IB_USER_VERBS_CMD_UNREG_XRC_RCV_QP. Ugh.

However, with your suggestion of combining the create/reg and the destr=
oy/unreg into a single
verb, this difficulty goes away, and the low-level driver can still dec=
lare those verbs for its task of
creating and destroying the XRC RCV QPs.

I will continue with the reg/unreg implementation.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
