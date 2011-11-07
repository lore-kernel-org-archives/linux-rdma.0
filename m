From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [trivial] [PATCH 1/3] Fix typo in qos-ulps parsing comment
Date: Mon, 07 Nov 2011 13:26:25 -0800
Message-ID: <1320701185.22519.108.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

"srp target-port-guid" is supported, not "srp port-guid"

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_qos_parser_y.y |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_qos_parser_y.y b/opensm/osm_qos_parser_y.y
index 8274280..348750d 100644
--- a/opensm/osm_qos_parser_y.y
+++ b/opensm/osm_qos_parser_y.y
@@ -624,7 +624,7 @@ qos_match_rule_entry: qos_match_rule_use
      *   sdp with port-num
      *   rds
      *   rds with port-num
-     *   srp with port-guid
+     *   srp with target-port-guid
      *   iser
      *   iser with port-num
      *   ipoib
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
