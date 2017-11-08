From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 1/4] suse: add a bcond to disable usage of curl-mini
Date: Wed, 8 Nov 2017 15:31:20 +0100
Message-ID: <2897ea63-deca-2304-f2ce-8a1a778d02d6@suse.de>
References: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 suse/rdma-core.spec | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index 03c4a296..4f3638f3 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -77,9 +77,21 @@ Obsoletes:      rdma < %{version}
 Provides:       ofed = %{version}
 Obsoletes:      ofed < %{version}
 
+# Trickery to handle both SUSE OpenBuild System and Manual build
+# In OBS, rdma-core must use curl-mini instead of curl to avoid
+# a build dependency loop:
+# rdma-core -> cmake -> curl -> ... -> boost -> rdma-core
+# Thus we force a BuildRequires to curl-mini which as no impact
+# as it is not used during the build.
+# However curl-mini is not a published RPM. This would prevent any build
+# outside of OBS. Thus we add a bcond to allow manual build.
+# To force build without the use of curl-mini, --without=curlmini
+# should be passed to rpmbuild
 %if 0%{?suse_version} >= 1330
+%if %{with curlmini}
 BuildRequires:  curl-mini
 %endif
+%endif
 
 # Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
 # which is totally inappropriate and breaks building 'ENABLE_EXPORTS' style
-- 
2.14.1.461.g503560879


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
