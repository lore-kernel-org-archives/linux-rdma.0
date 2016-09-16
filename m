From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: fix GFP_KERNEL in spinlock context
Date: Fri, 16 Sep 2016 13:55:28 -0400
Message-ID: <6f9a4f4d-573b-a74e-28e2-213f119815e6@redhat.com>
References: <1472849213-27579-1-git-send-email-khoroshilov@ispras.ru>
 <CAG9sBKPQf=G0WpJXf0UAhDXdtaF9i5ZXBQ8rCv9nEORBKjp28g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XFodmjkSxHtLcPS7w8CPBDgQ8XGTVRFMD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKPQf=G0WpJXf0UAhDXdtaF9i5ZXBQ8rCv9nEORBKjp28g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexey Khoroshilov <khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XFodmjkSxHtLcPS7w8CPBDgQ8XGTVRFMD
Content-Type: multipart/mixed; boundary="EqWNwvwrsDlSXbAwejlwI1QiFUUfsLv2h";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Alexey Khoroshilov <khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org
Message-ID: <6f9a4f4d-573b-a74e-28e2-213f119815e6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: fix GFP_KERNEL in spinlock context
References: <1472849213-27579-1-git-send-email-khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
 <CAG9sBKPQf=G0WpJXf0UAhDXdtaF9i5ZXBQ8rCv9nEORBKjp28g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAG9sBKPQf=G0WpJXf0UAhDXdtaF9i5ZXBQ8rCv9nEORBKjp28g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--EqWNwvwrsDlSXbAwejlwI1QiFUUfsLv2h
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/4/2016 6:01 AM, Moni Shoua wrote:
> On Fri, Sep 2, 2016 at 11:46 PM, Alexey Khoroshilov
> <khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org> wrote:
>> There is skb_clone(skb, GFP_KERNEL) in spinlock context
>> in rxe_rcv_mcast_pkt().
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/rxe/rxe_recv.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband=
/sw/rxe/rxe_recv.c
>> index 3d464c23e08b..144d2f129fcd 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
>> @@ -312,7 +312,7 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe,=
 struct sk_buff *skb)
>>                  * make a copy of the skb to post to the next qp
>>                  */
>>                 skb_copy =3D (mce->qp_list.next !=3D &mcg->qp_list) ?
>> -                               skb_clone(skb, GFP_KERNEL) : NULL;
>> +                               skb_clone(skb, GFP_ATOMIC) : NULL;
>>
>>                 pkt->qp =3D qp;
>>                 rxe_add_ref(qp);
>> --
>> 2.7.4
>>
> Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--EqWNwvwrsDlSXbAwejlwI1QiFUUfsLv2h--

--XFodmjkSxHtLcPS7w8CPBDgQ8XGTVRFMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3DIQAAoJELgmozMOVy/dK8gP+gMyTr6Q3vnce+tkxLT42WZg
F7GjdGfjiwX7lbP2uI+I24w0GGBHHSaSFuoVa9Q3dd4lsv5F9pYHRwvRaTMXd0pA
l1kA2Kj4SyxpdPTvQ+VEXYqyEa/PCCKvqyLVG5zhefrrMoE8JFIZ6JTjgDZoFQzz
4PNiWgHoSuaWb1U6/U8TVLR7Uo2+HiZa89xwEgnaY4l+7GAuwRR/YHzZO18FyiK/
XeT2BD0ZmcX9UqbLzWepryacy/MqykCyVN57ZFJx1msYQlmP3qthLTBKu59UhEFO
EoLWGf4An4HzGMTgVlfZguh6DfDjoO2iH4pqygnnH74lt1Rj76f+0iD30l2C2xf4
MtUGYMnU/0glJDB2TU+Br6H/Bjk/ALsGHxiJ/V4uTLkVekQCQyQwIN0lWUDjvnQT
WnE0zQtD3T1aoXt3I5xHK8gubqCbDmYgxNf4haPfGdq7i71XA2ctFbUK6wy1DS9O
RsCkF6rO9Id1F4bJKqIWUFScp794h74zWR7HOloKdP1Hwq+mcaHW/3n8yjWXRxs/
J68X5kkMt/YXlY5egwAOnYkjpGJgSiKwl3Xbb5LKlEVs9VmcbhUZTd16/Rdgwwdn
vjjnpkI2XWLLxR2LiKd8p3AmLj48CYuASeF7GKsEYW/19KxLdBSOVwLEtk+Thyu+
u0D6y/7IUj6cqg0t3EwX
=BV/Z
-----END PGP SIGNATURE-----

--XFodmjkSxHtLcPS7w8CPBDgQ8XGTVRFMD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
