From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Fri, 14 Jul 2017 10:40:29 -0600
Message-ID: <20170714164029.GA9942@obsidianresearch.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
 <1499968101.2740.10.camel@wdc.com>
 <20170713182018.GE11069@obsidianresearch.com>
 <1499970786.2740.17.camel@wdc.com>
 <20170713221520.GA10088@obsidianresearch.com>
 <1500026921.3563.27.camel@profitbricks.com>
 <20170714155544.GA25760@obsidianresearch.com>
 <1500049393.3563.42.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500049393.3563.42.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 14, 2017 at 06:23:13PM +0200, Benjamin Drung wrote:

> > My udev is not great, but something like this:
> > 
> > DRIVER=="mlx4_core", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma-load-modules@mlx4"
> > 
> > Might work better? I think that triggers on driver bind? Could you
> > try to switch your mlx and i40e drivers in that way?
> 
> I tried it. It works as expected. rdma-load-modules@mlx4 is loaded and 
> rdma-load-modules-QqjR1VyAyFhTDjBF/Jpztg@public.gmane.org is not loaded. Not tested if the udev
> trigger will also work for used built-in modules.

Okay, I will change it to be like that and we can see what people
think.

> > The only solution to this kind of problem is to add more ordering,
> > Debian should include a patch to rdma-load-modules@ to put it before
> > their unique networking.service..
> 
> Or patch rdma-load-modules@ to put it before network-pre.target

I think that would be OK.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
