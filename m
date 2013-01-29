From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/configure.in: Remove Default-Start from opensmd init
 script
Date: Tue, 29 Jan 2013 19:18:50 +0200
Message-ID: <20130129171850.GB2961@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During opensm RPM packaging, `chkconfig --add opensmd` is called.
`chkconfig --add` creates the appropriate entry as specified by the
default values in the init script. Having opensmd run by default on boot
isn't desired.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 configure.in | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index 4515ae2..f798be2 100644
--- a/configure.in
+++ b/configure.in
@@ -18,12 +18,13 @@ AC_ARG_WITH([rdma_service],
 AC_SUBST(RDMA_SERVICE, ${with_rdma_service:-${default_rdma_service}})
 
 if { rpm -q sles-release || rpm -q openSUSE-release; } >/dev/null 2>&1; then
-   default_start="2 3 5"
    default_stop="0 1 4 6"
 else
-   default_start="2 3 4 5"
    default_stop="0 1 6"
 fi
+
+default_start="null"
+
 AC_SUBST(DEFAULT_START, $default_start)
 AC_SUBST(DEFAULT_STOP, $default_stop)
 
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
