From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: add package requires to spec file.
Date: Thu, 16 Jun 2011 11:10:22 -0700
Message-ID: <20110616111022.a0ce5557.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 1 Jun 2011 21:49:57 -0700
Subject: [PATCH] infiniband-diags: add package requires to spec file.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags.spec.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index 692ebd7..b557db7 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -12,6 +12,7 @@ BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
 Source: http://www.openfabrics.org/downloads/management/@TARBALL@
 Url: http://openfabrics.org/
 BuildRequires: libibmad-devel, opensm-devel, libibumad-devel
+Requires: libibmad, opensm-libs, libibumad
 Provides: perl(IBswcountlimits)
 Obsoletes: openib-diags
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
