From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: fixing some options to not
	"hot-swappable"
Date: Tue, 13 Apr 2010 13:40:35 +0300
Message-ID: <4BC44A23.8010509@dev.mellanox.co.il>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-Path: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
X-OriginalArrivalTime: 13 Apr 2010 10:40:45.0762 (UTC) FILETIME=[C6063A20:01CADAF5]

The following options are not hot-swappable:

  transaction_timeout
  transaction_retries
  use_ucast_cache

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_subnet.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 9132c82..3f5f0f3 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -299,8 +299,8 @@ static const opt_rec_t opt_tbl[] = {
 	{ "max_wire_smps", OPT_OFFSET(max_wire_smps), opts_parse_uint32, NULL, 1 },
 	{ "console", OPT_OFFSET(console), opts_parse_charp, NULL, 0 },
 	{ "console_port", OPT_OFFSET(console_port), opts_parse_uint16, NULL, 0 },
-	{ "transaction_timeout", OPT_OFFSET(transaction_timeout), opts_parse_uint32, NULL, 1 },
-	{ "transaction_retries", OPT_OFFSET(transaction_retries), opts_parse_uint32, NULL, 1 },
+	{ "transaction_timeout", OPT_OFFSET(transaction_timeout), opts_parse_uint32, NULL, 0 },
+	{ "transaction_retries", OPT_OFFSET(transaction_retries), opts_parse_uint32, NULL, 0 },
 	{ "max_msg_fifo_timeout", OPT_OFFSET(max_msg_fifo_timeout), opts_parse_uint32, NULL, 1 },
 	{ "sm_priority", OPT_OFFSET(sm_priority), opts_parse_uint8, opts_setup_sm_priority, 1 },
 	{ "lmc", OPT_OFFSET(lmc), opts_parse_uint8, NULL, 1 },
@@ -328,7 +328,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_parse_boolean, NULL, 1 },
 	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, NULL, 0 },
 	{ "connect_roots", OPT_OFFSET(connect_roots), opts_parse_boolean, NULL, 1 },
-	{ "use_ucast_cache", OPT_OFFSET(use_ucast_cache), opts_parse_boolean, NULL, 1 },
+	{ "use_ucast_cache", OPT_OFFSET(use_ucast_cache), opts_parse_boolean, NULL, 0 },
 	{ "log_file", OPT_OFFSET(log_file), opts_parse_charp, NULL, 0 },
 	{ "log_max_size", OPT_OFFSET(log_max_size), opts_parse_uint32, opts_setup_log_max_size, 1 },
 	{ "log_flags", OPT_OFFSET(log_flags), opts_parse_uint8, opts_setup_log_flags, 1 },
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
