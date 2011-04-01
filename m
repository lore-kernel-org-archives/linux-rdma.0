From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags.spec.in: Remove duplication of ibdiscover.pl
Date: Fri, 01 Apr 2011 14:38:50 -0400
Message-ID: <4D961BBA.7010306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index c50ce09..692ebd7 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -37,7 +37,6 @@ rm -rf $RPM_BUILD_ROOT

 %files
 %defattr(-,root,root)
-%{_sbindir}/ibdiscover.pl
 %{_sbindir}/ib*
 %{_sbindir}/perfquery
 %{_sbindir}/saquery
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
