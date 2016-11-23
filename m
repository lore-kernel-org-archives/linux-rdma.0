From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/6] Avoid rpmbuild warning
Date: Wed, 23 Nov 2016 16:35:03 -0700
Message-ID: <1479944104-19949-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1479944104-19949-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479944104-19949-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is already a catch all for this directory

warning: File listed twice: /usr/share/doc/packages/rdma-core-12/MAINTAINERS
warning: File listed twice: /usr/share/doc/packages/rdma-core-12/README.md

Fixes: 8df5873b969f ("Install end user focused documentation files")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 rdma-core.spec | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/rdma-core.spec b/rdma-core.spec
index 8c0b50da7645ee..bdb64c6bb80567 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -118,8 +118,6 @@ rm -rf %{buildroot}/%{my_unitdir}/
 
 %files
 %doc %{_mandir}/man*/*
-%doc %{_docdir}/%{name}-%{version}/README.md
-%doc %{_docdir}/%{name}-%{version}/MAINTAINERS
 %{_bindir}/*
 %{_includedir}/*
 %{_libdir}/lib*.so*
@@ -129,7 +127,7 @@ rm -rf %{buildroot}/%{my_unitdir}/
 %{_sbindir}/*
 %{_libexecdir}/*
 %{_udevrulesdir}/*
-%{_docdir}/%{name}-%{version}/*
+%doc %{_docdir}/%{name}-%{version}/*
 %if 0%{?_unitdir:1}
 %{_unitdir}/*
 %else
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
