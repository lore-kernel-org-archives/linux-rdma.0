From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
Date: Mon, 6 Jun 2016 19:59:59 -0400
Message-ID: <42668994-5666-f5b3-8d38-4c452f0cc70f@redhat.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-3-git-send-email-leon@kernel.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JXfuel8l1PMhE7LaSGGjmrkJkIEnDVwe4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JXfuel8l1PMhE7LaSGGjmrkJkIEnDVwe4
Content-Type: multipart/mixed; boundary="3pha6cGNAAgDVxOATKEfFwdfO1bAX0kv7"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <42668994-5666-f5b3-8d38-4c452f0cc70f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
References: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1465042524-25852-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--3pha6cGNAAgDVxOATKEfFwdfO1bAX0kv7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/5/2016 5:10 PM, Or Gerlitz wrote:

>> -                       neigh->alive =3D jiffies;
>> +
>> +                       if (likely(skb_queue_len(&neigh->queue) < IPOI=
B_MAX_PATH_REC_QUEUE))
>> +                               neigh->alive =3D jiffies;
>=20
> why testing the queue len makes things right?

I'm with Or on this one.  This test doesn't make sense unless you assume
that the neighbor is being hit with a steady stream of packets.  If
someone just runs ping -c 1 to a dead neighbor, this test will fail.
The idea of the patch is OK, but the test needs to be reworked for
situations other than a blasting stream of data.



--3pha6cGNAAgDVxOATKEfFwdfO1bAX0kv7--

--JXfuel8l1PMhE7LaSGGjmrkJkIEnDVwe4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVg5/AAoJELgmozMOVy/dtsAP/0f1gn6g825ggOV80B6uYXiH
1psIcjztTWIVV1KpEzpJXvTtxgYuD/t2++wXupWbwmkhqRMV5vH5gLa77I7avQi2
wKNc7m5nZsAUyA2BMstlwzfzX2lTVYbIobILxVilxDB8Q7342NYV5+TOVxab8ZoQ
ZhCVDYILQRaNKnS4xORoyq/ooP/PI7az1w2a+iMarw+0WjAGWp5S+podPjfDUO6I
no/x7IpMgobGq9tn2nzggayuUiuiXHcy0HsaoOq2J5yT/WwFCVxlyOzk9kvrTW14
aNiJGKt4RXp7hXRdNLRJBkGECdBEL5PiN2mMSUFzlzrZQlq8SEsYr844Hmur/irs
ILFFcQwI4C/uPH2N8nX9xbeeJjwm00ZqdRX8ltHelx4uF7lVqaESEvOubHOq2zNE
ySrRd+ACnYEuaKqfaHJqZJxagv5Qnu6MXjkTZmJWAIFhrepD8KVfEVrp756rdDcc
AOyZGWoF+J1LddAA3PhIIm6qDVxIAcvknze7jYiZxi5t5fcXm8PTrsRxmLY4KLKI
oPwYNCrwhtTZ8MTrcnLUvSCNOyCGj/GjjSAoaho+UYiegvXrIiRr646DOv/M/SlX
Rf260jUCZ44jtJU8FFB2peXuYd5aLrcgORLcaPVpCNNMzIGmyNCDxaKuuODbow7W
/Ho4UYipKmRfJF7OQS7E
=1fsM
-----END PGP SIGNATURE-----

--JXfuel8l1PMhE7LaSGGjmrkJkIEnDVwe4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
