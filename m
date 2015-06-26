From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Deprecating ipath
Date: Fri, 26 Jun 2015 09:54:01 -0700
Message-ID: <20150626165401.GA14699@kroah.com>
References: <32E1700B9017364D9B60AED9960492BC257567C3@fmsmsx120.amr.corp.intel.com>
 <CAB=NE6WTPKUF3EUVk6Z91pd+PYTjLdrLHr0Gn=n9+Z98cVdPWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAB=NE6WTPKUF3EUVk6Z91pd+PYTjLdrLHr0Gn=n9+Z98cVdPWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 26, 2015 at 09:23:27AM -0700, Luis R. Rodriguez wrote:
> On Fri, Jun 26, 2015 at 9:17 AM, Marciniszyn, Mike
> <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > Doug,
> >
> > We have been given the go ahead to start the deprecation process for thie ipath driver.
> 
> That's great! Do you mean removal from Linux?
> 
> > What do I need to do to get that done?
> 
> Feature removal txt file was removed from the kernel so there is no
> "schedule" per se, not sure what the process these days is for driver
> removal. How about punting it to staging for a release or two and then
> remove it? Not sure if that would be frowned upon or welcomed.

That is the process for driver removal, so of course it is welcomed :)

> That would have the cost of moving history through directories but git
> --follow helps with that these days. The gain of moving it to staging
> IMHO would be that if anyone who might care would need to complain may
> do so for a directory change for 1-2 release may spot this easily and
> the issues would be much less than an immediate removal.

Yes, that's why we do it this way.

Mike, feel free to send me a patch for this if you want me to queue it
up for 4.3.  For 4.2 it's too late.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
