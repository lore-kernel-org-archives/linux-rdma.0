From: Dotan Barak <dotan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibverbs: Fix the date format in the 'changelog' section of the spec file
Date: Wed, 15 Jun 2011 09:12:08 +0300
Message-ID: <201106150912.08574.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix the date format in the 'changelog' section of the spec file.

Signed-off-by: Dotan Barak <dotan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---

 libibverbs.spec.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libibverbs.spec.in b/libibverbs.spec.in
index e0a7ae6..0ff27ce 100644
--- a/libibverbs.spec.in
+++ b/libibverbs.spec.in
@@ -85,7 +85,7 @@ rm -rf $RPM_BUILD_ROOT
 %{_mandir}/man1/*
 
 %changelog
-* Thu Jun 3 Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> - 1.1.4-1
+* Thu Jun 3 2010 Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> - 1.1.4-1
 - New upstream release
 
 * Thu Oct 29 2009 Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> - 1.1.3-1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
