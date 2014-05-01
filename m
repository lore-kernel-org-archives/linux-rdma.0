From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Thu, 1 May 2014 09:12:23 +0300
Message-ID: <5361E5C7.5030805@mellanox.com>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org> <53619638.48ae0e0a.2e40.ffffec09SMTPIN_ADDED_BROKEN@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53619638.48ae0e0a.2e40.ffffec09SMTPIN_ADDED_BROKEN-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 01/05/2014 02:28, Doug Ledford wrote:
> This seems like driving a thumb tack with a sledge hammer.  No doubt
> the correct path here is to get the proper flag added to verbs multicast
> attach command.  Or, do you still have a patch that does this the
> right way?  Did the one from 2008 do it the right way or this way?

Doug, as I commented earlier on this thread, the correct way here is to 
carry out the task is to repeat the QP creation flags which we have in 
the kernel verbs API for years (see 
IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK in ib_verbs.h and usage in IPoIB) 
for the user space verbs API. The patch I provided to Christophand CO 
was a band-aid to bring up a whole system on upstream and mlx4 where 
this (avoiding multicast loopback) was the only/major missing piece.

The patch posted back in 2008 is proper, but it added a whole new uverb 
call/structure, where I think we can get along here with just re-using a 
reserved field in the existing uverbs API, see my other post on this thread.

Or.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
