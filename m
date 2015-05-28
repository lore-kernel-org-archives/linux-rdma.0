From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Thu, 28 May 2015 13:50:34 -0600
Message-ID: <20150528195034.GA11182@obsidianresearch.com>
References: <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com>
 <20150527184856.GA16059@obsidianresearch.com>
 <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
 <20150527222108.GA7855@obsidianresearch.com>
 <5566BDE4.50709@mellanox.com>
 <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org>
 <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org>
 <20150528175043.GA10966@obsidianresearch.com>
 <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1505281325150.1794-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 28, 2015 at 01:30:52PM -0500, Christoph Lameter wrote:
> On Thu, 28 May 2015, Jason Gunthorpe wrote:
> 
> > > This is sufficient since it can be converted to ns or whatever one wants.
> >
> > Sure it is sufficient, but is it a robust UAPI, will it support
> > multiple hardware vendors?
> 
> What would prevent other hardware vendors from exporting their counters?

Well, I'm not a HW vendor, so I don't know for sure, the proposal is:

timestamp_mask - how many bits are valid in the timestamp.
		 timestamp values could be 64bits the most.
hca_core_clock - timestamp is given in HW cycles, hca_core_clock
                 is the frequency of the HCA and is necessary in
		 order to convert cycles to seconds.

So presumably cycle difference is:
  (a-b) & mask
And to ns is
 a*1E9/hca_core_clock

So first, the above is a tricky bit of math to open code, integer
overflow needs to be avoided - so at a minimum I'd like to see
libibverbs provide this as a function call. I'd probably also say
difference should be an inline too.

If it is a function call then maybe we don't need to tell the app
about hca_core_clock?

Second: What about wrap around? Does it even make sense to expose less
than 64 bits to userspace? Should the driver manage wrap around to
create a flat 64 bit space?

Otherwise, if the app has to do it, there is no event indicating wrap
has occured.

Without managing wrapping, cycle count difference is not a reliable
calculation.

> > Is anyone else in ethernet using verbs to deliver IP packets?
> 
> This is not only for Ethernet. Internally Infiniband is frequently used
> and there also timestamps are useful.

Sure, but should any other vendors be commenting on this UAPI?

> Well no. There has been a history of putting time corrections etc etc into
> these. Once you move from a raw counter to actual time various
> complications may need to be dealt with. For simple time differentials the
> counter is sufficient. If you really want proper "time" when something
> happens then you may want to scale and correct etc the value and have some
> sort of time sync approach.

Sure OK, I'm sold, export a cycle counter of some sort.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
