From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 21:47:59 +0200
Message-ID: <20170207194759.GU6005@mtr-leonro.local>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
 <20170207171145.GB1077@obsidianresearch.com>
 <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
 <20170207172752.GA12315@obsidianresearch.com>
 <20170207180642.GQ6005@mtr-leonro.local>
 <20170207181814.GA13368@obsidianresearch.com>
 <20170207183538.GT6005@mtr-leonro.local>
 <20170207184206.GA14102@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fzxPtQiUsqZaJiu9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207184206.GA14102-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--fzxPtQiUsqZaJiu9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 11:42:06AM -0700, Jason Gunthorpe wrote:
> On Tue, Feb 07, 2017 at 08:35:38PM +0200, Leon Romanovsky wrote:
> > I made it (rdma_shared_provider function), but have a very hard time
> > to properly create ".." symlink, because during the build (in place too)
> > the output is placed in build/lib in flat structure and symlinks need to
> > be without "..". But during installation phase, these symlinks should
> > be changed to ".." and it doesn't work for me in automatic way :(
>
> For symlinks build/ and installed are two different flows, they don't intermix
>
> Compile the library to build/lib/libibverbs-dv-mlx5.so.1.0.13
> and setup a symlink build/lib/libmlx5-rdmav2.so -> libibverbs-dv-mlx5.so.1.0.13

Just as a note, I'm calling it libmlx5 and not libibverbs-dv-mlx5.

>
> For install, use realpath like this:
>
>  execute_process(COMMAND "realpath --relative-to ${VERBS_PROVIDER_DIR} ${CMAKE_INSTALL_LIBDIR}/libmlx5.so.1.0.13" OUTPUT_VARIBALE LINK_PATH)

It doesn't work for me :(
-- verbs_provder_dir = /usr/lib64/libibverbs
-- install_libdir = /usr/lib64
-- link_path =

lrwxrwxrwx 1 root root     18 Feb  7 21:43 /lib64/libibverbs/libmlx5-rdmav2.so -> /libmlx5.so.1.0.13
lrwxrwxrwx 1 root root     10 Feb  7 21:43 /lib64/libmlx5-rdmav2.so -> libmlx5.so
lrwxrwxrwx 1 root root     12 Feb  7 21:43 /lib64/libmlx5.so -> libmlx5.so.1
lrwxrwxrwx 1 root root     17 Feb  7 21:43 /lib64/libmlx5.so.1 -> libmlx5.so.1.0.13
-rwxr-xr-x 1 root root 666637 Feb  7 21:43 /lib64/libmlx5.so.1.0.13
lrwxrwxrwx 1 root root     18 Feb  7 21:43 /usr/lib64/libibverbs/libmlx5-rdmav2.so -> /libmlx5.so.1.0.13
lrwxrwxrwx 1 root root     10 Feb  7 21:43 /usr/lib64/libmlx5-rdmav2.so -> libmlx5.so
lrwxrwxrwx 1 root root     12 Feb  7 21:43 /usr/lib64/libmlx5.so -> libmlx5.so.1
lrwxrwxrwx 1 root root     17 Feb  7 21:43 /usr/lib64/libmlx5.so.1 -> libmlx5.so.1.0.13
-rwxr-xr-x 1 root root 666637 Feb  7 21:43 /usr/lib64/libmlx5.so.1.0.13


>  rdma_install_symlink("${LINK_PATH}/libibverbs-dv-mlx5.so.1.0.13" "${VERBS_PROVIDER_DIR}/libmlx5-rdmav2.so")
>
> The rdma_install_symlink helper takes care of the install step.
>
> Jason

--fzxPtQiUsqZaJiu9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliaJG4ACgkQ5GN7iDZy
WKdt4w/9FrePtUI7HqS53X7eY6B+Oktmk8xFlMAc/MZ6I0nyWEyPHeYGbT+g/C5+
OKp1qVuSq7/fMQZSjBFeUtf+uD2p+PyWmlRCXm5ELzP+3d4y2OSy0R1H5Kbn7gZk
xsAJOD+RDZXuxqrxBIo0CfC+1IS9zSpXYapoyfeexE1xJl4Y5O+tAKE85+qhts53
17bHaf+cdNmGbDedem3HYztIvQrVbQTqYv3Q5s0AVyxFwKy4fPnk926t/MrGtQ6t
xDdCYQ+wOmTZkvU9UYCMBAybNHoM9gLVAAvHnHL8QjxSHF7E+G8SksxsTRvw7+uP
cA7hmEODMIb48vaueYiZxeIxv0+Dv44Dbwj8lkB7UY7G+lMhybcgP/xHwyGBIrHZ
tLs0kKh4kOVrWF+Sm3zPZWWaPV1R/UnvuOvjRgwrBVniua4gj7G9GcFZyq0su3Wg
SeJSJffZ8Wn+Ylf94zv6bEmdfmww9ge1L4gH5GfLmwVmnl89HuUd9y28jt4vwoKW
EBm5Mlx8ruKFD0aOzCJQOT3EqGqt+60iDneVDyuNgItxsWd/N9dt2rp8di2o3fZl
sdf+C3UduubntU9A0NdEkpdJcaddQXZTcgg99vBwiN+CmwZnh4oRfUkHWwKPIflP
kMgHFivXf3cMEmLX0+kCDl9kWA9gaq66PAdqV4EdFxhcksflBy8=
=umcM
-----END PGP SIGNATURE-----

--fzxPtQiUsqZaJiu9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
