From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 11/21] debian: Remove infiniband-diags Depends from iwpmd
Date: Mon, 24 Jul 2017 14:00:19 -0600
Message-ID: <1500926429-31822-12-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This was a copy and paste error.

Fixes: bba93a9ce37 ("Debian Packaging")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/control | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/debian/control b/debian/control
index 34b275dfeb8c62..8434bbb23693f8 100644
--- a/debian/control
+++ b/debian/control
@@ -47,8 +47,7 @@ Description: InfiniBand Communication Manager Assistant (ACM)
 
 Package: iwpmd
 Architecture: linux-any
-Depends: infiniband-diags,
-         lsb-base (>= 3.2-14~),
+Depends: lsb-base (>= 3.2-14~),
          ${misc:Depends},
          ${shlibs:Depends}
 Description: Userspace component for iWarp RDMA services
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
