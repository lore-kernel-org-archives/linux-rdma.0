From: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 1/5] kobject: Export kobj_ns_grab_current() and
 kobj_ns_drop()
Date: Tue, 9 Jan 2018 19:57:45 +0100
Message-ID: <20180109185745.GA13061@kroah.com>
References: <20180108231436.19750-1-bart.vanassche@wdc.com>
 <20180108231436.19750-2-bart.vanassche@wdc.com>
 <1515520784.2721.11.camel@wdc.com>
 <20180109183047.GA3236@kroah.com>
 <1515523648.2721.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515523648.2721.21.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 09, 2018 at 06:47:29PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-09 at 19:30 +0100, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:
> > On Tue, Jan 09, 2018 at 05:59:45PM +0000, Bart Van Assche wrote:
> > > I'd like to repost this series to address a bug in patch 5/5 of this series.
> > > But before I do that, can you tell me whether I perhaps should widen the
> > > Cc-list for patch 1/5 of this series?
> > 
> > I have no idea why you need these functions, as I don't see any of these
> > other patches.  Please resend the whole series please.
> > 
> > I will note that no driver had better be mucking around with a "raw"
> > kobject, or I am going to be very mad...
> 
> Hello Greg,
> 
> To allow you to have a look at the code that adds calls in a module to the
> namespace functions I had Cc'ed you for the entire series. Patch 5/5 of this
> series adds calls to the namespace functions exported through this patch.
> That patch is also available here:
> https://www.spinics.net/lists/linux-rdma/msg59190.html.

Ah, I see it now.

You do realize I've been a _bit_ busy, and for a patch you sent
_YESTERDAY_, it might take me a while to get to...

Please be patient.

greg k-h

> 
> Thanks,
> 
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
