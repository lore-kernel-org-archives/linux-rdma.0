From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] add a build.sh helper to allow for a one-stop build
Date: Wed, 12 Oct 2016 12:30:15 +0300
Message-ID: <20161012093015.GS9282@leon.nu>
References: <1476113282-19194-1-git-send-email-hch@lst.de>
 <c2d80cd4-74b8-8391-1855-3c666f611d91@acm.org>
 <20161010155949.GA20091@lst.de>
 <ec4f3158-a25d-7cd8-216c-fbec52577e75@acm.org>
 <20161010164758.GB1796@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8bIXokQePRfDuBGo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161010164758.GB1796-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8bIXokQePRfDuBGo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 10, 2016 at 10:47:58AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 10, 2016 at 09:17:11AM -0700, Bart Van Assche wrote:
> > On 10/10/16 08:59, Christoph Hellwig wrote:
> > >On Mon, Oct 10, 2016 at 08:56:33AM -0700, Bart Van Assche wrote:
> > >>Have you considered to make this script stop immediately if one of the
> > >>steps fails, e.g. as follows?
> > >
> > >How about just ading a
> > >
> > >set -e
> > >
> > >to the beginning to get this automatically?
> >
> > That would also work. But if there is a space anywhere in the path in which
> > the rdma-core repository exists, mkdir $BUILDDIR will have to be changed
> > into mkdir "$BUILDDIR".
>
> Is this OK?
>
> From 6362ec4c1ddec0f6b2a1bf052cdfde63cbf73d90 Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: Mon, 10 Oct 2016 10:46:47 -0600
> Subject: [PATCH] Add a build.sh helper to allow for a one-stop build
>
> This allows for a quick build instead of typing the whole mkdir, cd,
> cmake and ninja sequence.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  README.md | 17 +----------------
>  build.sh  | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 16 deletions(-)
>  create mode 100755 build.sh
>
> diff --git a/README.md b/README.md
> index 98ec5a7d695f..66aee3f49f00 100644
> --- a/README.md
> +++ b/README.md
> @@ -36,10 +36,7 @@ Additional service daemons are provided for:
>  This project uses a cmake based build system. Quick start:
>
>  ```sh
> -$ mkdir build
> -$ cd build
> -$ cmake -GNinja ..
> -$ ninja
> +$ bash build.sh
>  ```
>
>  *build/bin* will contain the sample programs and *build/lib* will contain the
> @@ -76,16 +73,6 @@ Install required packages:
>  $ yum install cmake gcc libnl3-devel make pkgconfig valgrind-devel
>  ```
>
> -For end users, the package can be built using GNU Make and the old cmake
> -included with the distro:
> -
> -```sh
> -$ mkdir build
> -$ cd build
> -$ cmake  ..
> -$ make
> -```
> -
>  Developers are suggested to install more modern tooling for the best experience.
>
>  ```sh
> @@ -96,8 +83,6 @@ $ unzip ninja-linux.zip
>  $ install -m755 ninja /usr/local/bin/ninja
>  ```
>
> -Use the 'cmake3' program in place of `cmake` in the above instructions.
> -
>  # Reporting bugs
>
>  Bugs should be reported to the <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> mailing list
> diff --git a/build.sh b/build.sh
> new file mode 100755
> index 000000000000..76205e6af921
> --- /dev/null
> +++ b/build.sh
> @@ -0,0 +1,33 @@
> +#!/bin/bash
> +set -e
> +
> +SRCDIR=`dirname $0`
> +BUILDDIR="$SRCDIR/build"
> +
> +if [ ! -d "$BUILDDIR" ]; then
> +    mkdir "$BUILDDIR"
> +fi

What do you think about following code, instead of 3 lines above?

+ mkdir -p "$BUILDDIR"

--8bIXokQePRfDuBGo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/gKnAAoJEORje4g2clint6MQAIxCyKY1M0lNmtKVuuG9M0eZ
CeGp7uVxcz4Djva9lzRNbP0TKLP97/SIf5YdAlqGHnjO6AX1/I7UBUdft/ha/6fX
jTib5rYbZ1zvefOtT8ggH1A8Ueyq1lCGt3y3LOlalzy2lrYiQDjgAOz/GW1zQQfL
DNuZNDDhqraLavNVnHJ7TIFMnloPsO7TTy+RLjAplCdU2c/399K63UrbDMxU7FKh
y8SsN7iazn/AsyCuqImRMnVA/HKOOBynUGFKzraXnSZZODKUmmoxhUVSf4zFFwrY
2iFxGacNGaZWtIksQRGhyMfLfHMvft03Wj8tzl8JrJg0x+e85CLCUR6rChVUs/Wk
q3IQblQdBRX+F0Vw3fGwwc9I3d+6AtVwnMMRT31i9Udiiy3LqCL2SZRsevSUpzuj
uczj+pD1ZzrlD4BVavQOWk6rhGiymMj9wRJeag0ERdyQX9EOPwj58zwkP3yUornO
Uxzn3wrItnDyvIe7cZar02EI9el2XeIkKha207WSRMwXJYd56CLOYmR2KR1/kar+
JJIuiwUBhejYHtJJYCK8HnyALhNXsSJ62TdDCc8dQ62B/TzQKTrPqdhU86dG6/2i
sYTlisS8HWvsO+jzIwOEouxjeFobpv/G8x9s1rRId+wlBQiyq2Pm7qb1JaAwAnfH
FewfXfn66F45FfxR9MWK
=JbEM
-----END PGP SIGNATURE-----

--8bIXokQePRfDuBGo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
