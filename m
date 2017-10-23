From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/hfi1: Validate PKEY for incoming GSI MAD
 packets
Date: Mon, 23 Oct 2017 22:31:02 +0300
Message-ID: <20171023193102.GE16127@mtr-leonro.local>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
 <20171023130558.21191.30808.stgit@scvm10.sc.intel.com>
 <20171023183848.GC16127@mtr-leonro.local>
 <d09970ea-2531-4d8e-0b4f-85533ff8487a@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d09970ea-2531-4d8e-0b4f-85533ff8487a-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ey/N+yb7u/X9mFhi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 02:55:38PM -0400, Dennis Dalessandro wrote:
> On 10/23/2017 2:38 PM, Leon Romanovsky wrote:
> > > diff --git a/drivers/infiniband/hw/hfi1/mad.c
> b/drivers/infiniband/hw/hfi1/mad.c
> > > index 07b80fa..dfe6224 100644
> > > --- a/drivers/infiniband/hw/hfi1/mad.c
> > > +++ b/drivers/infiniband/hw/hfi1/mad.c
> > > @@ -98,6 +98,16 @@ static inline void clear_opa_smp_data(struct opa_smp *smp)
> > >   	memset(data, 0, size);
> > >   }
> > >
> > > +static inline u16 hfi1_lookup_pkey_value(struct hfi1_ibport *ibp, int pkey_idx)
> >
> > Please, no "inline-function" in *.c files as it is written in CodingStyle.
>
> Sure about that?

I'm not style-nazi, so won't insist, but this is in CodingStyle.

Documentation/process/coding-style.rst
 841 15) The inline disease
 842 ----------------------
 843
 844 There appears to be a common misperception that gcc has a magic "make me
 845 faster" speedup option called ``inline``. While the use of inlines can be
 846 appropriate (for example as a means of replacing macros, see Chapter 12), it
 847 very often is not. Abundant use of the inline keyword leads to a much bigger
 848 kernel, which in turn slows the system as a whole down, due to a bigger
 849 icache footprint for the CPU and simply because there is less memory
 850 available for the pagecache. Just think about it; a pagecache miss causes a
 851 disk seek, which easily takes 5 milliseconds. There are a LOT of cpu cycles
 852 that can go into these 5 milliseconds.

>
> As a rule of thumb I agree we should not put inlines in C files though.
> However as you can see from the context, this file already has static
> inlines so I wasn't too bothered by it.
>
> -Denny
>

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuQ3YACgkQ5GN7iDZy
WKdBOA//fr1X8JXrl64JE20T2FRAxfjerjoyG5MsPCuk55uirpvYd9ud+W1HOedb
cbVs0HiAyRyzI4RvisATtaACXkIcqrsVWR/rWWgEyrSw2a3XG442bz3MpZH+nN3H
GnalZakNY+mUoPlwkzXs8wGn6FIW5aH4loBRc1kyqVerPmIQyIlbe8AMCMJ6rRsI
kkiQQ96N6lDndGGCSHsxrTdUyaZ561sjioDr2sZCiN4XPCZKLN93p4low7lsU4eK
YkFL8taHn2R9UwyCTwN8R8cQ7yRrA0ng9Q/ybVkLUZXyr75kgaBWvC2hfTaY5SNN
Cn7Bfz/daY0WIJS4rbdGjEtWrhOHinJw63OC4r6IbjkQO/h6PDQXzW3ekAaln2Yh
/duTx3hNUDIQcBj8GKIaxQUZUdaCRWcfUT/6M5pgJ0sTYwOUKIjznM12/6WhPmfl
11RPo1mnwx2NMXFt/shIysJsS3ckqf7LT/aiM010zlLFzg4lZfbLUsWHq2gjppex
PdWbvcEhpkq+3I2Oi9Qx0RT/7ZY1u1ZwlaEXkc+yf4+sxLc5+sNWQH6+fAOk/46O
1t0WyhclG4O5ROHCg/p3B0Se7O7WK1EV4lRRTB1FQNp7D+LE4x1blp67ue5zhZH2
OvrLvkeYxMji0vfpszEIsPkxBjFR+Rq4qLNGO4csRiQ0Y7vWLDY=
=/azT
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
