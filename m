From: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC 1/2] Introduce egress IB flow steering flag
Date: Thu, 20 Apr 2017 18:31:39 +0000
Message-ID: <DB6PR05MB317616BBA0589EFCA90D02E1B01B0@DB6PR05MB3176.eurprd05.prod.outlook.com>
References: <cover.1492685328.git.borisp@mellanox.com>
 <8539540c4130ea91bbd128f2ec2845082d6000f8.1492685328.git.borisp@mellanox.com>
 <20170420174809.GS14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170420174809.GS14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Aviad Yehezkel <aviadye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > This commit introduces egress flow steering. Egress flow steering is
> > useful for specifying actions that might be applied by hardware to
> > outgoing flows on a specific QP.
> >
>=20
> How will user know which flow actions are applicable for egress traffic, =
for
> both ingress/egress and for ingress only?
The implementation could return an error when a device doesn't support a ce=
rtain action.
For example, we may not support crypto offload for encapsulation of IPsec p=
ackets, and we
will return an error if such a flow specification is provided.

Did you have any specific action that is not supported in some direction? A=
FAIK, we=20
support all action for egress as well as ingress.

>=20
> I think separate structure for ingress vs. egress are better approach, th=
an
> blind global flag.
I thought of using a direction flag in the action itself, but decided again=
st it , because all flow
specification refer to a certain direction and not the action alone. Moreov=
er, there are other
actions that will be based on this flag, like encapsulation actions.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
