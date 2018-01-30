From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Reconnect on RDMA device reset
Date: Tue, 30 Jan 2018 12:24:56 -0500
Message-ID: <1517333096.27592.281.camel@redhat.com>
References: <CADZhsQqDFc1NWmsihOwki8_2Zj0HuYKC_N_x0jMnCtU9Rww1UA@mail.gmail.com>
         <f0a14240-1566-1bae-1b9f-21880bc3f3a0@grimberg.me>
         <CADZhsQqvK0LMd9sfxzz+x_5qVnoi4FP0FCFMsTPjpeXyqfXKew@mail.gmail.com>
         <77cef33e-a563-97fc-7ba6-69f220f1be84@grimberg.me>
         <1516904022.27592.187.camel@redhat.com>
         <26056a83-2f81-6b56-7bbf-fcecfc4518d6@grimberg.me>
         <1517264899.27592.277.camel@redhat.com>
         <CADZhsQpWXQQ2dKxAorGMhk7HFvqoQ2Y5LxVKt66XjkcUbEuXpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-DuloOnT5pRviJPQFfjVg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADZhsQpWXQQ2dKxAorGMhk7HFvqoQ2Y5LxVKt66XjkcUbEuXpA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Duer <oren.duer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-DuloOnT5pRviJPQFfjVg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-30 at 17:03 +0200, Oren Duer wrote:
> Not sure why we need to keep track whether it is the same device or not.
> I fail to understand why we trust the system admin to create the connecti=
ons
> at the beginning, but we should not trust him anymore if the device was
> removed, a new device was added in place of it, and it was configured wit=
h the
> same network IP/subnet. To me it looks like the admin wanted exactly that=
:
> for the connections to be restored over the new device.

In my original email, I pointed out that I didn't know how the NVMe over
Fabrics was doing addressing.  If it were like SRP, then it wouldn't
work because the device GUID is part of the addressing scheme, so a new
device wouldn't automatically show as matching that address.  If,
however, you use IP like iSER, then yes, I agree fully you can just test
the ability to route over the new device using the IP address and
restore if it works.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-DuloOnT5pRviJPQFfjVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpwqmgACgkQuCajMw5X
L90yyQ//TmMaOY88J99fcbjqmLLCh2kIDz6nAiTeMNVSediNmKZPnqX3GX89fJRp
JHugc2RmRp4vcKSK5Mwp4z32q0BV8tNQz0iKrPrIr/+maqbpt+8sQFdh469psCYX
HYnjtur0dDkyk4kvkW5X2/cEoyuNdXV0GJIvU9v598lM/YhK9zwMT/4hzppU4q+S
rCtKkxM1r6qHgGcFsgNL1VJqk0jiAxiUa4MzKka+BFaMSmgbDttEKbm6RPgdcFOq
1SgsESe+q0da/1PckCczoajr6bXZjPP9xAfGiSfqAzIg08kdXj6pFcmuFwDKFhy3
VyXTRRlDjrXOUjUByojngkmBzjwsy5MsyC1GRMq4OyyEymU2LCqJbyxKh+E073vb
WJAvYsGJYBh26XlcyZETRLkd73hFLua6qRYVya1VhA/vAPiPoJhVzjvqh7KPoA7L
D+i/KwlWWy4V77O1ERVmRNlx7tCwHSWo/4S2TZdtNZadkBAyhJY8qTosBrm4hHlx
uBIKitt/h3Q20MQruMNCcDDcWixnQDfH6IxFoKA5XsEMVsdL5hkVE7FltRIBUCzF
4M+R9YXYb5qN82gbkBtm43JNtmbgQ76cdBGSlBXmH7eJ30UIHIFJYr6es0gQlQlj
pNvRFib2wdi9tedjZgAA7oEKjonywJXnBIl0HhDwuqADWmLrgxE=
=yr5E
-----END PGP SIGNATURE-----

--=-DuloOnT5pRviJPQFfjVg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
