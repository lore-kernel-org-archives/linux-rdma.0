From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/3] Autoloading for RDMA netlink modules
Date: Tue, 25 Jul 2017 08:34:20 -0600
Message-ID: <20170725143420.GA434@obsidianresearch.com>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170725063236.GQ3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170725063236.GQ3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 09:32:36AM +0300, Leon Romanovsky wrote:

> First, it interferes badly with my RDMA netlink series posted here in
> previous cycle and I'm expecting to see it in, so I can move forward
> with RDMAtool implementation.

I'm sure we can fix a few conflicts...

> Second, from brief review, it is unclear to me, how do you protect
> autoload caused by regular user who sends netlink message to ib_core.

You don't, that isn't how kernel auto loading works. Any user can
attempt to create any kind of socket and the core kernel code will
load the correct module to support that socket. That is the standard
way kernel autoloading works, particularly for net families.

> Third, it is ib_core who should autoload modules by default, and not some
> random daemon in user space.

Kernel autoloading of userspace facing kernel services is always
triggered by a user process attempting to use the service, so this
comment makes no sense to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
