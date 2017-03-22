From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Odd build failure in el7 mock
Date: Wed, 22 Mar 2017 21:11:37 +0200
Message-ID: <20170322191137.GL2079@mtr-leonro.local>
References: <16cf8400-4920-c7ae-e0e5-c77a65a71460@redhat.com>
 <20170322162245.GA18200@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oMMpwnf3aH5m/bW8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170322162245.GA18200-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--oMMpwnf3aH5m/bW8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 22, 2017 at 10:22:45AM -0600, Jason Gunthorpe wrote:
> On Wed, Mar 22, 2017 at 11:44:49AM -0400, Jarod Wilson wrote:
> > I'm attempting to build rdma-core v13 rpms... On my el7 host, they build
> > just fine. But when I try to build them in mock (using the epel-7-x86_64
> > target), I hit this:
> >
> > CMake Error at providers/mlx5/cmake_install.cmake:98 (FILE):
> >   file INSTALL cannot find
> >   "/builddir/build/BUILD/rdma-core-13/providers/mlx5/libmlx5-rdmav2.so".
>
> I am not sure why mock would be different, but that file should be a
> symlink, it is created during the initial run of cmake.

It works in docker too.

>
> It was added in this patch:
>
> commit 07764bc805ba8f50539a7b1e2655e86acbdb87ed
> Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Mon Jan 30 11:12:52 2017 +0200
>
>     mlx5: Export mlx5 direct verbs interface
>
>     Install direct verbs header file into /usr/include/infiniband/
>     folder and allow for possible users to explicitly include it
>     into their applications.
>
> And it is created by this call here:
>
> +  rdma_install_symlink("${DEST_LINK_PATH}" "${VERBS_PROVIDER_DIR}/lib${DEST}-rdmav2.so")
>
> Make sure there are no errors from the cmake step??
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oMMpwnf3aH5m/bW8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljSzGgACgkQ5GN7iDZy
WKfnZhAAyalq9yeRJ1F3p5DrWF5CM2m/f2tdxxti0BkcIrlmPWNgFIrXBeRsVhry
pzFoOrRTos4YOI4oLxL5wXQrVb0+uoEwZPOvqxJ2VccvOMstolOMlhYxF8oyvub4
2ke8g985zG3pspWYwI/UZ7Yd7nUdv3Crmo8zs3y6Wg/klURBs+5XruXssVNn4TRW
yiEhQPMZO4iVLF4MBFdONpbwNDf1wAVWJ8PcsX6HPQO9cnoeA8GvLT2BpXVtnpdC
Ow3a+Wb2vtluL1kzc4O3Lu4o/zzlzq1yvxCD0QwauKDcOcHfWQPi8jWZlN8KNHAw
Vle1Unm29K5+J9GmPXuB2EwXLJiKYUx8hJoGXNUW2OmNkAz0XOAJdym4iN9mzuh1
zqFDzSADIOQdmmdtUOEHibHqnFmnJoEtkjCoLdZXvf02wdsqJVf34dSJnLwTExRp
3ZctTOwHSSBne5ClKyPHy03FeHMUcDTrSqaKbB5mWBMcqXsSAZEiBJSvay8rBzjP
FX7Ww4wOZXxVXyMKSDlV/Fy8Y2CVcXRWBRzbHB9vR+zWfHWrS0oQjciE4MawZ4DL
S89POzDOGyhXGbKuL3hoVUf+eHmaX4deef3OMIQgj4LGraonIRJvkbjTv/eP0FUf
i0h/crqhi9qvo0vt5QbW6GC1hY9O/qAPpHpW9MG3sHh/DZW3k3c=
=XEEL
-----END PGP SIGNATURE-----

--oMMpwnf3aH5m/bW8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
