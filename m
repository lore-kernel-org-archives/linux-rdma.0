From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Fix remaining Debian build failures
Date: Mon, 20 Nov 2017 10:33:12 +0200
Message-ID: <20171120083312.GE18825@mtr-leonro.local>
References: <20171116163246.29736-1-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LRGBJGUSW9Vdlukj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171116163246.29736-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--LRGBJGUSW9Vdlukj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 16, 2017 at 05:32:43PM +0100, Benjamin Drung wrote:
> Fix the remaining build failures on
> https://buildd.debian.org/status/package.php?p=rdma-core and the Travis CI
> build failure.
>
> Benjamin Drung (3):
>   debian: Include architecture.mk for DEB_HOST_ARCH definition
>   debian: Add alpha, hppa, sh4 as non-coherent DMA archs
>   debian: Do not require valgrind on x32
>

Thanks, applied.

--LRGBJGUSW9Vdlukj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloSk0gACgkQ5GN7iDZy
WKclPBAAurS3g0OKSOsfgj5JbgtYfodqpFHK1NrYbuJGmplFYxVAn3TlTthwuAbn
qbRWb0rpsYgqXV+9xv9vANyvUFWV7YjNiC4jWsO+KD7Iwhz4fHaIO189CHS+wD7H
cx9iKCuzjZ+b9yBDOpqZETdVVMWC5sc8d85xlcGS6VWSTunwoXroLZVDBc908gEx
Ick4Om+Zxx9oyezyBD6MvoIhyfiZpLCWr3JyfopHoBK2zt4FJhlc7gXjR+cC1ePj
Vlyg4+XwhM84ATSfARkwZBsezCgz+X+xkYfwCNmnsnEp7xoTz3ebTPt9HA1jCcy4
ZafvMGlpojA2o12dX0ssSxiAmvRqg1RiKqHIfYe/bQGhfTj8+3QY9DcPkZeyyKlh
spAis9FqFTliGXWZgKsMgeKIIuoaY11q6TMCzrFGfAyUT4N1pGmZy8tz2PlBbgx6
GIuyxAHZmNNKjjZZd2t0onFbQSNgx5NOaN9Dv/HxeJlycah5MGHvAWA9GgrEnALP
lbA08wJYYkGFdIPiRfA/De+FvuDVdnd1+PF20mvtN6EIwkwXvlvq4K1RxPJjb3Sk
N5KhAlpJizWvtyHeT2y1NpBMos1JI59bUeUy6yUYbPEHApZx1Yx+Fvh8lngJJoZi
CTdyJOWMS00I+tcvD8/ZoLKgJXJ0XJ5bzQb2rOh1vSNW7ofZ97k=
=ZTi8
-----END PGP SIGNATURE-----

--LRGBJGUSW9Vdlukj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
