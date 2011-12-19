From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 11/14] ib_srp: Document sysfs attributes
Date: Mon, 19 Dec 2011 16:27:59 -0500
Message-ID: <1324330079.7043.27.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012009.12815.bvanassche@acm.org>
	 <1324254811.17849.65.camel@obelisk.thedillows.org>
	 <CAO+b5-rb=Gtch0UCZPwTSCHhOdsUBecSpgYjaLvj5pbo9_1AeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-rb=Gtch0UCZPwTSCHhOdsUBecSpgYjaLvj5pbo9_1AeQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-12-19 at 03:46 -0500, Bart Van Assche wrote:
> On Mon, Dec 19, 2011 at 12:33 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > On Thu, 2011-12-01 at 20:09 +0100, Bart Van Assche wrote:
> >> +             * cmd_sg_entries, the maximum number of memory descriptors
> >> +               that fit in a single SRP command when using the direct data
> >> +               buffer descriptor format.
> >
> > s/direct/indirect/
> 
> For the current ib_srp implementation cmd_sg_entries is the maximum
> number of direct data buffer descriptors allocated.

The direct memory descriptor format is only used when there is a single
memory region for the command; all other cases are described by an
indirect table; cmd_sg_entries limits the number of memory descriptors
from that table that will be cached in the command packet.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
