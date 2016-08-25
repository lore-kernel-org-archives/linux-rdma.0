From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Receive notification events correctly
Date: Thu, 25 Aug 2016 11:53:24 -0500
Message-ID: <1472144004-66528-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Device notifications are not received after the first interface is
closed; since there is an unregister for notifications on every
interface close. Correct this by unregistering for device
notifications only when the last interface is closed. Also, make
all operations on the i40iw_notifiers_registered atomic as it
can be read/modified concurrently.

Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index c963cad..bb98801 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -100,7 +100,7 @@ static struct notifier_block i40iw_net_notifier = {
 	.notifier_call = i40iw_net_event
 };
 
-static int i40iw_notifiers_registered;
+static atomic_t i40iw_notifiers_registered;
 
 /**
  * i40iw_find_i40e_handler - find a handler given a client info
@@ -1343,12 +1343,11 @@ exit:
  */
 static void i40iw_register_notifiers(void)
 {
-	if (!i40iw_notifiers_registered) {
+	if (atomic_inc_return(&i40iw_notifiers_registered) == 1) {
 		register_inetaddr_notifier(&i40iw_inetaddr_notifier);
 		register_inet6addr_notifier(&i40iw_inetaddr6_notifier);
 		register_netevent_notifier(&i40iw_net_notifier);
 	}
-	i40iw_notifiers_registered++;
 }
 
 /**
@@ -1430,8 +1429,7 @@ static void i40iw_deinit_device(struct i40iw_device *iwdev, bool reset, bool del
 			i40iw_del_macip_entry(iwdev, (u8)iwdev->mac_ip_table_idx);
 		/* fallthrough */
 	case INET_NOTIFIER:
-		if (i40iw_notifiers_registered > 0) {
-			i40iw_notifiers_registered--;
+		if (!atomic_dec_return(&i40iw_notifiers_registered)) {
 			unregister_netevent_notifier(&i40iw_net_notifier);
 			unregister_inetaddr_notifier(&i40iw_inetaddr_notifier);
 			unregister_inet6addr_notifier(&i40iw_inetaddr6_notifier);
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
