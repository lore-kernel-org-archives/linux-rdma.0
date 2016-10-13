From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 09/32] iwpmd: remove the unused check_iwpm_nlattr_tb prototype
Date: Thu, 13 Oct 2016 19:51:12 +0200
Message-ID: <1476381095-20041-10-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/iwarp_pm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/iwpmd/iwarp_pm.h b/iwpmd/iwarp_pm.h
index 8b7eeb1..1a2b69a 100644
--- a/iwpmd/iwarp_pm.h
+++ b/iwpmd/iwarp_pm.h
@@ -209,8 +209,6 @@ int create_netlink_socket(void);
 
 void destroy_iwpm_socket(int);
 
-int check_iwpm_nlattr_tb(struct nlattr * [], int);
-
 int parse_iwpm_nlmsg(struct nlmsghdr *, int, struct nla_policy *, struct nlattr * [], const char *);
 
 int parse_iwpm_msg(iwpm_wire_msg *, iwpm_msg_parms *);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
