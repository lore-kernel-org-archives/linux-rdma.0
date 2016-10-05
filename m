From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Remove macros I40IW_STAG_KEY_FROM_STAG and
 I40IW_STAG_INDEX_FROM_STAG
Date: Wed, 5 Oct 2016 15:57:11 +0300
Message-ID: <20161005125711.GG9282@leon.nu>
References: <1475668538-12914-1-git-send-email-thuth@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475668538-12914-1-git-send-email-thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 05, 2016 at 01:55:38PM +0200, Thomas Huth wrote:
> The macros I40IW_STAG_KEY_FROM_STAG and I40IW_STAG_INDEX_FROM_STAG are
> apparently bad - they are using the logical "&&" operation which
> does not make sense here. It should have been a bitwise "&" instead.
> Since the macros seem to be completely unused, let's simply remove
> them so that nobody accidentially uses them in the future. And while
> we're at it, also remove the unused macro I40IW_CREATE_STAG.
>
> Signed-off-by: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9PinAAoJEORje4g2clinhwEQAJWItkbQwx4di6J2EwcJC9qu
257q1Db7gIldf31DMjVnkhxs1qo31qGCHL7C/orQWkhqbX/jW8PFn3u3lNk6FL2N
8ZpFAQQm8WoUHeDOHo65VYYs2WyFNl/QAY/O/LBWmiWSMADcvPVry1AivVxCRcKz
kz6ykvdQsx2XMUFUgSIe9w9tvLheOAB33O3qZzmZ6DLXfEIdC8fYzXpqGM0E22Tq
mvnf3WG04jHA2icJZ1+6sgoXkecuXBiUHPmLL/Yq5QVRtKAEO15yAajfnN/I+gPk
v+NjG9Pj1Q/BM4LXd481wq4YedZ3GIXOK1lnXw/87glsaqXl0OfrYo1/H93N5qfW
xuBYJu0PEazQ/NSzJ1dOD/Wrn2sSznMZK22W4a+IhUrrcqXqARS1wOX1SsOUeqpJ
nMYrt9Ld8ZpdDCDOMxAhVElq0tRdT0YB4oInVSk0BBH8gZ4kqtQAmCK5iba5fKpN
7sJlb5wuRezjp7bC4eXG3GcSUQW6nVDSICxuXB0oxjdq8T5Kv4KPQpJIUKLmhurB
TF0SjeLuFFe7MeCbmaExSPpuosSnef7LZfMCBC19ipoJQ9Jv61OEBM4a5pcXy2rD
DIY6O7flbcJFBditb/jaFEMDJLzp0ngoHzNoU/NMYlWUjvZceepD6m+8fq2YAqze
hvrAEXouEoo1PyRdYS78
=tT1E
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
