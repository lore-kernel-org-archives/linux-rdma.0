From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Mon, 13 Nov 2017 17:11:50 -0500
Message-ID: <1510611110.3735.50.camel@redhat.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VsObhdpZ1QerxfLv+2tG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-VsObhdpZ1QerxfLv+2tG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-11-08 at 11:57 +0200, Sagi Grimberg wrote:
> Comments and feedback is welcome.

=46rom what I gathered reading the feedback, there is still some concern
as to whether or not the design of this is ready to set in stone, so I'm
going to skip this series for this merge window.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-VsObhdpZ1QerxfLv+2tG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKGKYACgkQuCajMw5X
L93+Nw/6As8IYgKkOuLi4nGP9iF61RW6jOKsyFjCeG7UfB45HLyDkui3QL6heHDg
/LrLOWCQqdM1wD2zIOJKYEWFEaqF5wwrLxpAtAzySgc151jwa1I2cosoKxpcepkU
pv+WNgvP7Zxm0Fr4zTE41l3Z6Zwmbii86hh/r9nIFJTv7NGS8JtWsMOopqWTuCcn
+xRP+5kuHw+yIEKHkznWiSwQDfInP6LJkZuORMsBdQGnE58ng/5gNJL2n/gEEKvv
N39D7T15fKlm8QmNb0r/91kFBmBjaKZlGmi0mD7GDYRxvxd9UnBmrIuoUfcakpG4
uHHIZW/WlJnr1uyfeZhEk6MAmd59ZSg4k0qwX/pGUYVmJ6AyezgZMVVDuEHbOjxP
dmmvBZ5S63n7w0LhwebMmoZqG/MqVWsqeZfbfBtSOGkGwZrfF25HtaxSgEh3Lfkp
mmyPBMQpP6lqAahSqPGRUcBOwP5GEURD+a8Fd93pOwjk0hKRNl6GqLzqMCtcnXKA
B/Sd97N+exfHy5tpw8bs3kYjjybT/Yn8X7qvQegQhNm/j0jo5ftebD6982+FBR2Q
PZ0yBGy3+wpML3VuMZ2XRN75uLKCzXhNTzLqiWhHQCqRohhnfDdUSYQd3TZRZk/L
xeFp+RX9XAAUuY29WMDyx3Y/ZXiRzvvzRGZJM1tV6C1nbbaSlzY=
=UaLW
-----END PGP SIGNATURE-----

--=-VsObhdpZ1QerxfLv+2tG--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
