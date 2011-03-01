From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ibsim: fix double slash in include the path
Date: Tue, 1 Mar 2011 08:48:53 +0200
Message-ID: <20110301064853.GG8537@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix INCS path not to contain double slash, as it cause to failure when
creating RPM package on RedHat 6.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 defs.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/defs.mk b/defs.mk
index 578d407..11256c0 100644
--- a/defs.mk
+++ b/defs.mk
@@ -20,7 +20,7 @@ ifdef IB_DEV_DIR
  LIBS:= \
   $(foreach l, mad umad, $(IB_DEV_DIR)/libib$(l)/.libs/libib$(l).so)
 else
- INCS:= -I$(dir $(libpath))/include
+ INCS:= -I$(dir $(libpath))include
  LIBS:= -L$(libpath) -libmad -libumad
 endif
 
-- 
1.6.4.2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
