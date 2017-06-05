From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Mon, 5 Jun 2017 09:03:18 +0300
Message-ID: <20170605060318.GH6868@mtr-leonro.local>
References: <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <1496261429.2608.15.camel@sandisk.com>
 <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
 <20170604053635.GD6868@mtr-leonro.local>
 <20170605022313.GB18172@ctung-MOBL3.amr.corp.intel.com>
 <20170605040030.GG6868@mtr-leonro.local>
 <20170605042007.GA19068@ctung-MOBL3.amr.corp.intel.com>
 <20170605045043.GA17148@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GUPx2O/K0ibUojHx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605045043.GA17148-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org" <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GUPx2O/K0ibUojHx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 04, 2017 at 11:50:43PM -0500, Chien Tin Tung wrote:
> You jump around in this thread so much it is hard for a sane person to follow
> so I will attempt to summarize what has taken place.
>
> You try to revert a patch that fixed a real problem in portmapper, claiming:
>
> 1) Code in question impacts the whole RDMA subsystem.
> 	which is false by my multiple replies on this.
> 2) There is a deadlock.
> 	Which is false.  I'm still asking for proof.
> 3) you want netlink receive to be non-blocking and asynchronous
> 	what does that have to do with the non-existing deadlock?
> 	Asnwer is you can't when there isn't one.
> 	If you want it, create a patch for it instead of creating a
> 	regression with a lazy revert.
>
> I will continue this discussion if you answer directly to any of those
> points.  If you choose to dance around the subject and claim falsehood, you
> will only damage your own creditibility on the list.  I hope you take that
> to heart.

OK, I got your point. It is worthless discussion.

FYI, ibnl_unicast holds global lock for whole NETLINK_RDMA
static void ibnl_rcv(struct sk_buff *skb)
{
        mutex_lock(&ibnl_mutex);
        ibnl_rcv_reply_skb(skb);
        netlink_rcv_skb(skb, &ibnl_rcv_msg);
        mutex_unlock(&ibnl_mutex);
}

I'll wait for a maintainer's decision on the proposed patch.

Thanks

>
> Chien
>
> On Sun, Jun 04, 2017 at 11:20:07PM -0500, Chien Tin Tung wrote:
> >  Mon, Jun 05, 2017 at 07:00:30AM +0300, Leon Romanovsky wrote:
> > > On Sun, Jun 04, 2017 at 09:23:13PM -0500, Chien Tin Tung wrote:
> > > >  Sun, Jun 04, 2017 at 08:36:35AM +0300, Leon Romanovsky wrote:
> > > > > On Fri, Jun 02, 2017 at 11:28:49AM -0500, Shiraz Saleem wrote:
> > > > > > On Wed, May 31, 2017 at 02:10:31PM -0600, Bart Van Assche wrote:
> > > > > > > On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> > > > > > > > > 5. I proposed a solution -> go and fix your user space program.
> > > > > > > >
> > > > > > > > This is a kernel patch you are trying to revert, you are breaking existing
> > > > > > > > kernel functionality.  Nothing to do with user space.
> > > > > > > >
> > > > > > > > Bottom line, come up with a solution that will address both port mapper
> > > > > > > > functionality and your issue.
> > > > > > >
> > > > > > > Hello Shiraz,
> > > > > > >
> > > > > > > Sorry that this means additional work for you, but I agree with Leon that
> > > > > > > user space software should not assume that netlink sockets are a reliable
> > > > > > > communication mechanism.
> > > > > >
> > > > > > Hi Bart - Thank you for your response.
> > > > > >
> > > > > > The original problem was that ibnl_unicast, which is used to send nl messages from
> > > > > > portmapper kernel space to user-space, would occasionally and momentarily fail under stress.
> > > > > > We could have retried the call for a certain amount of time, but since netlink_unicast has a
> > > > > > nonblock/block parameter, we chose to use the blocking option with a timeout. So we thought we
> > > > > > did account for deadlocks with this timeout.
> > > > >
> > > > > Not really, you just reduced the chances. In very large scale, you will
> > > > > have a very large chances of such deadlocks.
> > > >
> > > > Please stop using the word deadlock until you can prove that the deadlock exists with the timeout
> > > > in place.
> > >
> > > Can you please post the whole list of forbidden words? It will be great to
> > > have it accompanied with technical response to my and Bart's claims, and
> > > to summarize it, it is very simple: "netlink receive should be
> > > non-blocking and asynchronous".
> >
> > Non-blocking and asynchronous is not deadlock, please get it right.  Again, provide proof of
> > deadlock, until then refrain from using that word in support of your argument.  Which you still
> > have not proved there is a problem.
> >
> > Chien
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--GUPx2O/K0ibUojHx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk09CYACgkQ5GN7iDZy
WKfvqQ/7BUL3VsIXIJ/FU4JIPiP9agkSXKnAmilER8smnhbRl3nUNREq4aOLbCpW
uC+YApyP2Ojuk8/o0WQayzCkqcCfukMEaQeeT+/LdsStZFqWbgM62ScPtuA3NnLG
9IBK4T1Xh3BKWxd1v2llnN80EI2+7tCcQs4ulUiEcyjvV0f/sX9DWxcqhwK49hBR
/+KmB50fXV3UW2ZTDfOufwgvBu+/XDo5dLForCw3zQZ1AH4eFf2/bJJVDmFGhzzH
LrLq1TgCdM8swVmFVpCnfFfxQ/bxlfQrJkIhAbGVeOWixC+2Qd4re2DzLKXTNnQM
4SYEDM3eyvXLomFAQdcy2S1ND2YdvkPgF3PIB+wlaVi82NLBcdaDe6Jjm7SnBhv0
Pr/ah/hNwfVjoIiBLJoiij2NHPxZdW6HD16MvyiYW1DdTlgH4VC7EJitdvhzStbe
WCSyWFApnd7VHZpBFNvI6dyGgJ0XtP3aDHLifxavbBJLjyVjnj5bfh2fF5XjMlyW
FB3p6FOLrzU5W9S3GyMUBm8DJecItIyL9DVtKGP6ubHL7DSgacYlAm5M+8KuhgRu
eLz7pPUUaQiVXg3sCETcKSbGvYRrSHSF9jhCdRj8ncteHKyeBcNSz8IbFDujtUQ/
VTO9bnwwV363/+zvloSmvOx+mNoCTTeWIe9/AXkhaFbybwhkh6k=
=So2J
-----END PGP SIGNATURE-----

--GUPx2O/K0ibUojHx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
