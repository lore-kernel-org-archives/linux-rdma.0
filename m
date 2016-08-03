From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] ipoib: Ratelimit messages which can flood a host.
Date: Wed, 03 Aug 2016 10:26:10 -0400
Message-ID: <1470234370.18081.63.camel@redhat.com>
References: <1469543929-17659-1-git-send-email-kernel@kyup.com>
	 <1469543929-17659-2-git-send-email-kernel@kyup.com>
	 <20160726180021.GA6144@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4+imx38ClrmdR6DxgabZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160726180021.GA6144-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-4+imx38ClrmdR6DxgabZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-07-26 at 21:00 +0300, Yuval Shaia wrote:
> On Tue, Jul 26, 2016 at 05:38:49PM +0300, Nikolay Borisov wrote:
> >=20
> > In case an infiniband outtage occurs the messages modified
> > in this patchset can flood the host with a rate of 1 message per
>=20
> s/patchset/patch
>=20
> >=20
> > ms which is a lot. Using the ratelimited version of ipoib_warn
> > fixes the issue by limiting at most 10 messages in 5 seconds.
> >=20
> > Signed-off-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
> > ---
> > =C2=A0drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
> > =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > index 7d3281866ffc..dd5b4afbc00b 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -1034,9 +1034,9 @@ static void ipoib_timeout(struct net_device
> > *dev)
> > =C2=A0{
> > =C2=A0	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > =C2=A0
> > -	ipoib_warn(priv, "transmit timeout: latency %d msecs\n",
> > +	ipoib_warn_rl(priv, "transmit timeout: latency %d
> > msecs\n",
> > =C2=A0		=C2=A0=C2=A0=C2=A0jiffies_to_msecs(jiffies - dev->trans_start))=
;
> > -	ipoib_warn(priv, "queue stopped %d, tx_head %u, tx_tail
> > %u\n",
> > +	ipoib_warn_rl(priv, "queue stopped %d, tx_head %u, tx_tail
> > %u\n",
>=20
> So this is just to hide the hide the problem,

No, that's not true. =C2=A0To hide the problem, he would have to remove the
printk entirely. =C2=A0Linus absolutely despises when programmers use
BUG_ON() for situations where it is possible for the system to
continue, albeit with reduced capability or what not. =C2=A0Similarly, it i=
s
entirely unacceptable that a simple issue, such as a hardware queue
stoppage on a network device, can render a system mostly or entirely or
even just somewhat unusable due to a flood of kernel printk messages.

Just so we're clear, I absolutely despise printk floods. =C2=A0There is
never a valid reason for them. =C2=A0If someone in the kernel community
suggested that we make the default printk implementation be flood
proof, I would support it. =C2=A0In the meantime, I'm all for these patches=
.
=C2=A0And if there are other places in the ipoib code that can cause floods
too, I would like to see them switched over to use the rate limited
version too.

Now that I think about it, I'm just as likely to be receptive to a
patch that makes the default ipoib_warn() always be rate limited, and
if there are exceptions in the ipoib stack where we truly want every
message, then change just those places to a different
ipoib_warn_no_rate_limit() implementation. =C2=A0I would probably modify th=
e
default rate though...10 in 5 seconds is probably too low for some of
the messages, as we can legitimately get a burst of 50 in less than a
second when doing things like joining lots of multicast groups and
there is an issue, or something like that. =C2=A0Maybe 100 in 60 to allow
for bursts but to still prevent runaway printks like you are having?

>  the real question is what is
> causing this to happen a lot.
>=20
> >=20
> > =C2=A0		=C2=A0=C2=A0=C2=A0netif_queue_stopped(dev),
> > =C2=A0		=C2=A0=C2=A0=C2=A0priv->tx_head, priv->tx_tail);
> > =C2=A0	/* XXX reset QP, etc. */
> > --=C2=A0
> > 2.5.0
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-info=
.html

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-4+imx38ClrmdR6DxgabZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXof8CAAoJELgmozMOVy/dXfAQAL1MTuNVw/CvYDJqi2OYrgf5
a8ZAzBsOmmFGgrfj4MvsMp2EOAtQorp2r8oJSW+VozbF9cvuPuljse95fLmi8T5Z
MGNgVFEMXNCyNXr9xjeyH1LyPBiRnm3IWYie9KljyS+tiEV8nYTIXagbla2lQ3KG
VhWchbu49jfKycsh/2+Zs4U2ZjRD2mmepAEU/7HXD5lwE/UO5obZu3y+kuaXabp8
L6aV3uduwkgkVYXcnzb57fwGEzUq6Ougab7tiXsfFYhpzUhNxXPWYghruQOqZ2GU
17YmIKIV4jgPo1pjOy7EFK2APPIidn9BfOFyy6IyUaXeBo4Qo/mKgKkhi47CsE8o
tgodzM0JwMOVb+Q/kGfo7ge1EDUzQUeSOJfYY/xe64mgOtwnMTzuNfQ29qvAJY2n
tvgA6MGaERWIKCqrwtmBA0QCabNISF+S3CuH8gYOqjmNUOSdiMfVxFsSJHHLDfPc
PTgQTXKeNkawyKuKZcKvEhPtMYR1c9chCtQdVjRVYEht4ylUQ2fMJF/gEhaeM7qq
dULYvm2g9Qk1FdfTJXUntqEnzxpV9IMb5YukBjVnmMRg6TsnN+SAHQNbhJfqV5wO
NnW4AcEHwW4ex3Qvxc6JWMqAbc9ouSBhSkDOkirxs6zvYZ+CATtlI8TzUCP7mqA2
dJzRZ6Iuab1/351DSSZy
=odZt
-----END PGP SIGNATURE-----

--=-4+imx38ClrmdR6DxgabZ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
