From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rxe_cfg: Fix parsing of ethtool / ifconfig
Date: Mon, 16 Oct 2017 07:50:54 +0300
Message-ID: <20171016045054.GZ2106@mtr-leonro.local>
References: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YBGzgpgHAney5ErF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YBGzgpgHAney5ErF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 11, 2017 at 01:00:24PM -0600, Nathan Hartwell wrote:
> rxe_cfg does not always parse the output of ethtool and ifconfig correctly.
>
> Fix two items:
> 1)  Parsing of ethtool's link speed field to always output a link speed.
> 2)  Parsing of ifconfig's IP address / MTU fields with newer builds of
> ifconfig that have a slightly different output format than in the
> past.

Can you please specify the version of ifconfig and OS?

Thanks

--YBGzgpgHAney5ErF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnkOq4ACgkQ5GN7iDZy
WKdrxxAAke6ouL5B93+35JiQ2gTaXX7ZEaOuaEwk3MCTjhl7kk5fG699szkYvjs9
esKtsvrwYkt7ho3TmJBbF3gMMx45WjlnhacvlIJ232kmoSGKj9d4mofr1VYSj/Go
Wj4hD70XKXooCRz/1poY+11sEa6o7N8mUyOx2zrc6egs0X0jFf6G4PASSK7ksNkE
ea4aZ0IYZ5Yh+WYRIbCSdc48yvIS46cVStWG2u1tX1U7A4zAvtTor4DfGEMrdKmU
I//G14tSXPqD8MQBFEWXPG/YijjsjHN9IuroBbReRxGjm7meheBbUh+6SouGLZkz
3kgZW6v48eKIvfw03S3gqrMqCUH9ZhZCjqVnHu2qZfoDDszonQDSyChN2prQLCUC
lMkyYHvQzJLxDDjdL4QrU/06Z8fhmy7O8MkRK3begjC9kgattE6oOPRxA6YZGVfV
JN3W8dLGe3aMgFZL78qKEUXv+0S7nPD9izVaFmBD4JUe/Zg7K7utw0OB7wEfU5gl
Ah3yzVes1Oizt8mzx1noVGHz/aT6DHv4ZfzyfVgPVxV7ApyJ8vbXuMb9E+35ILaQ
r9G6o45QVEuLG/WIQ0UJXN2L2HE0L5pn59iJ9Tk7sHaJvxquPsDQy1cmjGkj/ZgM
20j/vlRh76mbYYCcobupcdFhkt7HJLVLBgeF6s3tCq4Kf/C/p24=
=my86
-----END PGP SIGNATURE-----

--YBGzgpgHAney5ErF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
