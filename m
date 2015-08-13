From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] RDMA/cma: fix IPv6 address resolution
Date: Thu, 13 Aug 2015 12:19:10 -0700
Message-ID: <1439493550-5958-1-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Spencer Baugh <sbaugh@catern.com>, "open list:INFINIBAND SUBSYSTEM" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>
List-Id: linux-rdma@vger.kernel.org

Resolving a link-local IPv6 address with an unspecified source address
was broken by commit 5462eddd7a, which prevented the IPv6 stack from
learning the scope id of the link-local IPv6 address, causing random
failures as the IP stack chose a random link to resolve the address on.

This commit 5462eddd7a made us bail out of cma_check_linklocal early if
the address passed in was not an IPv6 link-local address. On the address
resolution path, the address passed in is the source address; if the
source address is the unspecified address, which is not link-local, we
will bail out early.

This is mostly correct, but if the destination address is a link-local
address, then we will be following a link-local route, and we'll need to
tell the IPv6 stack what the scope id of the destination address is.
This used to be done by last line of cma_check_linklocal, which is
skipped when bailing out early:

	dev_addr->bound_dev_if = sin6->sin6_scope_id;

(In cma_bind_addr, the sin6_scope_id of the source address is set to the
sin6_scope_id of the destination address, so this is correct)
This line is required in turn for the following line, L279 of
addr6_resolve, to actually inform the IPv6 stack of the scope id:

      fl6.flowi6_oif = addr->bound_dev_if;

Since we can only know we are in this failure case when we have access
to both the source IPv6 address and destination IPv6 address, we have to
deal with this further up the stack. So detect this failure case in
cma_bind_addr, and set bound_dev_if to the destination address scope id
to correct it.

Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/infiniband/core/cma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6a6b60a..3b71154 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2188,8 +2188,11 @@ static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		src_addr = (struct sockaddr *) &id->route.addr.src_addr;
 		src_addr->sa_family = dst_addr->sa_family;
 		if (dst_addr->sa_family == AF_INET6) {
-			((struct sockaddr_in6 *) src_addr)->sin6_scope_id =
-				((struct sockaddr_in6 *) dst_addr)->sin6_scope_id;
+			struct sockaddr_in6 *src_addr6 = (struct sockaddr_in6 *) src_addr;
+			struct sockaddr_in6 *dst_addr6 = (struct sockaddr_in6 *) dst_addr;
+			src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
+			if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
+				id->route.addr.dev_addr.bound_dev_if = dst_addr6->sin6_scope_id;
 		} else if (dst_addr->sa_family == AF_IB) {
 			((struct sockaddr_ib *) src_addr)->sib_pkey =
 				((struct sockaddr_ib *) dst_addr)->sib_pkey;
-- 
2.5.0.rc3
