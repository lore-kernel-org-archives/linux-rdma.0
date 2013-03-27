From: Husam Kahalah <husamkahalah-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH] switchinfo support added manual
Date: Wed, 27 Mar 2013 15:11:14 +0200
Message-ID: <5152EFF2.4080309@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 From 5c21f13092977fb45180e54a9eefcb081afa1684 Mon Sep 17 00:00:00 2001
From: Husam Kahalah <hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Date: Sun, 3 Mar 2013 09:40:42 +0200
Subject: [PATCH] switchinfo support added manual

---
  doc/rst/saquery.8.in.rst |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/rst/saquery.8.in.rst b/doc/rst/saquery.8.in.rst
index 1a11965..2c71adf 100644
--- a/doc/rst/saquery.8.in.rst
+++ b/doc/rst/saquery.8.in.rst
@@ -152,7 +152,7 @@ Supported query names (and aliases):
          LFTRecord (LFTR) [[lid]/[block]]
          MFTRecord (MFTR) [[mlid]/[position]/[block]]
          GUIDInfoRecord (GIR) [[lid]/[block]]
-
+    SwitchInfoRecord (SWIR) [lid]


  Port Selection flags
-- 
1.7.9.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
