From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Wed, 1 Mar 2017 16:07:43 -0700
Message-ID: <20170301230743.GC2820@obsidianresearch.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <20170301001023.GA3001@phlsvsds.ph.intel.com>
 <CAFgAxU_i+5FtBkdf=t5vdQAvBqDt9aKsFJbAKGN5YWQQ9w-c2A@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E67C5CA68@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67C5CA68-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 10:15:31PM +0000, Weiny, Ira wrote:
> > On the call we discussed that today there is no 'incarnation'
> > value exposed for the uverbs%.  You suggested an optimization by
> > using the cdev's file creation timestamp as option for libibverbs
> > to understand that the driver did or did-not restart since mapping
> > of that ibv_device.

Not the cdev, read the timestamp from /sys/class/infiniband/mlx4_0/hca_type

> > Main pitfalls with this is if system time is being modified (admin
> > or ntp/ptp). In the rare case that we have a hoplug event and time
> > is rewinded we can accidentally reach a very hard debugging
> > exercise.

You are only using it for direct equality comparision, so someone
would have to roll back the clock and hotplug the driver at the exact
same nano-second resolution timestamp. That is deeply unlikely to ever
happen by accident.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
