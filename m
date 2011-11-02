From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osmtest/osmtest.c: inventory file parsing bugfix
Date: Wed, 2 Nov 2011 14:35:19 +0200
Message-ID: <20111102123518.GA3118@UBU02>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Parsing of 'mkey' field from inventory file fails due to precedences.
Instead of parsing 'mkey' field, it parsed 'mkey_violations'.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/osmtest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 489e2201..37d574b 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -181,7 +181,6 @@ const osmtest_token_t token_array[] = {
 	{OSMTEST_TOKEN_RATE, 4, "RATE"},
 	{OSMTEST_TOKEN_PKT_LIFE, 8, "PKT_LIFE"},
 	{OSMTEST_TOKEN_PREFERENCE, 10, "PREFERENCE"},
-	{OSMTEST_TOKEN_MKEY, 4, "M_KEY"},
 	{OSMTEST_TOKEN_SUBN_PREF, 13, "SUBNET_PREFIX"},
 	{OSMTEST_TOKEN_BASE_LID, 8, "BASE_LID"},
 	{OSMTEST_TOKEN_SM_BASE_LID, 18, "MASTER_SM_BASE_LID"},
@@ -213,6 +212,7 @@ const osmtest_token_t token_array[] = {
 	{OSMTEST_TOKEN_SUBN_TIMEOUT, 14, "subnet_timeout"},
 	{OSMTEST_TOKEN_RESP_TIME_VAL, 15, "resp_time_value"},
 	{OSMTEST_TOKEN_ERR_THRESHOLD, 15, "error_threshold"},
+	{OSMTEST_TOKEN_MKEY, 4, "M_KEY"}, /* must be after the other mkey... tokens. */
 	{OSMTEST_TOKEN_MTU, 3, "MTU"},	/*  must be after the other mtu... tokens. */
 	{OSMTEST_TOKEN_FROMLID, 8, "from_lid"},
 	{OSMTEST_TOKEN_FROMPORTNUM, 13, "from_port_num"},
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
