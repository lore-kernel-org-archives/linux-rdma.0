From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-3.2 v1 5/5]libibverbs: Add support for extended speeds
Date: Mon, 3 Oct 2011 18:56:25 +0300
Message-ID: <201110031756.26116.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


8:  FDR-10 is a proprietary link speed which is 10.3125 Gbps at 64/66
    encoding rather than 8b10b encoding.
16: FDR - 14.0625 Gbps
32: EDR - 25.78125 Gbps

Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index 84f95c7..a1e40d2 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -139,7 +139,12 @@ static const char *speed_str(uint8_t speed)
 	switch (speed) {
 	case 1:  return "2.5 Gbps";
 	case 2:  return "5.0 Gbps";
-	case 4:  return "10.0 Gbps";
+
+	case 4:  /* fall through */
+	case 8:  return "10.0 Gbps";
+
+	case 16: return "14.0 Gbps";
+	case 32: return "25.0 Gbps";
 	default: return "invalid speed";
 	}
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
