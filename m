From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bug Report: possible circular locking issue
Date: Mon, 28 Aug 2017 15:28:02 -0400
Message-ID: <1503948482.78641.110.camel@redhat.com>
References: <1503938316.78641.98.camel@redhat.com>
         <1503947529.78641.108.camel@redhat.com>
         <156f01d32032$7cbcadb0$76360910$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <156f01d32032$7cbcadb0$76360910$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-08-28 at 14:18 -0500, Steve Wise wrote:
> > On Mon, 2017-08-28 at 12:38 -0400, Doug Ledford wrote:
> > > Resend from my work email address:
> > > 
> > > 
> > > I ran across this while testing a 4.13-rc7 kernel + the rdma next
> > > code.
> > 
> > This reproduces on a stock 4.13-rc7 kernel.  But, across all the
> > stuff
> > I've booted it on so far, it only shows up on cxgb4 devices, so I
> > think
> > this is a cxgb4 specific issue.  Steve, can you look into this?
> 
> Hey Doug.  Yes.   Is this a regression that shows up now in 4.13-rc
> but worked in older kernels?

I think so.  But I don't update this particular machine every release
(mainly because it's a contested machine with a unique setup, and the
last couple kernel releases it's been tied up with rhel testing instead
of my own, but prior to the last couple kernels I don't recall this
issue existing).

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
