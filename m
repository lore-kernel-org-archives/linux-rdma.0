From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [rdma-core patch] srp_daemon: srp_daemon.service should be
 started after network.target
Date: Fri, 29 Dec 2017 11:00:58 -0700
Message-ID: <20171229180058.GC6513@ziepe.ca>
References: <20171229101006.27861-1-honli@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171229101006.27861-1-honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 29, 2017 at 06:10:06PM +0800, Honggang LI wrote:
> From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> The srp_daemon service will be started at the very beginning state
> of systemd when boot/reboot the machine, in case srp_daemon.service
> is not after network.target. As result, the srp_daemon.service will
> be terminated because of SERVICE_FAILURE_RESOURCES.

How is this possible?  srp_daemon.service just runs a script that
doesn't touch the network.

I can't see any way that srp_daemon.service should have this added,
please explain more what is going on.

I could potentially understand needing it in srp_daemon_port@.service,
but even that needs much more explaination about what exactly is
causing this requirement.

You said SERVICE_FAILURE_RESOURCES which is an internal systemd error
code. Is this because of PrivateNetwork=yes or something similar?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
