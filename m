From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] redhat/spec: add back strict librdmacm Requires
Date: Mon,  7 Nov 2016 12:23:58 -0500
Message-ID: <20161107172358.46494-1-jarod@redhat.com>
References: <20161104004213.GA28485@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161104004213.GA28485-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Per discussion on list with Doug and Jason, add back the strict librdmacm
Requires so that librdmacm and librdmacm-utils are as tightly coupled as
possible.

CC: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
CC: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index f65a519..c3d8189 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -170,6 +170,7 @@ librdmacm provides a userspace RDMA Communication Managment API.
 
 %package -n librdmacm-utils
 Summary: Examples for the librdmacm library
+Requires: librdmacm%{?_isa} = %{version}-%{release}
 
 %description -n librdmacm-utils
 Example test programs for the librdmacm library.
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
