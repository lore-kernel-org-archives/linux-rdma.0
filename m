From: Greg Thelen <gthelen@google.com>
Subject: [PATCH] RDMA/ucma: reject AF_IB ip multicast requests
Date: Thu, 29 Mar 2018 21:24:55 -0700
Message-ID: <20180330042455.81032-1-gthelen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
List-Id: linux-rdma@vger.kernel.org

syzbot discovered that ucma_join_ip_multicast() mishandles AF_IB request
addresses.  If an RDMA_USER_CM_CMD_JOIN_IP_MCAST request has
cmd.addr.sa_family=AF_IB then ucma_join_ip_multicast() reads beyond the
end of its cmd.addr.

Reject non IP RDMA_USER_CM_CMD_JOIN_IP_MCAST requests.
RDMA_USER_CM_CMD_JOIN_MCAST is interface for AF_IB multicast.

And add a buffer length safety check.

Fixes: 5bc2b7b397b0 ("RDMA/ucma: Allow user space to specify AF_IB when joining multicast")
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 drivers/infiniband/core/ucma.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index e5a1e7d81326..e410e03940ff 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1423,11 +1423,19 @@ static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
+	switch (cmd.addr.sin6_family) {
+	case AF_INET:
+	case AF_INET6:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	join_cmd.response = cmd.response;
 	join_cmd.uid = cmd.uid;
 	join_cmd.id = cmd.id;
 	join_cmd.addr_size = rdma_addr_size((struct sockaddr *) &cmd.addr);
-	if (!join_cmd.addr_size)
+	if (!join_cmd.addr_size || join_cmd.addr_size > sizeof(cmd.addr))
 		return -EINVAL;
 
 	join_cmd.join_flags = RDMA_MC_JOIN_FLAG_FULLMEMBER;
-- 
2.17.0.rc1.321.gba9d0f2565-goog
