From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libdat v2.0: memory leak in static registration during
 parsing
Date: Mon, 6 Dec 2010 16:22:50 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011E66B8E8@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "King, Perry E." <perry.king-itBhTGHPdi0@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

the platform_params char string, allocated when parsing dat.conf, is not freed.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dat/udat/udat_sr_parser.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/dat/udat/udat_sr_parser.c b/dat/udat/udat_sr_parser.c
index 3b5caef..1d5f0d8 100644
--- a/dat/udat/udat_sr_parser.c
+++ b/dat/udat/udat_sr_parser.c
@@ -492,6 +492,12 @@ DAT_RETURN dat_sr_parse_entry(DAT_OS_FILE * file)
 					    1));
 	}
 
+	if (NULL != entry.platform_params) {
+		dat_os_free(entry.platform_params,
+			    sizeof(char) *
+			    (dat_os_strlen(entry.platform_params) +  1));
+	}
+
 	return status;
 }
 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
