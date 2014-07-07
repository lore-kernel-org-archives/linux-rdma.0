From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] opensm.init.in: Fix return value checking in opensm.init
 script
Date: Mon, 07 Jul 2014 06:07:03 -0400
Message-ID: <53BA7147.8030605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix return value checks when calling stop and start functions

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 scripts/opensm.init.in |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
index d2d1a71..700a32b 100644
--- a/scripts/opensm.init.in
+++ b/scripts/opensm.init.in
@@ -80,6 +80,7 @@ start () {
     fi
     echo -n "Starting opensm: "
     @sbindir@/opensm --daemon --pidfile $pidfile $OPTIONS > /dev/null
+    RETVAL=$?
     if [[ $RETVAL -eq 0 ]]; then
         success
     else
@@ -91,6 +92,7 @@ start () {
 stop () {
     echo -n "Shutting down opensm: "
     killproc opensm
+    RETVAL=$?
     if [[ $RETVAL -eq 0 ]]; then
         success
     else
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
