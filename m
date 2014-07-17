From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Thu, 17 Jul 2014 16:06:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com>
 <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com>
 <53C7E546.3080008@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53C7E546.3080008-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 7/17/2014 9:01 AM, Devesh Sharma wrote:
> > If verndor driver is attempted for removal while xprtrdma still has an
> > active mount, the removal of driver may never complete and can cause
> > unseen races or in worst case system crash.
> >
> > To solve this, xprtrdma module should get reference of struct ib_device
> > structure for every mount. Reference is taken after local device address
> > resolution is completed successfuly.
> >
> > reference to the struct ib_device pointer is put just before cm_id
> destruction.
> >
> > Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> 
> This seems like an issue with the rdma-cm or rdma core, not xprtrdma.  I
> see that user rdma applications cause a ref on the provider module here
> in ib_uverbs_open():
> 
>          if (!try_module_get(dev->ib_dev->owner)) {
>                  ret = -ENODEV;
>                  goto err;
> 
> 
> Maybe kernel applications that allocate device resources should cause a
> ref on the provider's module.
> 
> Sean/Roland,  is there some history here as to how rdma provider module
> removal should be handled?

The kernel modules should are not expected to access the rdma devices after their remove device callback has been invoked.  The rdma cm basically forwards the device removal on a per id basis.  Apps are expected to destroy the id after receiving that callback.  The rdma cm should block in the remove device call until all id's associated with the removed device have been destroyed.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
