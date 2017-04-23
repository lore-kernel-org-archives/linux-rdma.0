From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
Date: Sun, 23 Apr 2017 15:12:54 +0300
Message-ID: <20170423121254.GD14088@mtr-leonro.local>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
 <1492101079.5176.9.camel@sandisk.com>
 <c52b5ce7-5346-419d-26f2-0d4d45d20471@grimberg.me>
 <20170423103439.GC14088@mtr-leonro.local>
 <d697d360-99ca-c3ed-08e2-b89cc50a15b0@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RUvhGz2nhX7DIu1B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d697d360-99ca-c3ed-08e2-b89cc50a15b0-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--RUvhGz2nhX7DIu1B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 23, 2017 at 02:49:43PM +0300, Sagi Grimberg wrote:
>
> > > I'm concerned about the fact that the SRP issue wasn't resolved. There
> > > might be a bug hiding there.
> > >
> > > Max, Leon, my recollection was that the error syndrome you saw with SRP
> > > described "too much sgls for a single mr". If this is true, then I still
> > > think we need a different device capability for it.
> >
> > I don't remember that Max succeeded to reproduce it.
>
> You said Artemy was on this issue:
> https://www.spinics.net/lists/linux-rdma/msg46390.html
>

At the end, he proposed unrelated fix.

> and I asked you a question that will help clear things up but
> never received an answer:
> https://www.spinics.net/lists/linux-rdma/msg46394.html

i asked and didn't get answer too.
https://www.spinics.net/lists/linux-rdma/msg46407.html

Thanks


> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--RUvhGz2nhX7DIu1B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj8mkYACgkQ5GN7iDZy
WKeKyg/+Mffr93Uh2PV9BXYxPZnYZSSzGMjez1HYLRSdWuMEIPdqduobUjlkjIe4
eBHpMdTPhFRdzaNq8yKxq201UYptlH1UmUNN89kiBCKJUyb7or6Ce9BDryYMfNHh
VGNDTMSDEyjF24G5M54Grz65E42kCYYghiKQCoSlbCRb4QXMXbCosE1+1qaBl4UW
DVJUbx8gRPDO65Gv4F8JQ7gplaWqh2ySAkMMPz7D3xb9A5Z9GeRGF/N340DcQ87F
R0QpPqs6+l2XbKV6l+8fv/BiGa6Yb6tY9VcdaL1pmedU3HZC+0ceKBVBbmlEBAkZ
Z4QU+/PRPtRKKiFMUqAoYU6PCMj3fOLmDrnK//HNZ5mhqH01TnPQOMoVrYm/8ORd
VEF4qImp9pZ5CZ4amomVbaLHFs2RAyVv0RhZpcJc0HLXfCHLZbm4aP7VaymSwHcd
YfkbCInR9RQM3w/K/07zSMrl6CInzS03FNJfErOKtbvl/Ha+YA54nJpTU5/rXVCn
BT7gjn5AFkpvV5E/rO67vu3qkeIjBYVOWNCmFn1T/FxJwYBtfdcXsoRbAaixXHGg
6lly7N8ojPNfkH84ZFR6VhRHVgJT27KcacafFfZtG80ngcr3yvnidiwFon3GGRpN
vdkw2CrImvo815wTUIXTOO8t2cjT7eVOfPq8XjudczSH7Bar2ZU=
=sJIX
-----END PGP SIGNATURE-----

--RUvhGz2nhX7DIu1B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
