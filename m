From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for v3.15 0/4] uverbs ABI fixes
Date: Mon, 05 May 2014 11:01:58 +0200
Message-ID: <1399280518.2957.15.camel@localhost.localdomain>
References: <1394814128-8815-1-git-send-email-hariprasad@chelsio.com>
	 <1394814128-8815-3-git-send-email-hariprasad@chelsio.com>
	 <1395848977.3297.15.camel@localhost.localdomain>
	 <007101cf490c$3ec7cb30$bc576190$@opengridcomputing.com>
	 <1394814128-8815-1-git-send-email-hariprasad@chelsio.com>
	 <1394814128-8815-3-git-send-email-hariprasad@chelsio.com>
	 <1395848977.3297.15.camel@localhost.localdomain>
	 <20140328082428.GH25192@mwanda>
	 <1396002468.3297.63.camel@localhost.localdomain>
	 <20140502235616.GJ4963@mwanda> <cover.1399216475.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 04 mai 2014 =C3=A0 23:21 +0200, Yann Droneaud a =C3=A9crit =
:

> Please find 4 patches which fix some issues regarding missing explici=
t
> padding at end of structure exchanged between kernel and userspace.
>=20

I've made a review of all others drivers. I've identified the following
structures as part of ABI:

cxgb3/iw_cxgb3.o     struct iwch_create_cq_req
cxgb3/iw_cxgb3.o     struct iwch_create_cq_resp
cxgb3/iw_cxgb3.o     struct iwch_create_qp_resp
cxgb3/iw_cxgb3.o     struct iwch_reg_user_mr_resp

cxgb4/iw_cxgb4.o     struct c4iw_alloc_ucontext_resp
cxgb4/iw_cxgb4.o     struct c4iw_create_cq_resp
cxgb4/iw_cxgb4.o     struct c4iw_create_qp_resp

ehca/ib_ehca.o       struct ehca_create_cq_resp
ehca/ib_ehca.o       struct ehca_create_qp_resp
ehca/ib_ehca.o       struct ipzu_queue_resp

mlx4/mlx4_ib.o       struct mlx4_ib_alloc_ucontext_resp
mlx4/mlx4_ib.o       struct mlx4_ib_alloc_ucontext_resp_v3
mlx4/mlx4_ib.o       struct mlx4_ib_create_cq
mlx4/mlx4_ib.o       struct mlx4_ib_create_qp
mlx4/mlx4_ib.o       struct mlx4_ib_create_srq
mlx4/mlx4_ib.o       struct mlx4_ib_resize_cq

mlx5/mlx5_ib.o       struct mlx5_ib_alloc_pd_resp
mlx5/mlx5_ib.o       struct mlx5_ib_alloc_ucontext_req_v2
mlx5/mlx5_ib.o       struct mlx5_ib_alloc_ucontext_resp
mlx5/mlx5_ib.o       struct mlx5_ib_create_cq
mlx5/mlx5_ib.o       struct mlx5_ib_create_qp
mlx5/mlx5_ib.o       struct mlx5_ib_create_qp_resp
mlx5/mlx5_ib.o       struct mlx5_ib_create_srq
mlx5/mlx5_ib.o       struct mlx5_ib_resize_cq

mthca/ib_mthca.o     struct mthca_alloc_ucontext_resp
mthca/ib_mthca.o     struct mthca_create_cq
mthca/ib_mthca.o     struct mthca_create_qp
mthca/ib_mthca.o     struct mthca_create_srq
mthca/ib_mthca.o     struct mthca_reg_mr
mthca/ib_mthca.o     struct mthca_resize_cq

nes/iw_nes.o         struct nes_alloc_pd_resp
nes/iw_nes.o         struct nes_alloc_ucontext_req
nes/iw_nes.o         struct nes_alloc_ucontext_resp
nes/iw_nes.o         struct nes_create_cq_req
nes/iw_nes.o         struct nes_create_cq_resp
nes/iw_nes.o         struct nes_create_qp_req
nes/iw_nes.o         struct nes_create_qp_resp
nes/iw_nes.o         struct nes_mem_reg_req

ocrdma/ocrdma.o      struct ocrdma_alloc_pd_uresp
ocrdma/ocrdma.o      struct ocrdma_alloc_ucontext_resp
ocrdma/ocrdma.o      struct ocrdma_create_cq_ureq
ocrdma/ocrdma.o      struct ocrdma_create_cq_uresp
ocrdma/ocrdma.o      struct ocrdma_create_qp_ureq
ocrdma/ocrdma.o      struct ocrdma_create_qp_uresp
ocrdma/ocrdma.o      struct ocrdma_create_srq_uresp

usnic/usnic_verbs.o  struct usnic_ib_create_qp_cmd
usnic/usnic_verbs.o  struct usnic_ib_create_qp_resp
usnic/usnic_verbs.o  struct usnic_transport_spec

It seems that amso1100/iw_c2.o, ipath/ib_ipath.o and qib/ib_qib.o don't
make use of structure to exchange data with userspace: they use single
values, either u32 or u64.

So using pahole I've found issues in mlx5 and cxgb4 only.

> These makes i386 userspace libraries and x86_64 kernel disagree about
> the size of the structures.
>=20
> Additionally, as reported by Dan Carpenter, in one case, stack inform=
ation
> can be leaked by the kernel to userspace due to implicit padding bein=
g not
> initialized.
>=20
> Unfortunately, the data structure cannot be fixed alone as it would b=
reak
> existing applications. So in order to remain compatible with i386 lib=
raries,
> providers (hw) functions are modified to use the input length to gues=
s the
> expected format of the command in order to check the content of the r=
eserved
> field for future usage. Other are modified to not write the padding f=
ield in
> response to make the kernel able to handle gracefully i386 userspace =
on x86_64.
>=20
> For full coherency, patches against the userspace libraries (libcxgb4=
 and
> libmlx5) will be submitted as a followup to update the data structure=
 on
> userspace side.
>=20

BTW, as I don't have the hardware / I don't have access to the hardware=
,
the patches are not tested against real world. (I only have HCAs handle=
d
by mlx4 and qib drivers).

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
