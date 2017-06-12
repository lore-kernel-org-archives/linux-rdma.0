From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/5] Hardware tag matching
Date: Mon, 12 Jun 2017 13:46:00 +0300
Message-ID: <20170612104600.GA2576@mtr-leonro.local>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <20170612074055.GA24879@infradead.org>
 <628acd1f-7502-be87-df2e-48475f34fdd8@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <628acd1f-7502-be87-df2e-48475f34fdd8-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2017 at 12:41:12PM +0300, Artemy Kovalyov wrote:
> On 12/06/2017 10:40, Christoph Hellwig wrote:
> > Artem, what firmware version / what specific hardware do I need for
> > this?  I've been working on prototyping a simpler subset of this
> > (1:1 tag matching) for use in NVMe or NFS over RDMA, so I'd like to
> > play around with your code to see if it matches my use case as well.
>
> Christoph, here is Contect-X5 firmware with Tag matching support:
>  http://www.mellanox.com/page/firmware_table_ConnectX5IB

Latest available FW for ConnectX-5 supports Tag Matching.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk+cOcACgkQ5GN7iDZy
WKeObQ//ZDaqWLikImz1pHQ7pKM9bRCKKer7zSAZkFoTEtlzFQ4F/lYoL/g9CQmH
eJMQXjdKY9vxqB9bgkKZMifuULZSLaINDfBobH+Nyu4Xr44Xw3Bgc8Yboxr1P7dj
s0zVJAgYseD6ORZ4Pbf7x+rk4D8AVGBfXhGUWAQxmCz9JcTqqPgpOERIK3sLom1x
Cv211ZbvGmFGF9SBiNg/UPxLxp7/jDk4urkYwn1uKDwDG/+hagAw6FmJQKPYdCo1
vaS1re6Ms9dPnd9WXlkzklMwD1Ow2DJtbYgHH6pAfjpqr4byPKIuhrLydWh6Cyh/
9jRV7vA/JcuEMtiQO8rcgdLgjF/QU0hqDHUPbvDdmdaoqEv/0QXuUwDb2yDJn/qo
mRWLA18vQR3Mp9bVhuXJVZ1vONXK323kYmIFZsFYyk9JcgqyILNllku1PaEDTEP9
Z93iFR9u6BtQ+h9l0HeO6rHh3mst/5PcgfoA7pc8RoDvxMzdXIIIRQTjfcjMjSuX
HKPMjJsDT/si92NZClP2XGQBec594w8aJXSQaKMpqfGBJxU+XdAbZKTqG8IlDhjE
ZooB5AKtF4HiX/ouglllR8ylEZxPmOceKmgSaJAMwfLxbxLGiNxtlkOqVySWZALk
sa9/oN5m3XsCEOZYde55HuTuSGPI9HxDBhdpRXz3mN5/LTMDLZI=
=EB2H
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
