From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: fixing bug in dumping options file
Date: Thu, 19 Nov 2009 13:54:43 +0200
Message-ID: <4B053203.206@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding missing pound sign to the printed
comments in the OSM options file.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_subnet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 2cfcbe6..29bb94b 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -1471,7 +1471,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"max_wire_smps %u\n\n"
 		"# The maximum time in [msec] allowed for a transaction to complete\n"
 		"transaction_timeout %u\n\n"
-		" The maximum number of retries allowed for a transaction to complete\n"
+		"# The maximum number of retries allowed for a transaction to complete\n"
 		"transaction_retries %u\n\n"
 		"# Maximal time in [msec] a message can stay in the incoming message queue.\n"
 		"# If there is more than one message in the queue and the last message\n"
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
