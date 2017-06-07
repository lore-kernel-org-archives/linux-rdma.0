From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core out-of-tree user library
Date: Wed, 7 Jun 2017 10:47:28 +0300
Message-ID: <20170607074728.GA1127@mtr-leonro.local>
References: <BN3PR07MB25781554943206E577DFC714F8CB0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170606162400.GB8671@obsidianresearch.com>
 <BN3PR07MB25781E538767514E0585E7C4F8C80@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB25781E538767514E0585E7C4F8C80-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 07, 2017 at 07:30:43AM +0000, Amrani, Ram wrote:
> > Two options,
> >
> > 1) The 'ofed' approach: just use the latest rdma-core. We want
> >    rdma-core to run on any kernel version and any distro release, so
> >    this should not be a major problem
>
> My major concern was that when it comes to distros we don't have their
> exact code base and/or can't release it. They take rdma-core X and
> apply patches on it so it becomes rdma-core X.Y.
> Hence if I take rdma-core X and apply my changes I will be actually
> missing several patches.
> Assuming backward-and-forward support, I might as well take rdma-core X+1
> and base upon it my newer patches.

You should leverage your partnership program with various distributions.
It will give you the actual code base, on which they are basing their
packages.

>
> > 2) For each targetted distro release back port the changes you want
> >    into the exact distro rdma-core source and distribute your driver
> >    binary from that build. This keeps everything very much the same
> >    but upgrades that driver.
> > > How are other providers handling this?
>
> As I've indicated above we don't have their exact code base and/or can't release it.
>
> > Most things I've seen have followed an OFED like approach because they
> > also want to ship an updated kernel component. Historically we have
> > not seen that much churn in the user space provider that is not linked
> > to kernel changes.
> >
> > Jason
>
> Thanks,
> Ram
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk3r5AACgkQ5GN7iDZy
WKcp5w/9HTLUmGcMKivQmh22O/ygHxX8ytFkNI1Ke531HJHbzAku3alRAdPMVXmk
1cUbvNQMJLZt82XEb1EMv0+vfpYrwfGpGp3xAY36m1lO/4+G6grmNa1nR1yf1miX
Zp5C6nNkLCpD93QTiP/1qT4sWF+qg/EohOfZqyvcLVjiUN6atXbL9XZdNs6/mb/1
NFoSIaaURmHm/Oil+nTtpd84STzuZBRJxRG3CHeJTbd4m4hznTn+2mIQxXLrMfOF
CDbIy2S+GoZLq1CwKl4fTWPgAiZdtbFHpKRjWMvtRW3PKoAGnHarVg9V66TQzv9D
lB3f2zHWU5iyqpNtG0lSnMep1te6X65D0kp+sg7d3Sz8trJ8wB18PjTk+eE85n3R
yPYMOn+n1tmTy+F6WoU8sL2ikroFa8tNjwRN37CTYKDbipcBlEHDeyD4ZExNP1Zl
1jeIucYzxTEaGqd+ZirIcIen/0ObSRFMoOnviDHGLGRXUb6TJAuRY8CJ6N2z4Ydp
yO5ERfCZg3nZ0d5nIsUgR2tHpkTByQFYTE8JqBvFV0cIGvC/MlhIanK4dCkYE811
wX4Ixcud935WmhpQAnKy/bzcmG6HaQ6iDZFfuec93bhOb2o7/+Sb/2qeqfuQV2F4
N3J7rQ87OjTrj1/7a9NWu9REEPEU+pXooMblLKlDTOkOmgy3MA0=
=QtKB
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
