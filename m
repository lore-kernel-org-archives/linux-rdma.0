From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 2/6] redhat/spec: improve base package description
Date: Wed, 21 Dec 2016 17:08:36 -0500
Message-ID: <20161221220840.36268-3-jarod@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It was a bit lacking, add some meat to it.

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 82cd149..f9ebad1 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -20,6 +20,7 @@ BuildRequires: pkgconfig(libnl-3.0)
 BuildRequires: pkgconfig(libnl-route-3.0)
 BuildRequires: valgrind-devel
 
+Requires: dracut
 # Red Hat/Fedora previously shipped redhat/ as a stand-alone
 # package called 'rdma', which we're supplanting here.
 Provides: rdma = %{version}-%{release}
@@ -41,7 +42,9 @@ BuildRequires: make
 %endif
 
 %description
-RDMA core userspace infrastructure and documentation.
+RDMA core userspace infrastructure and documentation, including initscripts,
+kernel driver-specific modprobe override configs, IPoIB network scripts,
+dracut rules, and the rdma-ndd utility.
 
 %package devel
 Summary: RDMA core development libraries and headers
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
