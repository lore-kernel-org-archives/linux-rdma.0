From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core make install is failing
Date: Thu, 6 Jul 2017 19:34:04 +0300
Message-ID: <20170706163404.GE1528@mtr-leonro.local>
References: <CAGxzWdAvjAgeiRsR0UvArC0L+n_PbiuNJfoDvkWzV0Y3hypSeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+d/sD+4Memv8CeGA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGxzWdAvjAgeiRsR0UvArC0L+n_PbiuNJfoDvkWzV0Y3hypSeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suman Debnath <suman.14san-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+d/sD+4Memv8CeGA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 06, 2017 at 08:58:04PM +0530, Suman Debnath wrote:
> Greetings Team:
>
>
>
> I was trying to install rdma-core, on CentOS 7.2(Kernel 4.9.28)
>
> I'm not sure what I'm doing wrong but make install is searching for
> "/root/software/rdma-core-master/build/lib/libbnxt_re-rdmav2.so".
>
> After running build.sh I ran make install and get this error, I also
> checked the build.sh didn=E2=80=99t create this library
> (libbnxt_re-rdmav2.so):
>
>
>
> >> snippet <<
>
>
>
> -- Up-to-date: /usr/local/include/infiniband/cm.h
>
> -- Up-to-date: /usr/local/include/infiniband/cm_abi.h
>
> -- Up-to-date: /usr/local/lib64/libibcm.so.1.0.15
>
> -- Up-to-date: /usr/local/lib64/libibcm.so.1
>
> -- Up-to-date: /usr/local/lib64/libibcm.so
>
> -- Up-to-date: /root/software/rdma-core-master/build/etc/libibverbs.d/bnx=
t_re.driver
>
> CMake Error at providers/bnxt_re/cmake_install.cmake:62 (FILE):
>
>   file INSTALL cannot find
>
>   "/root/software/rdma-core-master/build/lib/libbnxt_re-rdmav2.so".
>
> Call Stack (most recent call first):
>
>   cmake_install.cmake:47 (INCLUDE)
>
>
>
>
>
> make: *** [install] Error 1
>
>
>
>
>
> >> snippet <<
>
>
>
> [root@target1 build]# ls lib/lib*
>
> lib/libcxgb3-rdmav2.so      lib/libibacmp.so       lib/libibumad.so.3
>       lib/libipathverbs-rdmav2.so  lib/libmlx5-rdmav2.so
> lib/libnes-rdmav2.so     lib/librdmacm.so.1.0.15
>
> lib/libcxgb4-rdmav2.so      lib/libibcm.so
> lib/libibumad.so.3.0.15   lib/libmlx4-rdmav2.so        lib/libmlx5.so
>         lib/libocrdma-rdmav2.so  lib/librspreload.so
>
> lib/libhfi1verbs-rdmav2.so  lib/libibcm.so.1       lib/libibverbs.so
>       lib/libmlx4.so               lib/libmlx5.so.1
> lib/libqedr-rdmav2.so    lib/librxe-rdmav2.so
>
> lib/libhns-rdmav2.so        lib/libibcm.so.1.0.15  lib/libibverbs.so.1
>       lib/libmlx4.so.1             lib/libmlx5.so.1.1.15
> lib/librdmacm.so         lib/libvmw_pvrdma-rdmav2.so
>
> lib/libi40iw-rdmav2.so      lib/libibumad.so
> lib/libibverbs.so.1.1.15  lib/libmlx4.so.1.0.15
> lib/libmthca-rdmav2.so  lib/librdmacm.so.1
>
> [root@target1 build]#
>
> [root@target1 build]#
>
>
>
> Am I missing something?

Yes,

The build.sh script is intended for the easy development and it builds the
library in place. In order to install the library, you should follow
one the following options:
1. (Preferable) Build RPM packages by using buildlib/cbuild script.
2. Write your custom build.sh script with correct paths and -DIN_PLACE=3D0

The "make install" command is not supposed to work on the result from build=
=2Esh.

Thanks

>
>
>
> Thank you.
>
> Regards,
>
> Suman++
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+d/sD+4Memv8CeGA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlleZnwACgkQ5GN7iDZy
WKcxUw/9GeM5F7/DbAd3WVS/fWfSLETLE6IKCSxu2rCx5bgL0eGLwKPjk49y0bKT
p+QRbjrFiVVYvNPNtWRFpYGSA4fmztRdDqzBKmc6RhaoXcFqvS4TM2tZaF3sioYQ
Q3gea8WY/MEjiDcdS9+KZ0J1wftPDtGdzG1IM2W9z6LV57VBIDAUpHtI22zt2S5D
UNk44Mvl8M13XbWdVYo4X/0AseNHoB9dc48kDsVTE6236UMiHZSv/rAmRkXr8/88
i3hDJtppCRKfHrVYXTKLUWgUS14o9wiJtP9s2T0BQH3iLihFGe7k/eTcLvvrpyKv
CYSb4bDNmutDpVJkVgyBTYkpCTJ8V6D/7JP/KvXmYrhWxCss65nUpDR+5LUaFUvt
Ct+afzjiFYBiYE/t70GOw4cERrVX0/nRbLkZLu+zbF56b5MkeDp2N8lp39ltdT2r
3AiJ6Tuc1OXDvUY8cYcWL/+rxCS3VRKnh/xUxo0muxPYxETG9OdaroObTOXtd8vM
3Iq5NYYxQR/ePw08hea7kwBIJu1uHeYwspwhlrveEeHjn4/5ymVcdTyZ2cA+SY2t
Acn6NFUl9tDCbjMOTCLU5JYREucx+OzkS+ecRKbQd/UJDgGYp3Cectgcb/dMNysf
zvMPjRgcE4qwCDkFi6ZoTkjWKoLbefDOw+cUB2E9XQPxp/YmLeA=
=uD3+
-----END PGP SIGNATURE-----

--+d/sD+4Memv8CeGA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
