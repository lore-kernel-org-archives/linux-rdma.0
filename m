From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] ipoib: Ratelimit messages which can flood a host.
Date: Wed, 03 Aug 2016 12:25:25 -0400
Message-ID: <1470241525.18081.66.camel@redhat.com>
References: <1469543929-17659-1-git-send-email-kernel@kyup.com>
	 <1469543929-17659-2-git-send-email-kernel@kyup.com>
	 <20160726180021.GA6144@yuval-lap.uk.oracle.com>
	 <1470234370.18081.63.camel@redhat.com> <57A2006B.5070304@kyup.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-yWz9uNo/qwI+eFy7fybl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57A2006B.5070304-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-yWz9uNo/qwI+eFy7fybl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-08-03 at 17:32 +0300, Nikolay Borisov wrote:
>=20
> On 08/03/2016 05:26 PM, Doug Ledford wrote:
> >=20
> > On Tue, 2016-07-26 at 21:00 +0300, Yuval Shaia wrote:
> > >=20
> > > On Tue, Jul 26, 2016 at 05:38:49PM +0300, Nikolay Borisov wrote:
> > > >=20
> > > >=20
> > > > In case an infiniband outtage occurs the messages modified
> > > > in this patchset can flood the host with a rate of 1 message
> > > > per
> > >=20
> > > s/patchset/patch
> > >=20
> > > >=20
> > > >=20
> > > > ms which is a lot. Using the ratelimited version of ipoib_warn
> > > > fixes the issue by limiting at most 10 messages in 5 seconds.
> > > >=20
> > > > Signed-off-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
> > > > ---
> > > > =C2=A0drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
> > > > =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
> > > >=20
> > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > index 7d3281866ffc..dd5b4afbc00b 100644
> > > > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > @@ -1034,9 +1034,9 @@ static void ipoib_timeout(struct
> > > > net_device
> > > > *dev)
> > > > =C2=A0{
> > > > =C2=A0	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > > > =C2=A0
> > > > -	ipoib_warn(priv, "transmit timeout: latency %d
> > > > msecs\n",
> > > > +	ipoib_warn_rl(priv, "transmit timeout: latency %d
> > > > msecs\n",
> > > > =C2=A0		=C2=A0=C2=A0=C2=A0jiffies_to_msecs(jiffies - dev-
> > > > >trans_start));
> > > > -	ipoib_warn(priv, "queue stopped %d, tx_head %u,
> > > > tx_tail
> > > > %u\n",
> > > > +	ipoib_warn_rl(priv, "queue stopped %d, tx_head %u,
> > > > tx_tail
> > > > %u\n",
> > >=20
> > > So this is just to hide the hide the problem,
> >=20
> > No, that's not true.=C2=A0=C2=A0To hide the problem, he would have to r=
emove
> > the
> > printk entirely.=C2=A0=C2=A0Linus absolutely despises when programmers =
use
> > BUG_ON() for situations where it is possible for the system to
> > continue, albeit with reduced capability or what not.=C2=A0=C2=A0Simila=
rly,
> > it is
> > entirely unacceptable that a simple issue, such as a hardware queue
> > stoppage on a network device, can render a system mostly or
> > entirely or
> > even just somewhat unusable due to a flood of kernel printk
> > messages.
> >=20
> > Just so we're clear, I absolutely despise printk floods.=C2=A0=C2=A0The=
re is
> > never a valid reason for them.=C2=A0=C2=A0If someone in the kernel comm=
unity
> > suggested that we make the default printk implementation be flood
> > proof, I would support it.=C2=A0=C2=A0In the meantime, I'm all for thes=
e
> > patches.
> > =C2=A0And if there are other places in the ipoib code that can cause
> > floods
> > too, I would like to see them switched over to use the rate limited
> > version too.
> >=20
> > Now that I think about it, I'm just as likely to be receptive to a
> > patch that makes the default ipoib_warn() always be rate limited,
> > and
> > if there are exceptions in the ipoib stack where we truly want
> > every
>=20
> The thing with this approach is that it's entirely possible to miss
> messages if there is one particular ratelimit state.
>=20
> >=20
> > message, then change just those places to a different
> > ipoib_warn_no_rate_limit() implementation.=C2=A0=C2=A0I would probably =
modify
> > the
> > default rate though...10 in 5 seconds is probably too low for some
> > of
> > the messages, as we can legitimately get a burst of 50 in less than
> > a
> > second when doing things like joining lots of multicast groups and
> > there is an issue, or something like that.=C2=A0=C2=A0Maybe 100 in 60 t=
o
> > allow
> > for bursts but to still prevent runaway printks like you are
> > having?
> >=20
> If you take a closer look at the definition of ipoib_warn_rl you
> would
> see that it's enclosed in it's own {} block, meaning its ratelimit
> state
> is going to apply to this particular place. In essence only the
> "transmit timeout: latency msec" message would be rate limited to 10
> messages in 5 seconds, which I believe is fine. In a flood situation
> you'd get 10 identical messages and then there will be a line saying
> how
> many were suppressed, indicating a flood.

I saw that. =C2=A0You're missing my point. =C2=A0I was referring to keeping=
 the
individual {} block in the define of ipoib_warn() instead of creating a
new ipoib_warn_rl() define, but I was commenting that some of the
messages in the ipoib file really need a higher burst, and since even
though each of these messages would have their own rate limit state,
they still all share a common rate limit config, the config would need
to be bumped up for some of the spammier message spots in ipoib.

>=20
> >=20
> > >=20
> > > =C2=A0the real question is what is
> > > causing this to happen a lot.
> > >=20
> > > >=20
> > > >=20
> > > > =C2=A0		=C2=A0=C2=A0=C2=A0netif_queue_stopped(dev),
> > > > =C2=A0		=C2=A0=C2=A0=C2=A0priv->tx_head, priv->tx_tail);
> > > > =C2=A0	/* XXX reset QP, etc. */
> > > > --=C2=A0
> > > > 2.5.0
> > > >=20
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe
> > > > linux-
> > > > rdma" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-=
info.h
> > > > tml
> >=20

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-yWz9uNo/qwI+eFy7fybl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXohr1AAoJELgmozMOVy/dfqQQAKJMrmxvsPenGPhw2czcQFZS
nGhhi2CgzhKVJ2nZ4BPfwGVPJJXuQrEuMPhKrQ3a56+rPLQic/eSMha7bsccENk2
suv0j6z98JkJxjRQsai6wNEmlLygaRr2ObKeivlC3QFc0T0j0hl2HtW/dsi8EFQM
29D3ICDxW+l1bqzft47MdRUe0knEvyZ0b85wM2S65iYTyn/My1NC8s1g2Ro4QM7o
i6L8Fmtk0b/j1BszvIYoqj7IdqCuvJJLzfs28sM3NB7dS14Joe684+KdBWJKq/md
pUnMEXjYHj/kIixfOrw50ZKhmU0I3yKb6977NN/dtwq6KWjMevcSKAHv1yD9ceaZ
Jadw0b8bzRoX99XoneRjgnhFsASzwjY664TRAYTvoo+rXwmcRG/q1fOZbdbt8yRP
mbyQrRjlwukix8vlAqyKJ/p0/V9ofhKyHZ4iAgBU0a2icibAVwvZ8ggJZzHbyktO
qQPSPSsnUHhppxsl4AVa7LTJbe2TOTd0Fyoi0ljejNuExcSQ31DrRAwcjZkGalvZ
qJCMIeg67nIOtb/Ji6BrcheYNqosvIvV2sW2iGIAUwxCJMv0cBQ8WgjrkfjiAHm1
xd7iYcmDH/Ot5/v+/ae9arz9XqImhBPC9tKYwSSZ+6uYXFbMG0JK1QX16AZnJsK8
xRDrGFcFuiheaLBrrOAs
=OqrU
-----END PGP SIGNATURE-----

--=-yWz9uNo/qwI+eFy7fybl--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
