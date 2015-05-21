From: jglisse@redhat.com
Subject: [PATCH 31/36] IB/odp: export rbt_ib_umem_for_each_in_range()
Date: Thu, 21 May 2015 16:23:07 -0400
Message-ID: <1432239792-5002-12-git-send-email-jglisse@redhat.com>
References: <1432236705-4209-1-git-send-email-j.glisse@gmail.com>
 <1432239792-5002-1-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1432239792-5002-1-git-send-email-jglisse@redhat.com>
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>, joro@8bytes.org, Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Johannes Weiner <jweiner@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>, Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>, Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Mark Hairgrove <mhairgrove@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>

The mlx5 driver will need this function for its driver specific bit
of ODP (on demand paging) on HMM (Heterogeneous Memory Management).

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
cc: <linux-rdma@vger.kernel.org>
---
 drivers/infiniband/core/umem_rbtree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/umem_rbtree.c b/drivers/infiniband/c=
ore/umem_rbtree.c
index 727d788..f030ec0 100644
--- a/drivers/infiniband/core/umem_rbtree.c
+++ b/drivers/infiniband/core/umem_rbtree.c
@@ -92,3 +92,4 @@ int rbt_ib_umem_for_each_in_range(struct rb_root *root,
=20
 	return ret_val;
 }
+EXPORT_SYMBOL(rbt_ib_umem_for_each_in_range);
--=20
1.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
