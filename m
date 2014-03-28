From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 01/16] ibacm: get_devaddr remove unused variable from signature
Date: Thu, 27 Mar 2014 22:49:55 -0700
Message-ID: <1395985810-23822-2-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 linux/acme_linux.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/linux/acme_linux.c b/linux/acme_linux.c
index ef5b107..6978db7 100644
--- a/linux/acme_linux.c
+++ b/linux/acme_linux.c
@@ -102,7 +102,7 @@ get_sgid(struct ifreq *ifr, union ibv_gid *sgid)
 }
 
 static int
-get_devaddr(int s, struct ifreq *ifr,
+get_devaddr(struct ifreq *ifr,
 	int *dev_index, uint8_t *port, uint16_t *pkey)
 {
 	struct ibv_device_attr dev_attr;
@@ -199,7 +199,7 @@ int gen_addr_ip(FILE *f)
 		if (ifr[i].ifr_hwaddr.sa_family != ARPHRD_INFINIBAND)
 			continue;
 
-		ret = get_devaddr(s, &ifr[i], &dev_index, &port, &pkey);
+		ret = get_devaddr(&ifr[i], &dev_index, &port, &pkey);
 		if (ret)
 			continue;
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
