From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Thu, 20 Jul 2017 20:45:19 -0600
Message-ID: <20170721024519.GA24581@obsidianresearch.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
 <1499968101.2740.10.camel@wdc.com>
 <20170713182018.GE11069@obsidianresearch.com>
 <1499970786.2740.17.camel@wdc.com>
 <20170713221520.GA10088@obsidianresearch.com>
 <1500026921.3563.27.camel@profitbricks.com>
 <20170714155544.GA25760@obsidianresearch.com>
 <1500049393.3563.42.camel@profitbricks.com>
 <20170714164029.GA9942@obsidianresearch.com>
 <1500541450.4226.5.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500541450.4226.5.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 20, 2017 at 11:04:10AM +0200, Benjamin Drung wrote:
> Am Freitag, den 14.07.2017, 10:40 -0600 schrieb Jason Gunthorpe:
> > On Fri, Jul 14, 2017 at 06:23:13PM +0200, Benjamin Drung wrote:
> > 
> > > > My udev is not great, but something like this:
> > > > 
> > > > DRIVER=="mlx4_core", ACTION=="add", TAG+="systemd",
> > > > ENV{SYSTEMD_WANTS}="rdma-load-modules@mlx4"
> > > > 
> > > > Might work better? I think that triggers on driver bind? Could
> > > > you
> > > > try to switch your mlx and i40e drivers in that way?
> > > 
> > > I tried it. It works as expected.?rdma-load-modules@mlx4 is loaded
> > > and?
> > > rdma-load-modules-QqjR1VyAyFhTDjBF/Jpztg@public.gmane.org is not loaded. Not tested if the
> > > udev
> > > trigger will also work for used built-in modules.
> > 
> > Okay, I will change it to be like that and we can see what people
> > think.
> 
> Any updates?

I've been doing some more testing here and it does not work entirely
properly yet.

The change to 'DRIVER==' causes things to fail, the kernel only
generates uevents when kobjects are created, and binding a driver to a
PCI device does not create a kobject. This means these lines:

DRIVER=="mlx4_core", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma-load-modules@mlx4"

Do not work reliably. Depending on the module like before would still
seem to be the best option.

Also, the ordering before sysinit.target does not work reliably, udev
loads modules asynchronously and systemd does not block on udev unless
systemd-udevd-settle is depended on.

I'm not sure how Debian's legacy networking.service manages to work at
all, perhaps it is broken and it is just unlikely to be hit because of
how quickly most ethernet drivers get loaded by udev.

As far as I can tell, it needs to depend on systemd-udevd-settle to
guarentee that all the cold-plug network drivers have been loaded by
udev before starting..

.. all of these comments would seem to apply equally to the
rdma.service approach, so I think this is still an improvement.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
