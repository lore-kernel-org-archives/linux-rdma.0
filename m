From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Thu, 15 Oct 2009 15:35:12 -0600
Message-ID: <20091015213512.GW5191@obsidianresearch.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com> <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com> <4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com> <1255570760.13845.4.camel@obelisk.thedillows.org> <4AD74C88.8030604@mellanox.com> <1255634715.29829.9.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255634715.29829.9.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2009 at 03:25:15PM -0400, David Dillow wrote:
> On Thu, 2009-10-15 at 09:23 -0700, Vu Pham wrote:
> > David Dillow wrote:
> > > And if I want to disable this completely?
> > >   
> > 
> > Unless these patches are bad and affect the stability of the driver, why 
> > do you want to disable it? If you don't use multipath/device-mapper and 
> > use /dev/sd**, everything will be  same
> 
> I use multipath with ALUA, and I don't mind if the link flaps a bit. 60
> seconds is near my SCSI timeout of 77 seconds, so it doesn't buy me
> much. I'd rather multipath be delivering traffic to the backup path than
> sitting on its thumbs for 60 seconds doing nothing.

I've been left with a similar impression for several multipath things
I've seen in the past. True active/active multipath setups should have
a shorter timeout - there is no penalty for directing more traffic to
the 2nd path (the paths should be load balancing existing traffic in
the standard case anyhow).

An active/passive configuration might be different...

Certainly an enforced lower limit in the kernel is silly, and a
per-device setting does make some sense.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
