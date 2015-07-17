From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH 3/8] IB/odp: export rbt_ib_umem_for_each_in_range()
Date: Fri, 17 Jul 2015 15:01:00 -0400
Message-ID: <1437159665-6612-4-git-send-email-jglisse@redhat.com>
References: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christophe Harle <charle@nvidia.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Mark Hairgrove <mhairgrove@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Haggai Eran <haggaie@mellanox.com>, Shachar Raindel <raindel@mellanox.com>, Liran Liss <liranl@mellanox.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
List-Id: linux-rdma@vger.kernel.org

The mlx5 driver will need this function for its driver specific bit
of ODP (on demand paging) on HMM (Heterogeneous Memory Management).

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
---
 drivers/infiniband/core/umem_rbtree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/umem_rbtree.c b/drivers/infiniband=
/core/umem_rbtree.c
index 727d788..f030ec0 100644
--- a/drivers/infiniband/core/umem_rbtree.c
+++ b/drivers/infiniband/core/umem_rbtree.c
@@ -92,3 +92,4 @@ int rbt_ib_umem_for_each_in_range(struct rb_root *roo=
t,
=20
 	return ret_val;
 }
+EXPORT_SYMBOL(rbt_ib_umem_for_each_in_range);
--=20
1.9.3
