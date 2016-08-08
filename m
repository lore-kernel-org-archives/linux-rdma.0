From: J Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: Queue ns scanning after a sucessful
 reconnection
Date: Mon, 08 Aug 2016 12:43:50 -0700
Message-ID: <1470685430.4368.9.camel@linux.intel.com>
References: <1469980540-16103-1-git-send-email-sagi@grimberg.me>
	 <1470330508.19927.18.camel@linux.intel.com>
	 <ce424fe1-d6e8-706f-18f8-aa9c880bcdec@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ce424fe1-d6e8-706f-18f8-aa9c880bcdec-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2016-08-07 at 12:12 +0300, Sagi Grimberg wrote:
> > 
> > > 
> > > On an ordered target shutdown, the target can send a AEN on a
> > > namespace
> > > removal, this will trigger the host to queue ns-list query. The
> > > shutdown
> > > will trigger error recovery which will attepmt periodic
> > > reconnect.
> > > 
> > > We can hit a race where the ns rescanning fails (error recovery
> > > kicked
> > > in and we're not connected) causing removing all the namespaces
> > > and
> > > when
> > > we reconnect we won't see any namespaces for this controller.
> > > 
> > > So, queue a namespace rescan after we successfully reconnected to
> > > the
> > > target.
> > > 
> > > Note, that unlike user initiated controller reset, we don't need
> > > to
> > > trigger
> > > namespace scanning (until the point I noticed the above at least)
> > > because we
> > > reconnect to an existing controller. However due to the
> > > interaction
> > > with
> > > the aen mechanism we queue ns scan here as well.
> > > 
> > > Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> > > ---
> > > I'm open to other suggestions if anyone has any...
> > 
> > this sounds like a fix that should really go in the core target
> > code
> > instead of RDMA code as this could affect any implementation layer.
> 
> But it fixes the host behavior (nvme-rdma).

Actually I think I meant host but didn't have enough coffee for my
brain when I looked at this :-/...

OK, makes sense.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
