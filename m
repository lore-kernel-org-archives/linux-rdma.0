From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: Configuration of cq->cqe is lower than entries by 1
Date: Wed, 16 Nov 2016 09:45:41 +0000
Message-ID: <SN1PR07MB22072081213EA656CC611E40F8BE0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <SN1PR07MB22076C5DE03F1939603C554CF8BC0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161114120153.GC4240@leon.nu>,<SN1PR07MB22071D220A9067F58E1F09DAF8BC0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <2DF5C492-C364-4353-8FA9-51FA5EE760F0@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2DF5C492-C364-4353-8FA9-51FA5EE760F0-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> 192 =A0=A0=A0=A0=A0=A0=A0=A0entries =A0=A0=A0=A0=A0=3D roundup_pow_of_tw=
o(entries + 1);
>> 193 =A0=A0=A0=A0=A0=A0=A0=A0cq->ibcq.cqe =3D entries - 1;
>>=20
>> I thought something else might hide there.
>> Hi Ram,
>>=20
> For CQs, we always reserve an extra CQE, and thus report one less CQE to =
the
> user.
> This CQE is used for resize CQ operations.
> When the CQ is resized, the HW posts a CQE to indicate that the operation=
 was
> completed on the original CQ buffer.
> Hope now it's clear.

Thanks. I had a guess this was related.=20
Note that there might be different behavior than what you are describing. I=
f the user requested for (2^n) -1 then it'll receive the exact number of en=
tries it requested, without the (at least one) extra entries.
For example, if the user requests 63 entries (n=3D6) it'll receive the same=
 number of entries:
192         entries      =3D roundup_pow_of_two(63+ 1);	// this gives 64
193         cq->ibcq.cqe =3D entries - 1;			// this gives 63 again.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
