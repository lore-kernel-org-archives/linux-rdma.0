From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/6] Fix package building on CentOS6
Date: Wed, 23 Nov 2016 16:35:02 -0700
Message-ID: <1479944104-19949-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1479944104-19949-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479944104-19949-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The old rpmbuild does not define _udevrulesdir.

Fixes: 4910f1eb752e ("rdma-ndd: add rdma-ndd from infiniband-diags")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 rdma-core.spec | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rdma-core.spec b/rdma-core.spec
index 2c595a1da07d02..8c0b50da7645ee 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -77,6 +77,13 @@ This is a simple example without the split sub packages to get things started.
 %define _rundir /var/run
 %endif
 
+# New RPM defines _udevrulesdir, usually as /usr/lib/udev/rules.d
+%if 0%{?_udevrulesdir:1}
+%else
+# This is the old path (eg for C6)
+%define _udevrulesdir /lib/udev/rules.d
+%endif
+
 # Pass all of the rpm paths directly to GNUInstallDirs and our other defines.
 %cmake %{CMAKE_FLAGS} \
          -DCMAKE_BUILD_TYPE=Release \
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
