From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Tue, 14 Apr 2015 10:18:07 -0400
Message-ID: <20150414141806.GA7354@phlsvsds.ph.intel.com>
References: <552BB470.4090407@profitbricks.com> <552BB5AC.6050101@profitbricks.com> <20150413192701.GA19112@obsidianresearch.com> <20150413194602.GA21467@phlsvsds.ph.intel.com> <20150413200138.GC19112@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150413200138.GC19112-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 02:01:38PM -0600, Jason Gunthorpe wrote:
> On Mon, Apr 13, 2015 at 03:46:03PM -0400, ira.weiny wrote:
> 
> > > This doesn't quite look right, it should be 'goto error1'
> > 
> > Looks like you replied to the wrong patch.  ??  I don't see error1 in ipoib_add_one.
> 
> > For the ib_cm module...
> 
> Right, sorry.
>  
> > Yes I think it should go to "error1".  However, see below...
> > 
> > This is the type of clean up error which would be avoided if a call to
> > cap_ib_cm_dev() were done at the top of the function.
> 
> So what does cap_ib_cm_dev return in your example:

I was thinking it was all or nothing.  But I see now that the cap_ib_cm_dev is
actually true if "any" port supports the CM.

> > Dev
> > 	port 1 : cap_is_cm == true
> > 	port 2 : cap_is_cm == false
> > 	port 3 : cap_is_cm == true
> 
> True? Then the code is still broken, having cap_ib_cm_dev doesn't help
> anything.

I see that now.

> 
> If we make it possible to be per port then it has to be fixed.

Yes

> 
> If you want to argue the above example is illegal and port 2 has to be
> on a different device, I'd be interested to see what that looks like.

I think the easiest fix for this series is to add this to the final CM code
(applies after the end of the series compile tested only):

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 63418ee..0d0fc24 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3761,7 +3761,11 @@ static void cm_add_one(struct ib_device *ib_device)
        unsigned long flags;
        int ret;
        u8 i;
-       int count = 0;
+
+       for (i = 1; i <= ib_device->phys_port_cnt; i++) {
+               if (!cap_ib_cm(ib_device, i))
+                       return;
+       }
 
        cm_dev = kzalloc(sizeof(*cm_dev) + sizeof(*port) *
                         ib_device->phys_port_cnt, GFP_KERNEL);
@@ -3810,14 +3814,6 @@ static void cm_add_one(struct ib_device *ib_device)
                ret = ib_modify_port(ib_device, i, 0, &port_modify);
                if (ret)
                        goto error3;
-
-               count++;
-       }
-
-       if (!count) {
-               device_unregister(cm_dev->device);
-               kfree(cm_dev);
-               return;
	}
 
        ib_set_client_data(ib_device, &cm_client, cm_dev);


> 
> Thinking about it some more, cap_foo_dev only makes sense if all ports
> are either true or false. Mixed is a BUG.

Agree

After more thought and reading other opinions, I must agree we should not
have cap_foo_dev.

For the CM case which has some need to support itself device device wide what
about this patch (compile tested only):


10:03:57 > git di
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 4b083f5..7347445 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1639,7 +1639,7 @@ static void cma_listen_on_dev(struct rdma_id_private
*id_priv,
        struct rdma_cm_id *id;
        int ret;
 
-       if (cma_family(id_priv) == AF_IB && !cap_ib_cm_dev(cma_dev->device))
+       if (cma_family(id_priv) == AF_IB && !cap_ib_cm_any_port(cma_dev->device))
                return;
 
        id = rdma_create_id(cma_listen_handler, id_priv, id_priv->id.ps,
@@ -2030,7 +2030,7 @@ static int cma_bind_loopback(struct rdma_id_private
*id_priv)
        mutex_lock(&lock);
        list_for_each_entry(cur_dev, &dev_list, list) {
                if (cma_family(id_priv) == AF_IB &&
-                   !cap_ib_cm_dev(cur_dev->device))
+                   !cap_ib_cm_any_port(cur_dev->device))
                        continue;
 
                if (!cma_dev)
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 065405e..dc4caae 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1253,7 +1253,7 @@ static void ib_ucm_add_one(struct ib_device *device)
        dev_t base;
        struct ib_ucm_device *ucm_dev;
 
-       if (!device->alloc_ucontext || !cap_ib_cm_dev(device))
+       if (!device->alloc_ucontext || !cap_ib_cm_any_port(device))
                return;
 
        ucm_dev = kzalloc(sizeof *ucm_dev, GFP_KERNEL);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 3cc3f53..a8fa1f5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1920,15 +1920,14 @@ static inline int cap_read_multi_sge(struct ib_device
*device, u8 port_num)
 }
 
 /**
- * cap_ib_cm_dev - Check if any port of device has the capability Infiniband
- * Communication Manager.
+ * cap_ib_cm_any_port - Check if any port of the device has Infiniband
+ * Communication Manager (CM) support.
  *
  * @device: Device to be checked
  *
- * Return 0 when all port of the device don't support Infiniband
- * Communication Manager.
+ * Return 1 if any port of the device supports the IB CM.
  */
-static inline int cap_ib_cm_dev(struct ib_device *device)
+static inline int cap_ib_cm_any_port(struct ib_device *device)
 {
        int i;
 

> 
> That seems reasonable, and solves the #10 problem, but we should
> enforce this invariant during device register.
> 
> Typically the ports seem to be completely orthogonal (like SA), so in those
> cases the _dev and restriction makes no sense.

While the ports in ib_sa and ib_umad probably can be orthogonal the current
implementation does not support that and this patch series obscures that a bit.

> 
> CM seems to be different, so it should probably enforce its rules

Technically, the implementation of the ib_sa and ib_umad modules are not
different it is just that Michaels patch is not broken.

I'm not saying we can't change the ib_sa and ib_umad modules but the current
logic is all or nothing.  And I think changing this :

	1) require more review and testing
	2) is not the purpose of this series.

Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
