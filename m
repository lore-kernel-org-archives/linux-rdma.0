From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 5/9] kern-abi: remove unused qp_type union in struct ibv_kern_send_wr
Date: Wed,  1 Oct 2014 13:49:35 +0200
Message-ID: <489f515ee8e477ed61fd690894d1954dd056ecd1.1412163687.git.ydroneaud@opteya.com>
References: <cover.1412163687.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added by commit c7e3e61052dd ('Add support for XRC QPs') in
struct ibv_kern_send_wr, qp_type union is not initialized
in ibv_cmd_post_send().

Additionnaly, as reported by pahole, this field introduces
padding in the end of struct ibv_kern_send_wr:

    struct ibv_kern_send_wr {

            /* ... */

            union {
                    struct {
                            __u32      remote_srqn;          /*    56     4 */
                    } xrc;                                   /*           4 */
            } qp_type;                                       /*    56     4 */

            /* size: 64, cachelines: 1, members: 7 */
            /* padding: 4 */
    };

This padding is not initialized too.

Since this field is not used at all kernel side and not exposed
to drivers, qp_type union in struct ibv_kern_send_wr could be
removed from the structure.

Link: http://marc.info/?i=cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Fixes: c7e3e61052dd ('Add support for XRC QPs')
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 include/infiniband/kern-abi.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 91b45d837239..7023a0294df2 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -676,11 +676,6 @@ struct ibv_kern_send_wr {
 			__u32 reserved;
 		} ud;
 	} wr;
-	union {
-		struct {
-			__u32 remote_srqn;
-		} xrc;
-	} qp_type;
 };
 
 struct ibv_kern_eth_filter {
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
