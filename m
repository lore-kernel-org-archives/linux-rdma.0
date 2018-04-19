From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] RDMA/ucma: Allow resolving address without specifying source address
Date: Thu, 19 Apr 2018 08:28:11 -0700
Message-ID: <20180419152811.4340-1-roland@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Roland Dreier <roland@purestorage.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

The RDMA CM will select a source device and address by consulting the routing table
if no source address is passed into rdma_resolve_address().  Userspace will ask for
this by passing an all-zero source address in the RESOLVE_IP command.  Unfortunately
the new check for non-zero address size rejects this with EINVAL, which breaks valid
userspace applications.

Fix this by explicitly allowing a zero address family for the source.

Fixes: 2975d5de6428 ("RDMA/ucma: Check AF family prior resolving address")
Cc: <stable@vger.kernel.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 74329483af6d..0a7242ce7c1f 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -683,7 +683,7 @@ static ssize_t ucma_resolve_ip(struct ucma_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-	if (!rdma_addr_size_in6(&cmd.src_addr) ||
+	if ((cmd.src_addr.sin6_family && !rdma_addr_size_in6(&cmd.src_addr)) ||
 	    !rdma_addr_size_in6(&cmd.dst_addr))
 		return -EINVAL;
 
-- 
2.17.0
