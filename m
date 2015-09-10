From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] saquery.c: Fix saquery -D option
Date: Thu, 10 Sep 2015 09:09:57 -0400
Message-ID: <55F18125.2090406@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 9 Sep 2015 14:29:38 +0300

-D and -list saquery options are operational only
when -N option is explicitly invoked (default option)

This patch allows using -D or --list options when no other option is
invoked.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/saquery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 4343e33..db863f2 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1591,6 +1591,7 @@ static int process_opt(void *context, int ch, char *optarg)
 		break;
 	case 'D':
 		node_print_desc = ALL_DESC;
+		command = SAQUERY_CMD_NODE_RECORD;
 		break;
 	case 'c':
 		command = SAQUERY_CMD_CLASS_PORT_INFO;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
