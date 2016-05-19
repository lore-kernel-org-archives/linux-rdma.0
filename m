From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: small conflict between rdma-next and net-next
Date: Thu, 19 May 2016 19:04:08 +0300
Message-ID: <CAJ3xEMh7XB-1ugxWkWkOLkSPkPM5eYoMm99Csxn2y70xoMSFUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug (resending, due to some mailer problem, probably on my end)

We've identified a small conflict between net-next commit

43a335e "net/mlx5_core: Flow counters infrastructure"

and rdma-next (your k.o/for-4.7 branch) commit

94c6825e "net/mlx5_core: Use tasklet for user-space CQ completion events"

see below the exact conflict and a possible resolution. If you want,
you can add tiny commit in your tree that would cause the rdma-next
patch to be merged smoothly by Linus.

Alternatively, as done other subsystem maintainers after doing
pre-merge tests before sending their pull requests, I guess you can
add a note to Linus to your pull email, can even put there the
resolution. The net-next patch is upstream by now so you would see
this conflict if you do a merge test.

I assume you have put your for-next bits to a branch where linux-next
merge tests would also catch that.

We did a great effort here towards the 4.7 merge window to minimize
the conflicts between rdma and net-next commits. I believe that such a
small conflict is something that happens when you have a driver which
is patched through two subsystems.

Or.

Conflict:

------------------------------------------------------------

diff --cc include/linux/mlx5/driver.h
index 07b504f7eb84,816fe005ca5e..000000000000
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@@ -41,7 -41,7 +41,11 @@@
  #include <linux/slab.h>
  #include <linux/vmalloc.h>
  #include <linux/radix-tree.h>
++<<<<<<< HEAD
+#include <linux/workqueue.h>
++=======
+ #include <linux/interrupt.h>
++>>>>>>> origin/ib-next-mlx

  #include <linux/mlx5/device.h>
  #include <linux/mlx5/doorbell.h>


Solution:
------------------------------------------------------------

include/linux/mlx5/driver.h

@@@ -41,7 -41,7 +41,11 @@@
  #include <linux/slab.h>
  #include <linux/vmalloc.h>
  #include <linux/radix-tree.h>
+ #include <linux/workqueue.h>
+ #include <linux/interrupt.h>

   #include <linux/mlx5/device.h>
  #include <linux/mlx5/doorbell.h>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
