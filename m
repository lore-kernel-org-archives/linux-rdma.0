From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma_cm segfaults on RoCE with ConnectX-4 [WAS: Re: rping
 segfault with 4.9.28 on CentOS 7.3]
Date: Fri, 19 May 2017 06:53:40 +0300
Message-ID: <20170519035340.GG3616@mtr-leonro.local>
References: <CAANLjFp3PWJBiVabMGksarwg9BTM7Cg4mPrBsXY+mYh_zBbsgA@mail.gmail.com>
 <20170518050745.GZ3616@mtr-leonro.local>
 <CAANLjFqFEbV3ZNi9bvq0nf2bi+fx8iKXRL_ZdQoC13Pbz_5nhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QWIFStbFpmlD00Pf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFqFEbV3ZNi9bvq0nf2bi+fx8iKXRL_ZdQoC13Pbz_5nhw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--QWIFStbFpmlD00Pf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 18, 2017 at 09:59:02AM -0600, Robert LeBlanc wrote:
> On Wed, May 17, 2017 at 11:07 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Wed, May 17, 2017 at 12:14:18PM -0600, Robert LeBlanc wrote:
> >> Since I have a connectX-3 card in this same box, I set it up as
> >> Infiniband. I can run all the tests (udaddy, rping, ib_send_bw with -R
> >> or -z) using the Infiniband link, but the RoCE ConnectX-4 LX segfault
> >> on any rdma_cm communications.
> >>
> >> I put the ConnectX-3 into Ethernet mode and ran the tests again and it
> >> passed all of them while the ConnectX-4 LX cards still failed. We have
> >> some ConnectX-4 EN 100 Gb cards in other boxes that have the same
> >> problem.
> >>
> >> It really looks like this problem is specific to ConnectX-4 (mlx5
> >> driver) when running in RoCE. I _don't_ have ConnectX-4 IB cards to
> >> test. We are also seeing the problem with the Mellanox drivers. I
> >> can't find http://www.mellanox.com/page/custom_firmware_table to build
> >> a new OEM firmware for my SuperMicro branded cards to test the latest
> >> firmware.
> >
> > Robert,
> >
> > Please avoid top-posting, It is unreadable.
> >
> > In regards to your issue, the best way to move forward is to open
> > customer issue request and leverage established procedures to get
> > proper and prompt customer channel support.
> >
> > Thanks
>
> Are you saying to open a case with Mellanox? I performed all my tests
> with the in-box drivers, which I thought the community would be
> interested in. I _also_ ran my tests on the Mellanox OFED driver to
> see if it was something specific to the in-box drivers or consistent
> across both as an additional point of information to help with
> resolving the problem. The problem shows up in the in-box driver and
> the Mellanox OFED although a little different.

Nothing stops you from opening ticket in parallel. You will get prompt
resolution (the customer service measures it), dedicated engineer,
reproduction in-house, custom FW if needed.

Thanks

>
> Thanks
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

--QWIFStbFpmlD00Pf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkebEQACgkQ5GN7iDZy
WKdJlRAAg15uXgNHHxJ6CC9QEUoto5+1R9n0sL5lW06K82BtzVCOrhrPidwbVQt5
Yh2jhg1qDJ1dZjBocXFF0KY7aQopCZ5BFpdjqKV9qJnzJkJtOrteWa4c7PPD9aIi
WltymUPkB4vT4EDusn8B0otabEQcGWTU13RfECT1efonaEcDkes1TMKNgOtYXIb6
Yukh4Pu50gy0BK1NEbUtkdrsxuC7p7jK+NmdXmge/yzjzAjDzoqdzZ5NqMhJry+b
kv9WXvxsdsWqDDFwKo0sqDq5BGxpnIaY+nsVoHLsQklZKMt+4gl2CEAzKoEMTDQE
buI59OdbIWWzk1+QoCdOYdothau6IgtnDQULrPZKzxj/llGaqOixencFz5Ndgyb7
i4Hm04mW4ENdOAQZn/SMu5j52bPeV0gD3K9tPdOkP82MVRBESIlVHvzJWynd7br5
eJj5mBpgIrBhJC/x44kOhW65ViowGgymI6gBWwEF8440t9av7xDYJcHCGQjwhvnd
Fy0gikwo2eJncmNOEIkKUA2MK4Uke0GQIgFXnO8dg6gIAbWMLUce3fTMh6eg/AsS
VCaGHrReSRgClDofx/ETqe8+dNMz3fL6CreBgnPHW3S07roEXTz3ZGhhCRcUseNl
P7fjxTyTvzzi4SkkSbz6dnjbrvEB2rUj9RS7pZ2O7J+9/cXwqqg=
=RvtT
-----END PGP SIGNATURE-----

--QWIFStbFpmlD00Pf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
