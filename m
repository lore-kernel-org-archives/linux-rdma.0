From: Joe Perches <joe@perches.com>
Subject: [PATCH 07/24] infiniband: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:50 -0700
Message-ID: <9ba950ecbbe17f69ac7362f14bf939180b13091c.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b0f189b..3f93093 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -57,7 +57,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 static unsigned int max_backlog = 1024;
 
 static struct ctl_table_header *ucma_ctl_table_hdr;
-static ctl_table ucma_ctl_table[] = {
+static struct ctl_table ucma_ctl_table[] = {
 	{
 		.procname	= "max_backlog",
 		.data		= &max_backlog,
-- 
1.8.1.2.459.gbcd45b4.dirty
