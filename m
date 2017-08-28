From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Bug Report: possible circular locking issue
Date: Mon, 28 Aug 2017 14:44:07 -0500
Message-ID: <158601d32036$02e2b0d0$08a81270$@opengridcomputing.com>
References: <1503938316.78641.98.camel@redhat.com>         <1503947529.78641.108.camel@redhat.com>         <156f01d32032$7cbcadb0$76360910$@opengridcomputing.com> <1503948482.78641.110.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503948482.78641.110.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > > > I ran across this while testing a 4.13-rc7 kernel + the rdma next
> > > > code.
> > >
> > > This reproduces on a stock 4.13-rc7 kernel.  But, across all the
> > > stuff
> > > I've booted it on so far, it only shows up on cxgb4 devices, so I
> > > think
> > > this is a cxgb4 specific issue.  Steve, can you look into this?
> >
> > Hey Doug.  Yes.   Is this a regression that shows up now in 4.13-rc
> > but worked in older kernels?
> 
> I think so.  But I don't update this particular machine every release
> (mainly because it's a contested machine with a unique setup, and the
> last couple kernel releases it's been tied up with rhel testing instead
> of my own, but prior to the last couple kernels I don't recall this
> issue existing).

Do you have other systems that run cxgb4 and do not exhibit this lockdep issue? 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
