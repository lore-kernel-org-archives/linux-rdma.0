From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/3] debian: Bump Standards-Version to 4.1.0
Date: Mon, 11 Sep 2017 13:28:20 +0200
Message-ID: <20170911112821.2094-2-benjamin.drung@profitbricks.com>
References: <20170911112821.2094-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911112821.2094-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No changes are needed to support the new Debian policy version.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 5aa8abdd..f87f8999 100644
--- a/debian/control
+++ b/debian/control
@@ -16,7 +16,7 @@ Build-Depends: cmake (>= 2.8.11),
                pkg-config,
                python,
                valgrind
-Standards-Version: 4.0.0
+Standards-Version: 4.1.0
 Vcs-Git: https://github.com/linux-rdma/rdma-core.git
 Vcs-Browser: https://github.com/linux-rdma/rdma-core
 Homepage: https://github.com/linux-rdma/rdma-core
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
