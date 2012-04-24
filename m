From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2 5/5] infiniband-diags: Add m_key option to config file
Date: Mon, 23 Apr 2012 17:56:57 -0700
Message-ID: <1335229017-10677-5-git-send-email-foraker1@llnl.gov>
References: <1335228837.17237.302.camel@auk75.llnl.gov>
 <1335229017-10677-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335229017-10677-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 etc/ibdiag.conf     |    2 ++
 src/ibdiag_common.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
index 77f3ce9..2a2334f 100644
--- a/etc/ibdiag.conf
+++ b/etc/ibdiag.conf
@@ -15,3 +15,5 @@
 # Default = true
 #MLX_EPI=false
 
+# define a default m_key
+#m_key=0x00
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 2288ab3..5aa43e8 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -155,6 +155,8 @@ void read_ibdiag_config(const char *file)
 			} else {
 				ibd_ibnetdisc_flags &= ~IBND_CONFIG_MLX_EPI;
 			}
+		} else if (strncmp(name, "m_key", strlen("m_key")) == 0) {
+			ibd_mkey = strtoull(val_str, 0, 0);
 		}
 	}
 
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
