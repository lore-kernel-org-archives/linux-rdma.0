From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: Add sysconfdir to spec for config files
Date: Tue, 12 Jul 2011 14:42:31 -0700
Message-ID: <20110712144231.2dbcbb91.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



commit cbe10407a14e57c8febe6e039ae617737f0b6e0f added a configuration file
directory in sysconfdir.  I missed this in the spec file.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags.spec.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index b557db7..bcdd250 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -54,6 +54,7 @@ rm -rf $RPM_BUILD_ROOT
 %{_perldir}/*
 %{_mandir}/man8/*
 %{_mandir}/man3/*
+%{_sysconfdir}/*
 %doc README COPYING ChangeLog
 
 %changelog
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
