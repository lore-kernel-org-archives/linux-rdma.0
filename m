From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/hfi1: Using kfree_rcu() to simplify the code
Date: Mon, 22 Aug 2016 14:19:37 -0400
Message-ID: <574a60cf-5519-1086-46d3-99b8d8123797@redhat.com>
References: <1470649818-30040-1-git-send-email-weiyj.lk@gmail.com>
 <1470798844-30421-1-git-send-email-weiyj.lk@gmail.com>
 <32E1700B9017364D9B60AED9960492BC2D09FEB9@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C5L1X5kgEH3bjxcg97DwfkBlTb6JgmT7s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2D09FEB9-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C5L1X5kgEH3bjxcg97DwfkBlTb6JgmT7s
Content-Type: multipart/mixed; boundary="ocMtAkqwkcscuX7fUAdhWLOhCGTuhQ05f"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <574a60cf-5519-1086-46d3-99b8d8123797-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/hfi1: Using kfree_rcu() to simplify the code
References: <1470649818-30040-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <1470798844-30421-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <32E1700B9017364D9B60AED9960492BC2D09FEB9-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2D09FEB9-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>

--ocMtAkqwkcscuX7fUAdhWLOhCGTuhQ05f
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/10/2016 10:56 AM, Marciniszyn, Mike wrote:
>> From: Wei Yongjun [mailto:weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Subject: [PATCH v2] IB/hfi1: Using kfree_rcu() to simplify the code
>>
>> The callback function of call_rcu() just calls a kfree(), so we can us=
e
>> kfree_rcu() instead of call_rcu() + callback function.
>>
>> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Tested-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Acked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--ocMtAkqwkcscuX7fUAdhWLOhCGTuhQ05f--

--C5L1X5kgEH3bjxcg97DwfkBlTb6JgmT7s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0I5AAoJELgmozMOVy/dvKIQALpAeTidJy/tn69219cENQfV
nL/IUftGPSlQHxY21iNtAmuk1ureqQiWIU18KzDsxc4nFW1fYy9UZoWa9GlDN6ck
9qI30rAAykzk2+O0GZKhR31R0/jVxLc0hk2EZQFKl6IwFhJoieGJ66K/6aojMC0N
NhHAIrMgdHXmboR1AA2OKLyS03NhNO3IOd3Si4OMaKUgmAJx0X9piWgDZd0KoL+/
ukfQo5iCQ9CjHrXU00axG6aZPuWe/2QMT91LYiL4/iexfhDcNIDpftR5THS+KCeJ
jmB3EtvLnTAwP5qvMWACQUdQe/RuXXVTlOGCJeO8PT/8GyrK/xi2afp/sFxpG/KC
lsxJHZOAKidAfl93/OWKij5PZDJwTvoTGWHwguv7fHbd06SgNXoUhZ9TdxtiREMR
4lEWD7SzqTjdGWPYV2VtLP0eECCHj9aUxUU/ftGTScJ5kEVDyDmMrxL4IB0heHEe
B52fz18G0Ol60AkL0TP5N+HdRdSw3hQRCIc8bDKd662yjH6/AnOQUALBIoibNX7F
WbR+U8iHxV1IIagjU4/6V8O8jVb23K52Hr6wCHqInHHOYab2gnvi6jcItFPTpNwa
DYGWzC3galikviDES6/tD1any51xdmQBEUkgTaetY1P1kFfq432KWGy7QcTap6v/
NNpogBfSvEtEF6THmHn9
=xoe0
-----END PGP SIGNATURE-----

--C5L1X5kgEH3bjxcg97DwfkBlTb6JgmT7s--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
