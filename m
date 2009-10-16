From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/11] dat: reduce debug message level when parsing for
 location of dat.conf
Date: Fri, 16 Oct 2009 16:48:46 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CB8@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Don't output failover to default /etc/dat.conf from
sysconfdir at ERROR level. Reduce to DAT_OS_DBG_TYPE_SR.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dat/udat/udat_sr_parser.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/dat/udat/udat_sr_parser.c b/dat/udat/udat_sr_parser.c
index 126fb9f..3b5caef 100644
--- a/dat/udat/udat_sr_parser.c
+++ b/dat/udat/udat_sr_parser.c
@@ -239,7 +239,7 @@ DAT_RETURN dat_sr_load(void)
 		sr_file = dat_os_fopen(sr_path);
 		if (sr_file == NULL) {
 #ifdef DAT_CONF
-			dat_os_dbg_print(DAT_OS_DBG_TYPE_ERROR,
+			dat_os_dbg_print(DAT_OS_DBG_TYPE_SR,
 					 "DAT Registry: sysconfdir, "
 					 "bad filename - %s, retry default at %s\n",
 					 sr_path, DAT_SR_CONF_DEFAULT);
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
