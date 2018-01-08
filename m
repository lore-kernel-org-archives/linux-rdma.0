From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v3 1/5] kobject: Export kobj_ns_grab_current() and kobj_ns_drop()
Date: Mon,  8 Jan 2018 15:14:32 -0800
Message-ID: <20180108231436.19750-2-bart.vanassche@wdc.com>
References: <20180108231436.19750-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108231436.19750-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make it possible to call these two functions from a kernel module.
Note: despite their name, these two functions can be used meaningfully
independent of kobjects. A later patch will add calls to these
functions from the SRP driver because this patch series modifies the
SRP driver such that it can hold a reference to a namespace that can
last longer than the lifetime of the process through which the
namespace reference was obtained.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
 lib/kobject.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/kobject.c b/lib/kobject.c
index 763d70a18941..06b849eee0ca 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -1039,6 +1039,7 @@ void *kobj_ns_grab_current(enum kobj_ns_type type)
 
 	return ns;
 }
+EXPORT_SYMBOL_GPL(kobj_ns_grab_current);
 
 const void *kobj_ns_netlink(enum kobj_ns_type type, struct sock *sk)
 {
@@ -1074,3 +1075,4 @@ void kobj_ns_drop(enum kobj_ns_type type, void *ns)
 		kobj_ns_ops_tbl[type]->drop_ns(ns);
 	spin_unlock(&kobj_ns_type_lock);
 }
+EXPORT_SYMBOL_GPL(kobj_ns_drop);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
