From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [rdma-core patch] srp_daemon: srp_daemon.service should be
 started after network.target
Date: Mon, 1 Jan 2018 12:19:50 -0700
Message-ID: <20180101191950.GB10145@ziepe.ca>
References: <20171229101006.27861-1-honli@redhat.com>
 <20171229180058.GC6513@ziepe.ca>
 <20171230135927.GA23643@dhcp-13-42.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171230135927.GA23643-Y5OA6DF/u0nid9cnFhDO8BcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 30, 2017 at 09:59:27PM +0800, Honggang LI wrote:
> On Fri, Dec 29, 2017 at 11:00:58AM -0700, Jason Gunthorpe wrote:
> > On Fri, Dec 29, 2017 at 06:10:06PM +0800, Honggang LI wrote:
> > > From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > 
> > > The srp_daemon service will be started at the very beginning state
> > > of systemd when boot/reboot the machine, in case srp_daemon.service
> > > is not after network.target. As result, the srp_daemon.service will
> > > be terminated because of SERVICE_FAILURE_RESOURCES.
> > 
> > How is this possible?  srp_daemon.service just runs a script that
> > doesn't touch the network.
> 
> To reproduce it, you just need enable srp_daemon.serice and then reboot
> the machine. Watch the serial console when you are waiting for machine
> boot up. Please see attached /var/log/boot.log for details. After system
> boot up, check the status of srp_daemon.serice.

Well, I did this sort of testing when I originally set stuff up with
no problem. But I used Ubuntu Xenial with a newer systemd

So we need to find a root cause before we can evalute this as the
right solution..

> > but even that needs much more explaination about what exactly is
> > causing this requirement.
> > 
> > You said SERVICE_FAILURE_RESOURCES which is an internal systemd error
> > code. 
> 
> Yes, it is systemd-219-51.el7.x86_64 error code.
> 
> > Is this because of PrivateNetwork=yes or something similar?
>
> How to test or verify this?

Remove all the sandboxing thing and see if it starts working.

Add them back in until you find the one that breaks it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
