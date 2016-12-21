From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 6/6] redhat/spec: make sure docdir is owned
Date: Wed, 21 Dec 2016 17:08:40 -0500
Message-ID: <20161221220840.36268-7-jarod@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 96a67a4..3bb16ed 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -309,6 +309,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 
 %files
 %dir %{_sysconfdir}/rdma
+%dir %{_docdir}/%{name}-%{version}
 %doc %{_docdir}/%{name}-%{version}/README.md
 %config(noreplace) %{_sysconfdir}/rdma/*
 %config(noreplace) %{_sysconfdir}/udev/rules.d/*
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
