From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] libibmad/resolve: add include to pick up inet_pton
Date: Wed, 30 Sep 2009 16:22:26 -0700
Message-ID: <B3D9536B45F044569239C2EF308D6BBD@amr.corp.intel.com>
References: <B5538B5C830E456484477BD3BAFA430B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B5538B5C830E456484477BD3BAFA430B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Windows needs to specifically pull in inet_pton from inet.h.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 libibmad/src/resolve.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/libibmad/src/resolve.c b/libibmad/src/resolve.c
index 9438fc1..3e07e8a 100644
--- a/libibmad/src/resolve.c
+++ b/libibmad/src/resolve.c
@@ -39,6 +39,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <arpa/inet.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
