From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [RFC 2/2] Page order diagnostics
Date: Sat, 17 Feb 2018 22:17:25 +0100
Message-ID: <20180217211725.GA9640@amd>
References: <20180216160110.641666320@linux.com>
 <20180216160121.583566579@linux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180216160121.583566579-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Mel Gorman <mel-wJa12IhQEiizQB+pC5nmwQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> @@ -1289,6 +1289,52 @@ const char * const vmstat_text[] =3D {
>  	"swap_ra",
>  	"swap_ra_hit",
>  #endif
> +#ifdef CONFIG_ORDER_STATS
> +	"order0_failure",
> +	"order1_failure",
> +	"order2_failure",
> +	"order3_failure",
> +	"order4_failure",
> +	"order5_failure",
> +	"order6_failure",
> +	"order7_failure",
> +	"order8_failure",
> +	"order9_failure",
> +	"order10_failure",
> +#ifdef CONFIG_FORCE_MAX_ZONEORDER
> +#if MAX_ORDER > 11
> +	"order11_failure"
> +#endif
> +#if MAX_ORDER > 12
> +	"order12_failure"
> +#endif
> +#if MAX_ORDER > 13
> +	"order13_failure"
> +#endif
> +#if MAX_ORDER > 14
> +	"order14_failure"
> +#endif
> +#if MAX_ORDER > 15
> +	"order15_failure"
> +#endif
> +#if MAX_ORDER > 16
> +	"order16_failure"
> +#endif
> +#if MAX_ORDER > 17
> +	"order17_failure"
> +#endif
> +#if MAX_ORDER > 18
> +	"order18_failure"
> +#endif
> +#if MAX_ORDER > 19
> +	"order19_failure"
> +#endif

I don't think this does what you want it to do. Commas are missing.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqIm+UACgkQMOfwapXb+vKJdQCdH7guQtlyHyWkIpEQCQp9Xb6j
wcMAoLef0VPOAoaaG2ac5C1EMuQU6hgD
=bP1b
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
