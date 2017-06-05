From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Sun, 4 Jun 2017 23:50:43 -0500
Message-ID: <20170605045043.GA17148@ctung-MOBL3.amr.corp.intel.com>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <1496261429.2608.15.camel@sandisk.com>
 <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
 <20170604053635.GD6868@mtr-leonro.local>
 <20170605022313.GB18172@ctung-MOBL3.amr.corp.intel.com>
 <20170605040030.GG6868@mtr-leonro.local>
 <20170605042007.GA19068@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605042007.GA19068-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org" <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

You jump around in this thread so much it is hard for a sane person to follow
so I will attempt to summarize what has taken place.

You try to revert a patch that fixed a real problem in portmapper, claiming:

1) Code in question impacts the whole RDMA subsystem.
	which is false by my multiple replies on this.
2) There is a deadlock.
	Which is false.  I'm still asking for proof.
3) you want netlink receive to be non-blocking and asynchronous
	what does that have to do with the non-existing deadlock?
	Asnwer is you can't when there isn't one.
	If you want it, create a patch for it instead of creating a
	regression with a lazy revert.

I will continue this discussion if you answer directly to any of those
points.  If you choose to dance around the subject and claim falsehood, you
will only damage your own creditibility on the list.  I hope you take that
to heart.

Chien

On Sun, Jun 04, 2017 at 11:20:07PM -0500, Chien Tin Tung wrote:
>  Mon, Jun 05, 2017 at 07:00:30AM +0300, Leon Romanovsky wrote:
> > On Sun, Jun 04, 2017 at 09:23:13PM -0500, Chien Tin Tung wrote:
> > >  Sun, Jun 04, 2017 at 08:36:35AM +0300, Leon Romanovsky wrote:
> > > > On Fri, Jun 02, 2017 at 11:28:49AM -0500, Shiraz Saleem wrote:
> > > > > On Wed, May 31, 2017 at 02:10:31PM -0600, Bart Van Assche wrote:
> > > > > > On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> > > > > > > > 5. I proposed a solution -> go and fix your user space program.
> > > > > > >
> > > > > > > This is a kernel patch you are trying to revert, you are breaking existing
> > > > > > > kernel functionality.  Nothing to do with user space.
> > > > > > >
> > > > > > > Bottom line, come up with a solution that will address both port mapper
> > > > > > > functionality and your issue.
> > > > > >
> > > > > > Hello Shiraz,
> > > > > >
> > > > > > Sorry that this means additional work for you, but I agree with Leon that
> > > > > > user space software should not assume that netlink sockets are a reliable
> > > > > > communication mechanism.
> > > > >
> > > > > Hi Bart - Thank you for your response.
> > > > >
> > > > > The original problem was that ibnl_unicast, which is used to send nl messages from
> > > > > portmapper kernel space to user-space, would occasionally and momentarily fail under stress.
> > > > > We could have retried the call for a certain amount of time, but since netlink_unicast has a
> > > > > nonblock/block parameter, we chose to use the blocking option with a timeout. So we thought we
> > > > > did account for deadlocks with this timeout.
> > > >
> > > > Not really, you just reduced the chances. In very large scale, you will
> > > > have a very large chances of such deadlocks.
> > >
> > > Please stop using the word deadlock until you can prove that the deadlock exists with the timeout
> > > in place.
> > 
> > Can you please post the whole list of forbidden words? It will be great to
> > have it accompanied with technical response to my and Bart's claims, and
> > to summarize it, it is very simple: "netlink receive should be
> > non-blocking and asynchronous".
> 
> Non-blocking and asynchronous is not deadlock, please get it right.  Again, provide proof of
> deadlock, until then refrain from using that word in support of your argument.  Which you still
> have not proved there is a problem.
> 
> Chien
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
