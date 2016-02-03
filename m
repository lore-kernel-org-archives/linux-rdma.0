From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 41/54] staging/rdma/hfi1: Fix snoop packet length calculation
Date: Wed, 03 Feb 2016 14:36:22 -0800
Message-ID: <20160203223619.5923.61513.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The LRH has a 12 bit packet length field, not 11 bit. This caused a
snoop packet length miscalculation leading to a crash when sending a
large ping over IPoIB while running opapacketcapture.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index d9889d4..fafb3d7 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -85,10 +85,9 @@ static u8 snoop_flags;
 
 /*
  * Extract packet length from LRH header.
- * Why & 0x7FF? Because len is only 11 bits in case it wasn't 0'd we throw the
- * bogus bits away. This is in Dwords so multiply by 4 to get size in bytes
+ * This is in Dwords so multiply by 4 to get size in bytes
  */
-#define HFI1_GET_PKT_LEN(x)      (((be16_to_cpu((x)->lrh[2]) & 0x7FF)) << 2)
+#define HFI1_GET_PKT_LEN(x)      (((be16_to_cpu((x)->lrh[2]) & 0xFFF)) << 2)
 
 enum hfi1_filter_status {
 	HFI1_FILTER_HIT,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
