From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA: Remove kernel private defines and
 reference to header from UAPI
Date: Wed, 8 Feb 2017 12:00:43 +0200
Message-ID: <20170208100043.GC6005@mtr-leonro.local>
References: <20170207174600.27218-1-leon@kernel.org>
 <20170208082850.GA11087@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8r7XanZh5e+04UYw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208082850.GA11087-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8r7XanZh5e+04UYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 12:28:50AM -0800, Christoph Hellwig wrote:
> >  #include <linux/types.h>
> > -#include <rdma/ib_verbs.h>
> >
> >  /*
> >   * Increment this value if any changes that break userspace ABI
> > @@ -548,11 +547,11 @@ enum {
> >  };
> >
> >  enum {
> > -	IB_USER_LEGACY_LAST_QP_ATTR_MASK = IB_QP_DEST_QPN
> > +	IB_USER_LEGACY_LAST_QP_ATTR_MASK = 1ULL << 20,
> >  };
> >
> >  enum {
> > -	IB_USER_LAST_QP_ATTR_MASK = IB_QP_RATE_LIMIT
> > +	IB_USER_LAST_QP_ATTR_MASK = 1ULL << 25,
>
> I disagree with the upendcoding.  These constant should be moved to
> the user verbs header instead.

These constants are part of much larger enum ib_qp_attr_mask. IMHO copy
two values from that enum isn't good, but copy whole enum (mostly not
needed for the users) is bad either. So I decided to open code it as a fix
for -rc7.

Thanks

--8r7XanZh5e+04UYw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlia7EkACgkQ5GN7iDZy
WKdQ9A//WdHtgj8kKZnj69OBVz39r7nnuR+KT1K5NhiNaXr6pepeM2Y021sPzouw
haNXqnlaL9kabxjd4EapGmTbUBM3i1KsMPXiKoccHzThmj+ERG63t3xP0zyFIoI+
9Y2l1b1uyTJTwh9VjPq6uL1EbsK6SREupPJpY8zE89MFGSfyZ/v1Fv41MT96+wLO
3/PfjT3MJKgq+NMo96vnY2Ha1XkZQh77RcGDoSshwoDeSRZdF2JVPGsLGXDwbR07
Z2DUi8j/RT9ufDou7QngTOZxH70WxtLieZZQmA9D9IrUliwO0XPAS2vbWe/gUE5n
uLSqXjT36Prxla2tkHO6dnElrcjSP09q+kJxl7TMUVVSUX5J10cBNhxfzH3AevYP
FA5XrcgxVHYiav6b4/sjP1RrmIC7eiLZqVfHNA02JrliabZrSHoD5SNrDx3zvUE7
3JOvxHfqfixO4cQr0H87MLPeCn3gQ4anVP3Ni/iH0K8QQulCA9E/E0UBB7bqqZiz
k/D2pN+AX+ht8LqwzRmPel1if8XtcpYwh7FEFuRJhsPBklXU4HnTL2xCmUSx3uoo
4mKcPaANQwYhXjWwbqczhWP9D8uCibCLewoVh40yBj7nnGZIXzLmTjlXtE9GWWVW
fWohzkDWb3oeBqYB6AHysj7V9KlVpe8UnFOlzum7EPcxxqNrca4=
=Iew+
-----END PGP SIGNATURE-----

--8r7XanZh5e+04UYw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
