From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [rdma-core patch] srp_daemon: srp_daemon.service should be
 started after network.target
Date: Tue, 2 Jan 2018 07:58:08 -0700
Message-ID: <20180102145808.GC29208@ziepe.ca>
References: <20171229101006.27861-1-honli@redhat.com>
 <20171229180058.GC6513@ziepe.ca>
 <20171230135927.GA23643@dhcp-13-42.nay.redhat.com>
 <20180101191950.GB10145@ziepe.ca>
 <20180102074125.GA24071@dhcp-13-42.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180102074125.GA24071-Y5OA6DF/u0nid9cnFhDO8BcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 02, 2018 at 03:41:25PM +0800, Honggang LI wrote:
> On Mon, Jan 01, 2018 at 12:19:50PM -0700, Jason Gunthorpe wrote:
> > > Yes, it is systemd-219-51.el7.x86_64 error code.
> > > 
> > > > Is this because of PrivateNetwork=yes or something similar?
> > >
> > > How to test or verify this?
> > 
> > Remove all the sandboxing thing and see if it starts working.
> 
> "PrivateNetwork=yes/no" is not the root cause of this issue.
> 
> > 
> > Add them back in until you find the one that breaks it.
> 
> I had confirmed this is a systemd issue with Fedora-27 distro. F27
> works as higher version systemd is running.
> 
> Please drop this patch.

Very mysterious then, any idea what is going on?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
