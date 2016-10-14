From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 1/4] rpm spec: install documentation too
Date: Fri, 14 Oct 2016 15:21:33 -0400
Message-ID: <20161014192136.11731-2-jarod@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At least in the Red Hat world, we like to install the documentation files
provided in a given source tree.

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 rdma-core.spec | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/rdma-core.spec b/rdma-core.spec
index 96c86fe..609b910 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -91,6 +91,9 @@ This is a simple example without the split sub packages to get things started.
 %install
 %cmake_install
 
+mkdir -p %{buildroot}/%{_docdir}/%{name}-%{version}
+install -m0644 Documentation/{ibacm,ibsrpdm,libibcm,libibverbs,librdmacm,rxe}.md %{buildroot}/%{_docdir}/%{name}-%{version}/
+
 %if 0%{?_unitdir:1}
 rm -rf %{buildroot}/%{_initrddir}/
 %else
@@ -110,6 +113,7 @@ rm -rf %{buildroot}/%{my_unitdir}/
 %{_libdir}/rsocket/*
 %{_sbindir}/*
 %{_libexecdir}/*
+%{_docdir}/%{name}-%{version}/*
 %if 0%{?_unitdir:1}
 %{_unitdir}/*
 %else
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
