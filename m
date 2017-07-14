From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Fri, 14 Jul 2017 18:23:13 +0200
Message-ID: <1500049393.3563.42.camel@profitbricks.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
         <1499968101.2740.10.camel@wdc.com>
         <20170713182018.GE11069@obsidianresearch.com>
         <1499970786.2740.17.camel@wdc.com>
         <20170713221520.GA10088@obsidianresearch.com>
         <1500026921.3563.27.camel@profitbricks.com>
         <20170714155544.GA25760@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170714155544.GA25760-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Freitag, den 14.07.2017, 09:55 -0600 schrieb Jason Gunthorpe:
> 2. You can just specify "etc/rdma/modules" in debian/rdma-
> > core.install
> > instead of listing each .conf file individually.
> 
> The srp_daemon.conf is in the srp package, so I don't think I can do
> that?

Yes. You are right. So it needs to be listed individually.

> > 4. Should rdma-load-modules@ *not* fail if the corresponding .conf
> > is
> > missing?
> 
> Does it fail now? Failing seems like the right thing to do for a
> missing conf file.

Yes. Currently it fails in this situation.

> > 5. How to handle build-in modules correctly? Our kernel has the
> > i40e
> > module built in (CONFIG_I40E=y) and rdma-load-modules-QqjR1VyAyFhTDjBF/Jpztg@public.gmane.org
> > will
> > be started, but the system does not have a i40e card and thus I
> > don't
> > want to have the module started. 
> 
> Fixing this would require more fancy udev wonkery - I copied RH's
> tested approach which triggers on driver presence, not on driver
> binding.
> 
> My udev is not great, but something like this:
> 
> DRIVER=="mlx4_core", ACTION=="add", TAG+="systemd",
> ENV{SYSTEMD_WANTS}="rdma-load-modules@mlx4"
> 
> Might work better? I think that triggers on driver bind? Could you
> try
> to switch your mlx and i40e drivers in that way?

I tried it. It works as expected. rdma-load-modules@mlx4 is loaded and 
rdma-load-modules-QqjR1VyAyFhTDjBF/Jpztg@public.gmane.org is not loaded. Not tested if the udev
trigger will also work for used built-in modules.

> > 6. The ipoib module (loaded by rdma-load-modules@infiniband) needs
> > to
> > loaded before the networking.service is running. The
> > networking.service
> > brings up the network devices on Debian. It runs "ifup -a" which
> > reads
> 
> Hum. That LSB networking.service sure is an ugly hack, it doesn't
> support hotplug so it has this:
> 
>   After=network-pre.target systemd-sysctl.service systemd-modules-
> load.service
> 
> To 'try' and run after some amount of hot plugging is done. IMHO this
> is done wrong, it should start after sysinit.target but before
> network-online.target or something... 
> 
> The only solution to this kind of problem is to add more ordering,
> Debian should include a patch to rdma-load-modules@ to put it before
> their unique networking.service..

Or patch rdma-load-modules@ to put it before network-pre.target

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
