From: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC 0/2] IB/core: Add ESP Crypto Flow Steering support
Date: Thu, 20 Apr 2017 15:24:39 +0000
Message-ID: <DB6PR05MB3176852A5F283F850E37DA70B01B0@DB6PR05MB3176.eurprd05.prod.outlook.com>
References: <cover.1492685328.git.borisp@mellanox.com>
 <040001d2b9e9$0a274530$1e75cf90$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <040001d2b9e9$0a274530$1e75cf90$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Aviad Yehezkel <aviadye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>=20
> Do you have any applications that utilize this and other flow steering AP=
Is?  It
> would be nice to see example usage.
>=20

Our DPDK PMD already utilizes flow steering and it will use this API.

Also, we have support for this offload in XFRM, but it doesn't use flow ste=
ering at the moment. In the future, XFRM NDO will use flow steering through=
 our driver.
Patches for the kernel XFRM code can be found here:=09
https://patchwork.ozlabs.org/patch/752707/
Our driver support for this framework in XFRM can be found here:
https://github.com/Mellanox/ipsec-offload
XFRM is programmed with iproute2. You can find code for it here:
https://github.com/Mellanox/iproute2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
