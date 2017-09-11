From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/uverbs: clean up INIT_UDATA() macro usage
Date: Mon, 11 Sep 2017 17:27:00 +0300
Message-ID: <20170911142700.GK3405@mtr-leonro.local>
References: <20170906213521.1845893-1-arnd@arndb.de>
 <20170906213521.1845893-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170906213521.1845893-2-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 06, 2017 at 11:34:26PM +0200, Arnd Bergmann wrote:
> After changing INIT_UDATA_BUF_OR_NULL() to an inline function,
> this does the same change to INIT_UDATA for consistency.
> I'm keeping it separate as this part is much larger and
> we wouldn't want to backport this to stable kernels if we
> ever want to address the gcc warnings by backporting the
> first patch.
>
> Again, using an inline function gives us better type
> safety here among other issues with macros. I'm using
> u64_to_user_ptr() to convert the user pointer to simplify
> the logic rather than adding lots of new type casts.
>
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs.h     |  22 +++---
>  drivers/infiniband/core/uverbs_cmd.c | 125 +++++++++++++++--------------------
>  2 files changed, 67 insertions(+), 80 deletions(-)
>

Thanks, for doing it and for spotting light on u64_to_user_ptr().

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm2nTQACgkQ5GN7iDZy
WKdweg/+PllqtmlvJxJJYlzLLYj3RdQvB/3epsle+4Dji724lJ/a93OK2W25xltN
kADLBjZDtMrsNOvUwN+KVf2+uQpJg6aT4QcgNzzo8EODAr7z61HVByofQAhEde9E
SxCbZFiijcMfLV9ybeEPJ9JSJHaEyaHQVoU/95fY5ukBuuvjcn4sbOOFBbCQ4um+
FyLavoh6s/VXSMzCT+n/TqajJxEbQFATaDuDaZQOpeWWd0YeXaWONt9gfk/tva/E
wVRv+EKkVojm98zMHcDVpdhtlq2HmRSf57fbyq3fACh2+wQcDIQKQUz0ZmB9cR3r
JTUovpSmzb1MnSX3/Oz09mcP7JMzyeJgX+i+FYJZ9UCVGUc6YCpGT0qb4KQNplpg
Hh1J8qauJIo6COQNbynKbYNIBnoNQ9FEv3U1fxbSvDdrQYfqHIHFPJvrybZdoy3M
MbOYt2w1m1G0bkwND2RIsifK3+5y8W13Dgo7ise80NE5JaFLO3FVRDVyjWJOk3DR
znkAzC2bQtAepUs7Zz2frVw4fyTGjau5So4rVMmrbuHrqMfCc20gco8P9vZcEjVH
FtX75N1vfMKFHqFQsLwMLhRgCFRrH0ueqpyrINwHYFAAMj9AROjtXC+lshSr3clr
GPzWnZzh0nHdWClnMAau30I14szFfEjku2aa3lSeUgnroBBOd1k=
=9/ue
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
