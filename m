From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-4.1 10/11] RDMA/ocrdma: Prevent returning failures in
 the resource destroy path
Date: Tue, 19 May 2015 12:22:32 -0600
Message-ID: <20150519182232.GE18675@obsidianresearch.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
 <1431762709-20740-11-git-send-email-selvin.xavier@avagotech.com>
 <1431705372.29187.6.camel@redhat.com>
 <d4f35e4f79dbe5ee4e75f5cfafafcb41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d4f35e4f79dbe5ee4e75f5cfafafcb41-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 18, 2015 at 05:16:14PM +0530, Selvin Xavier wrote:

> The driver is returning success for other destroy routines also and
> free the corresponding driver resources.  As part of the changes
> suggested by you, we will change all the destroy routines to return
> error status for all the FW command failures and avoid freeing the
> driver resources in case of failure.  Since this change need more
> testing, I will drop this patch from the series for 4.1 RC.  I will
> cut a patch for 4.2 after our testing.

Didn't we discuss this already? Destroy routines cannot fail.

If the card's firmware fails during destroy then that is an
unrecoverable error and your driver and firmware are no longer
synchronized. Panic the kernel or do some kind of (synchronous)
card-reset recovery.

Don't expect the caller to handle this, and don't leak IB core memory
when it happens.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
