From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 01/33] Revert "IB/core: Add flow control to the portmapper netlink calls"
Date: Tue,  1 Aug 2017 15:05:04 +0300
Message-ID: <20170801120536.540-2-leon@kernel.org>
References: <20170801120536.540-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801120536.540-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The commit cea05eadded0 ("IB/core: Add flow control to the portmapper netlink calls")
changed netlink to be blocked for all RDMA clients. This workaround
worked perfectly for portmapper, but is not correct for the whole
NETLINK_RDMA family.

The request/response should always be blocking and asynchronous
notification should always be non-blocking.

It is library and user-space application to chose how to handle recvmgs,
as an example see nl_recvmsgs() and nl_socket_set_nonblocking() calls of
libnl library.

Send timeout is not needed too and can be configured with SO_SNDTIMEO socket
option.

This reverts commit cea05eadded0d4eb59f7be6e1f1560eb6bfde2bf.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 94931c474d41..454d51e432db 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -230,10 +230,7 @@ static void ibnl_rcv(struct sk_buff *skb)
 int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 			__u32 pid)
 {
-	int err;
-
-	err = netlink_unicast(nls, skb, pid, 0);
-	return (err < 0) ? err : 0;
+	return nlmsg_unicast(nls, skb, pid);
 }
 EXPORT_SYMBOL(ibnl_unicast);
 
@@ -256,7 +253,6 @@ int __init ibnl_init(void)
 		return -ENOMEM;
 	}
 
-	nls->sk_sndtimeo = 10 * HZ;
 	return 0;
 }
 
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
