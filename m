From: Husam Kahalah <hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] switchinfo support added manual
Date: Sun, 31 Mar 2013 17:00:22 +0300
Message-ID: <51584176.30808@asaltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Husam kahalah < hkahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>

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
