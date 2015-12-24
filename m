From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] Display extended counter set if available
Date: Thu, 24 Dec 2015 13:45:03 -0500
Message-ID: <20151224184503.GC22759@phlsvsds.ph.intel.com>
References: <20151221142026.238104419@linux.com> <20151221142039.386488696@linux.com> <CAKHjkjkwneRd9kTfHbQHLYMexhtP4ibE0sdHrUeYWmV=3fvYLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKHjkjkwneRd9kTfHbQHLYMexhtP4ibE0sdHrUeYWmV=3fvYLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 06:22:14PM +0200, eran ben elisha wrote:
> On Mon, Dec 21, 2015 at 4:20 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:

[snip]

> >
> > +/*
> > + * Figure out which counter table to use depending on
> > + * the device capabilities.
> > + */
> > +static struct attribute_group *get_counter_table(struct ib_device *dev)
> > +{
> > +       struct ib_class_port_info cpi;
> > +
> > +       if (get_perf_mad(dev, 0, IB_PMA_CLASS_PORT_INFO,
> 
> Why 0, need to pass port num.
> See proposal Matan and myself sent.
> 

Passing a port num to a ClassPortInfo query makes no sense?

Your proposal sets a field which is wrong (I think it sets part of TrapGID if
my math is correct) in the ClassPortInfo query as per the spec.

I think the fix needs to be somewhere else.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
