From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 14/39] IB/hfi1: Validate page aligned for a given virtual address
Date: Fri, 14 Jun 2019 16:29:19 -0400
Message-ID: <20190614202946.27385-14-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kamenee Arumugam <kamenee.arumugam@intel.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Kamenee Arumugam <kamenee.arumugam@intel.com>

[ Upstream commit 97736f36dbebf2cda2799db3b54717ba5b388255 ]

User applications can register memory regions for TID buffers that are not
aligned on page boundaries. Hfi1 is expected to pin those pages in memory
and cache the pages with mmu_rb. The rb tree will fail to insert pages
that are not aligned correctly.

Validate whether a given virtual address is page aligned before pinning.

Fixes: 7e7a436ecb6e ("staging/hfi1: Add TID entry program function body")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index dbe7d14a5c76..4e986ca4dd35 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -324,6 +324,9 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	u32 *tidlist = NULL;
 	struct tid_user_buf *tidbuf;
 
+	if (!PAGE_ALIGNED(tinfo->vaddr))
+		return -EINVAL;
+
 	tidbuf = kzalloc(sizeof(*tidbuf), GFP_KERNEL);
 	if (!tidbuf)
 		return -ENOMEM;
-- 
2.20.1
