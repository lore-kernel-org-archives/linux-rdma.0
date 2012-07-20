From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/qib: Add support for per-device/per-port
 parameters
Date: Fri, 20 Jul 2012 11:40:06 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D47D8D1@FMSMSX108.amr.corp.intel.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
	<20120719130411.4706.88736.stgit@kop-dev-sles11-04.qlogic.org>
	<CAL1RGDVb964pLxx=gvuvP5SWcXT2+g2pPssH6YRSq0LFhup7yA@mail.gmail.com>
 <CAJZOPZJaNiKqKWpT=Jj2fXKf-X+6wLXrqXGCc+d0oH8ZQsNsZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJaNiKqKWpT=Jj2fXKf-X+6wLXrqXGCc+d0oH8ZQsNsZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If you could give me some code to look at?

The issue is many of the parameters need to be known at module load time since fundamental data structures need to be allocated to initialized the card.

Mike

> -----Original Message-----
> From: Or Gerlitz [mailto:or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, July 19, 2012 4:29 PM
> To: Roland Dreier
> Cc: Marciniszyn, Mike; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 3/5] IB/qib: Add support for per-device/per-port
> parameters
> 
> On Thu, Jul 19, 2012 at 9:26 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> wrote:
> 
> > I think this is pushing the module parameter facility way past the
> > breaking point of usability.  We really need to come up with a better
> > way to get complex structured config info like this into the drive
> 
> IB's netlink infrastructure?
> 
> Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
