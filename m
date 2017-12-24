From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-rc 3/4] IB/uverbs: Fix command checking as part of ib_uverbs_ex_modify_qp()
Date: Sun, 24 Dec 2017 13:54:57 +0200
Message-ID: <20171224115458.27577-4-leon@kernel.org>
References: <20171224115458.27577-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171224115458.27577-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Mark Bloch <markb@mellanox.com>, Moni Shoua <monis@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

If the input command length is larger than the kernel supports an error
should be returned in case the unsupported bytes are not cleared.

Cc: <stable@vger.kernel.org> # v4.10
Fixes: 189aba99e700 ("IB/uverbs: Extend modify_qp and support packet pacing")
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d0202bb176a4..840b24096690 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2074,8 +2074,8 @@ int ib_uverbs_ex_modify_qp(struct ib_uverbs_file *file,
 		return -EOPNOTSUPP;
 
 	if (ucore->inlen > sizeof(cmd)) {
-		if (ib_is_udata_cleared(ucore, sizeof(cmd),
-					ucore->inlen - sizeof(cmd)))
+		if (!ib_is_udata_cleared(ucore, sizeof(cmd),
+					 ucore->inlen - sizeof(cmd)))
 			return -EOPNOTSUPP;
 	}
 
-- 
2.15.1
