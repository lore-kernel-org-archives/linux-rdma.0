From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: remove -u common option
Date: Thu, 3 May 2012 09:14:51 -0700
Message-ID: <20120503091451.c764d06d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibdiag_common.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index a4e8cfa..2f12c46 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -209,7 +209,6 @@ static int process_opt(int ch, char *optarg)
 		read_ibdiag_config(optarg);
 		break;
 	case 'h':
-	case 'u':
 		ibdiag_show_usage();
 		break;
 	case 'V':
@@ -280,7 +279,6 @@ static const struct ibdiag_opt common_opts[] = {
 	{"errors", 'e', 0, NULL, "show send and receive errors"},
 	{"verbose", 'v', 0, NULL, "increase verbosity level"},
 	{"debug", 'd', 0, NULL, "raise debug level"},
-	{"usage", 'u', 0, NULL, "usage message"},
 	{"help", 'h', 0, NULL, "help message"},
 	{"version", 'V', 0, NULL, "show version"},
 	{0}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
