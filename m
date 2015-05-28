From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: RE: [PATCH for-4.1 10/11] RDMA/ocrdma: Prevent returning failures in
 the resource destroy path
Date: Thu, 28 May 2015 09:28:32 +0530
Message-ID: <3e5657a791335daf90e61efb44dd25ab@mail.gmail.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
 <1431762709-20740-11-git-send-email-selvin.xavier@avagotech.com>
 <1431705372.29187.6.camel@redhat.com> <d4f35e4f79dbe5ee4e75f5cfafafcb41@mail.gmail.com>
 <20150519182232.GE18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519182232.GE18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jason
 My reply is delayed since  I was on vacation.

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, May 19, 2015 11:53 PM
> To: Selvin Xavier
> Cc: Doug Ledford; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH for-4.1 10/11] RDMA/ocrdma: Prevent returning
failures
> in the resource destroy path
>
> On Mon, May 18, 2015 at 05:16:14PM +0530, Selvin Xavier wrote:
>
> > The driver is returning success for other destroy routines also and
> > free the corresponding driver resources.  As part of the changes
> > suggested by you, we will change all the destroy routines to return
> > error status for all the FW command failures and avoid freeing the
> > driver resources in case of failure.  Since this change need more
> > testing, I will drop this patch from the series for 4.1 RC.  I will
> > cut a patch for 4.2 after our testing.
>
> Didn't we discuss this already? Destroy routines cannot fail.
>
> If the card's firmware fails during destroy then that is an
unrecoverable error
> and your driver and firmware are no longer synchronized. Panic the
kernel or
> do some kind of (synchronous) card-reset recovery.
>
> Don't expect the caller to handle this, and don't leak IB core memory
when it
> happens.
>
Got it .   Will do the same in all destroy APIs.

> Jason
Thanks,
Selvin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
