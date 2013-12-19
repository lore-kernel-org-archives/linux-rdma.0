From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: git tree with pending patch sets
Date: Thu, 19 Dec 2013 14:34:40 +0200
Message-ID: <52B2E7E0.1050605@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Everyone,

Wanted to let people know that I have set a public git tree with pending 
patch sets sent by Mellanox over the last months, you can pull

git://beany.openfabrics.org/~ogerlitz/linux-2.6.git for-next

where this branch is rebased against the for-next branch of Roland's tree

git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git

as of the latest commit a2f2eed "RDMA/ocrdma: Fix OCRDMA_GEN2_FAMILY 
macro definition"

Or.

IPoIB flow-streering V0

cde8fa5 IB/mlx4_ib: Add support for steer-able IB UD QPs
a5e6350 IB/mlx4_ib: Add mechanism to support flow-steering over IB links
1b3a4e4 IB/mlx4_ib: Enable device managed steering support for IB ports too
3ae784f net/mlx4_core: Add support for steer-able IB UD QPs
6e893a5 IB/core: Add support for IB L2 device managed steering
44907ca IB/core: Add flow-steering support for IPoIB UD traffic

T10 signature RDMA offloads V4

2b4316b IB/mlx5: Publish support in signature feature
ef3130d IB/mlx5: Collect signature error completion
c1b37b1 IB/mlx5: Support IB_WR_REG_SIG_MR
f5d8496 IB/mlx5: Keep mlx5 MRs in a radix tree under device
72a72ee IB/mlx5: remove MTT access mode from umr flags helper function
ccb0a907 IB/mlx5: Break wqe handling to begin & finish routines
cda0569 IB/mlx5: Initialize mlx5_ib_qp signature related
33b4079 IB/mlx5, mlx5_core: Support for create_mr and destroy_mr
8b343e6 IB/core: Introduce Signature Verbs API
c1b0358 IB/core: Introduce protected memory regions

RoCE IP based Addressing V6

a6ba717 IB/core: Resolve Ethernet L2 addresses when modifying QP
69fcf93 IB/ocrdma: Populate GID table with IP based gids
229ad58 IB/ocrdma: Handle Ethernet L2 parameters for IP based GID 
addressing
f321fef IB/mlx4: Handle Ethernet L2 parameters for IP based GID addressing
a949d4d IB/mlx4: Use IBoE (RoCE) IP based GIDs in the port GID table
74f80ba IB/CMA: IBoE (RoCE) IP based GID addressing
0f109190 IB/core: Ethernet L2 attributes in verbs/cm structures
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
