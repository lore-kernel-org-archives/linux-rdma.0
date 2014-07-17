From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Thu, 17 Jul 2014 10:01:26 -0500
Message-ID: <53C7E546.3080008@opengridcomputing.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e39e90f-7095-4eb9-a844-516672a355ad-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 7/17/2014 9:01 AM, Devesh Sharma wrote:
> If verndor driver is attempted for removal while xprtrdma still has an
> active mount, the removal of driver may never complete and can cause
> unseen races or in worst case system crash.
>
> To solve this, xprtrdma module should get reference of struct ib_device
> structure for every mount. Reference is taken after local device address
> resolution is completed successfuly.
>
> reference to the struct ib_device pointer is put just before cm_id destruction.
>
> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

This seems like an issue with the rdma-cm or rdma core, not xprtrdma.  I 
see that user rdma applications cause a ref on the provider module here 
in ib_uverbs_open():

         if (!try_module_get(dev->ib_dev->owner)) {
                 ret = -ENODEV;
                 goto err;


Maybe kernel applications that allocate device resources should cause a 
ref on the provider's module.

Sean/Roland,  is there some history here as to how rdma provider module 
removal should be handled?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
