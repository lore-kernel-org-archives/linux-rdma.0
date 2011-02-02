From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Control number of retries for SA to
 leave an MCG
Date: Wed, 2 Feb 2011 09:38:18 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A20A5E98F@MNEXMB1.qlogic.org>
References: <4D4973B2.9070300@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4D4973B2.9070300-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Vlad <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org" <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Wouldn't the BUSY patch I proposed last year deal with this situation?

-----Original Message-----
From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org [mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Moni Shoua
Sent: Wednesday, February 02, 2011 10:10 AM
To: Vlad
Cc: nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org; ewg
Subject: [ewg] [PATCH] IB/core: Control number of retries for SA to leave an MCG

This patch helps when SM is busy and so an MC group is left joined
while the host bellies that it is was left.

Note: the patch below is not to driver/infiniband/core but it generates
a patch under kernel_patches/fixes.

Index: ofa_kernel-1.5.3/kernel_patches/fixes/core_0290_sysfs_mcast_leave_retries.patch
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ ofa_kernel-1.5.3/kernel_patches/fixes/core_0290_sysfs_mcast_leave_retries.patch     2011-02-02 16:52:02.000000000 +0200
@@ -0,0 +1,46 @@
+Add a multicast leave maximum retry setting in sys/module/ib_sa/parameters/mcast_leave_retries.
+Add a debug print when the maximum retry count is reached.
+
+Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
+Reviewed-by:   Moni Shoua  <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
+--
+
+Index: ofa_kernel-1.5.2/drivers/infiniband/core/multicast.c
+===================================================================
+--- ofa_kernel-1.5.2.orig/drivers/infiniband/core/multicast.c  2010-08-17 12:56:06.000000000 +0300
++++ ofa_kernel-1.5.2/drivers/infiniband/core/multicast.c       2010-08-17 13:15:38.000000000 +0300
+@@ -40,6 +40,12 @@
+ #include <rdma/ib_cache.h>
+ #include "sa.h"
+
++static int mcast_leave_retries = 3;
++
++module_param_call(mcast_leave_retries, param_set_int, param_get_int,
++                &mcast_leave_retries, 0644);
++MODULE_PARM_DESC(mcast_leave_retries, "Number of retries for multicast leave requests before giving up");
++
+ static void mcast_add_one(struct ib_device *device);
+ static void mcast_remove_one(struct ib_device *device);
+
+@@ -520,8 +526,11 @@
+       if (status && (group->retries > 0) &&
+           !send_leave(group, group->leave_state))
+               group->retries--;
+-      else
++      else {
++              if (status && group->retries <= 0)
++                      printk("reached max retry count. status=%d  .Giving up\n", status);
+               mcast_work_handler(&group->work);
++      }
+ }
+
+ static struct mcast_group *acquire_group(struct mcast_port *port,
+@@ -544,7 +553,7 @@
+       if (!group)
+               return NULL;
+
+-      group->retries = 3;
++      group->retries = mcast_leave_retries;
+       group->port = port;
+       group->rec.mgid = *mgid;
+       group->pkey_index = MCAST_INVALID_PKEY_INDEX;
_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
