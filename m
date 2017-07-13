From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Thu, 13 Jul 2017 16:15:20 -0600
Message-ID: <20170713221520.GA10088@obsidianresearch.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
 <1499968101.2740.10.camel@wdc.com>
 <20170713182018.GE11069@obsidianresearch.com>
 <1499970786.2740.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499970786.2740.17.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 06:33:07PM +0000, Bart Van Assche wrote:
> On Thu, 2017-07-13 at 12:20 -0600, Jason Gunthorpe wrote:
> > Here is an untested attempt to move module loading into srp_daemon -
> > what do you think Bart?
> 
> Hello Jason,
> 
> Thanks for the patch. To me this looks like a nice simplification compared
> to the current approach. Do you want me to test this patch?

I did some more steps..

Benjamin/Bart let me know what you think, I'll send the patches to the
list if you like the idea.

https://github.com/jgunthorpe/rdma-plumbing/tree/systemd

This replaces Benjamins rdma.conf based approach.

The basic approach is to directly use systemd to load the modules and
determine what modules to load by using udev and explicit Requires in
the units.

Eg, the extra modules for mlx4 are loaded by triggering this udev rule:

SUBSYSTEM=="module", KERNEL=="mlx4_core", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma-load-modules@mlx4"

Which causes the module loader to load the contents of the modules
list in /etc/rdma/modules/mlx4.conf

If the user does not want a specific to load then they can comment out
the module line in the /etc/rdma/modules files or use the usual module
black list scheme.

The interesting thing about this is how the boot ordering works, since
rdma-load-modules@.service is a 'before' sysinit.target it will run
before normal system startup tasks if the unit is scheduled to run
early enough. I expect that boot time module loads triggered by udev
will be early enough..

This makes it much closer to normal module loading, instead of being
so strange and should eliminate much of the need for explicit
rdma.service dependencies. The places that need something special,
like srp, can directly depend on their specific module loader:

Requires=rdma-load-modules@srp_daemon

Again, if srp_daemon is scheduled to start during system boot this
should result in the modules being loaded together with the rest of
the modules before sysinit.target.

The one nit that I don't have an easy solution for is starting modules
depending on the device technology, eg not starting srp or ipoib on
!IB devices. The issue is that I can't think of an easy way to detect
the device technology from the udev rule, at least not without a
helper script or additional kernel sysfs..

I havne't been able to test this yet, help would be appreciated.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
