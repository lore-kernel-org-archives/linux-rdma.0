From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] RDMA/core: make ib_device.add method optional
Date: Thu, 6 Jul 2017 11:33:01 +0300
Message-ID: <20170706083301.GS1528@mtr-leonro.local>
References: <1498983652-18250-1-git-send-email-sagi@grimberg.me>
 <1498983652-18250-2-git-send-email-sagi@grimberg.me>
 <14303999-2479-653c-719f-ac5a5b03fb33@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vJI8q/aziP9idhqk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14303999-2479-653c-719f-ac5a5b03fb33-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vJI8q/aziP9idhqk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 06, 2017 at 10:51:36AM +0300, Sagi Grimberg wrote:
> > ib_clients can indeed fill .add to NULL, but then they will not see
> > any device removal notifications. The reason is that that
> > ib_register_client and ib_register_device checked existence of .add
> > before adding the creating a corresponding client_data and adding
> > it to the list. Simple condition reverse fixes the issue.
> >
> > Reviewed-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> > Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>
> Any RDMA folks?

It looks right and two gentlemen above already reviewed it.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--vJI8q/aziP9idhqk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlld9b0ACgkQ5GN7iDZy
WKfvKA//STiWSf4vl0iC2BnDV2DqPnjwKDu8mL/Ef1Ihj9ZVBUfzdbe+figXwjG9
5Waq98c356MHa+/gj68qtgUbZf4qu78O01+ZDZpe/t7LvEGFKQ0HEJ0jaFeAgIF+
H49LTeOMUURQbiD7aik8LbwXkL+MdLZSkpLBmA+xhznz1WNFRP11UqzXkk+a6ICa
fu13gTCsVAtZ8JFshKCbbmu0J0tmKGvySOnJxVWVrgdn+W9jhaqNIQIkfhBgUHbq
jZdMg0L6xqhwnyN48DPJ/f1OzNDsNzfcGXEF3hZmL4gulZC0dh9UgmxOSeWwJdzE
4s8OAtF8IW+LWP48HCvH+4br30SWTg4zK0tglSkP9arbeEEHnGh5FUNNuhxfzx4P
a3yDyk/s4heM1gI7Bo71b5wIzKQD8keyhyKwgRuhSErAjfhVVB63r7nsPt04C7eS
cJ64JyT45uA//aUVo9Sy7U06r2HVGAhLw8+Pm6D6AVH4cupGFU0+bSwLJBc+OJa0
p3X6kbwheBlISBcFGwPJOizrKQcbGjek5RenIpmAnA7tbIPZFpGcIGOcZkqE/t10
OYV4Nv5VGVUwMiqubcZ5vB0a2mZNSf/Zo/A7SQp0N0xetPaEW0mrO4ckiSpf/uL1
jzQ0Nh3mUFn2dPTuVv+xrBdzEYzTmZ/NkWoTTpuF5I1+m9gSOHQ=
=I3oT
-----END PGP SIGNATURE-----

--vJI8q/aziP9idhqk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
