From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bug Report: possible circular locking issue
Date: Mon, 28 Aug 2017 16:03:00 -0400
Message-ID: <1503950580.78641.115.camel@redhat.com>
References: <1503938316.78641.98.camel@redhat.com>
                 <1503947529.78641.108.camel@redhat.com>
                 <156f01d32032$7cbcadb0$76360910$@opengridcomputing.com>
         <1503948482.78641.110.camel@redhat.com>
         <158601d32036$02e2b0d0$08a81270$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <158601d32036$02e2b0d0$08a81270$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-08-28 at 14:44 -0500, Steve Wise wrote:
> > > > > I ran across this while testing a 4.13-rc7 kernel + the rdma
> > > > > next
> > > > > code.
> > > > 
> > > > This reproduces on a stock 4.13-rc7 kernel.  But, across all
> > > > the
> > > > stuff
> > > > I've booted it on so far, it only shows up on cxgb4 devices, so
> > > > I
> > > > think
> > > > this is a cxgb4 specific issue.  Steve, can you look into this?
> > > 
> > > Hey Doug.  Yes.   Is this a regression that shows up now in 4.13-
> > > rc
> > > but worked in older kernels?
> > 
> > I think so.  But I don't update this particular machine every
> > release
> > (mainly because it's a contested machine with a unique setup, and
> > the
> > last couple kernel releases it's been tied up with rhel testing
> > instead
> > of my own, but prior to the last couple kernels I don't recall this
> > issue existing).
> 
> Do you have other systems that run cxgb4

Yes...

>  and do not exhibit this lockdep issue? 

and I don't know.  The problem is that we only have a few systems with
cxgb4 hardware.  We have two pairs of systems that are used for
automated testing, and we have a few servers.  Of the servers, one of
them is almost never rebooted because it's the master node.  The other
one is the one I'm working with right now and altough it is not the
head node and does get test kernels and the like, it's also an NVMe
server and spent a lot of time doing that over the last 6 months.  And,
unfortunately, those automated tests on the other pairs of client
machines don't flag this particular problem because it doesn't cause
any tests to fail as far as I can tell.  It's a theoretical pointed out
by lockdep, but I don't know that we are actually hitting it.  I'm
logged into the server right now, and I can see the lockdep splat in
the dmesg output, but a ps axf | grep D comes back empty, so no threads
actually hit the lock order issue and deadlocked.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
