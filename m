From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] i40iw: avoid potential uninitialized variable use
Date: Wed, 23 Mar 2016 11:34:36 +0100
Message-ID: <1458729361-3089439-1-git-send-email-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shannon Nelson <shannon.nelson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anjali Singhai Jain <anjali.singhai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

gcc finds that the i40iw_make_cm_node() function in the recently added
i40iw driver uses an uninitilized variable as an index into an array
if CONFIG_IPV6 is disabled and the driver uses IPv6 mode:

drivers/infiniband/hw/i40iw/i40iw_cm.c: In function 'i40iw_make_cm_node':
drivers/infiniband/hw/i40iw/i40iw_cm.c:2206:52: error: 'arpindex' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  ether_addr_copy(cm_node->rem_mac, iwdev->arp_table[arpindex].mac_addr);

As far as I can tell, this code path can not be used because the ipv4
variable is always set with CONFIG_IPV6 is disabled, but it's better
to be sure and prevent the undefined behavior, as well as shut up
that warning in a proper way.

This adds an 'else' clause for the case we get the warning about,
causing the function to return an error in a controlled way.
To avoid adding extra mess with combined io()/#ifdef clauses,
I'm also converting the existing #ifdef into a more readable
if(IS_ENABLED()) check.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Fixes: f27b4746f378 ("i40iw: add connection management code")
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 92745d755272..38f917a6c778 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1992,7 +1992,6 @@ static int i40iw_addr_resolve_neigh(struct i40iw_device *iwdev,
 /**
  * i40iw_get_dst_ipv6
  */
-#if IS_ENABLED(CONFIG_IPV6)
 static struct dst_entry *i40iw_get_dst_ipv6(struct sockaddr_in6 *src_addr,
 					    struct sockaddr_in6 *dst_addr)
 {
@@ -2008,7 +2007,6 @@ static struct dst_entry *i40iw_get_dst_ipv6(struct sockaddr_in6 *src_addr,
 	dst = ip6_route_output(&init_net, NULL, &fl6);
 	return dst;
 }
-#endif
 
 /**
  * i40iw_addr_resolve_neigh_ipv6 - resolve neighbor ipv6 address
@@ -2016,7 +2014,6 @@ static struct dst_entry *i40iw_get_dst_ipv6(struct sockaddr_in6 *src_addr,
  * @dst_ip: remote ip address
  * @arpindex: if there is an arp entry
  */
-#if IS_ENABLED(CONFIG_IPV6)
 static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 					 u32 *src,
 					 u32 *dest,
@@ -2089,7 +2086,6 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 	dst_release(dst);
 	return rc;
 }
-#endif
 
 /**
  * i40iw_ipv4_is_loopback - check if loopback
@@ -2190,13 +2186,13 @@ static struct i40iw_cm_node *i40iw_make_cm_node(
 							    cm_info->loc_addr[0],
 							    cm_info->rem_addr[0],
 							    oldarpindex);
-#if IS_ENABLED(CONFIG_IPV6)
-		else
+		else if (IS_ENABLED(CONFIG_IPV6))
 			arpindex = i40iw_addr_resolve_neigh_ipv6(iwdev,
 								 cm_info->loc_addr,
 								 cm_info->rem_addr,
 								 oldarpindex);
-#endif
+		else
+			arpindex = -EINVAL;
 	}
 	if (arpindex < 0) {
 		i40iw_pr_err("cm_node arpindex\n");
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
