From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 7/8] opensm: Check for valid mkey protection level in config file
Date: Mon, 25 Jun 2012 17:55:03 -0700
Message-ID: <1340672104-18039-7-git-send-email-foraker1@llnl.gov>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
 <1340672104-18039-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340672104-18039-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_subnet.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index bb69a66..ddee955 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1496,6 +1496,13 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 	}
 #endif
 
+	if (p_opts->m_key_protect_bits > 3) {
+		log_report(" Invalid Cached Option Value:"
+		           "m_key_protection_level = %u Setting to %u "
+			   "instead\n", p_opts->m_key_protect_bits, 2);
+		p_opts->m_key_protect_bits = 2;
+	}
+
 	if (p_opts->root_guid_file != NULL) {
 		FILE *root_file = fopen(p_opts->root_guid_file, "r");
 		if (!root_file) {
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
