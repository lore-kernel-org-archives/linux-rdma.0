From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 18 May 2011 11:02:26 -0600
Message-ID: <20110518170226.GA2595@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
 <BANLkTimWMU9ohSQGYEEnFR0HbBaypFR51A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimWMU9ohSQGYEEnFR0HbBaypFR51A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2011 at 09:44:01AM -0700, Roland Dreier wrote:

> and have support for named extensions, I think that would be even
> better.  ie we could define a bunch of new XRC related stuff and
> then have some interface to the driver where we ask for the "XRC"
> extension (by name with a string) then that would be very handy for
> the future.

Considering the fairly small community I'm not sure this much
complexity has a payoff? uDAPL already has an API like that and I'm
not sure it has done much for usability.

As long as the version number in the ibv_context is increasing and not
branching then I think it is OK. 0 = what we have now. 1 = + XRC, 2 =
+XRC+ummunotify, etc. Drivers 0 out the function pointers they do not
support.

I think getting the XRC stuff sorted is pretty important, it would
be nice to keep it tight..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
