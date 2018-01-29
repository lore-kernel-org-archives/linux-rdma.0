From: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: ib_create_qp failing
Date: Mon, 29 Jan 2018 19:04:57 +0000
Message-ID: <AM4PR0501MB27239EF18E2C07A64B045674D4E50@AM4PR0501MB2723.eurprd05.prod.outlook.com>
References: <OF089AD255.99D19AC9-ONC2258224.002F8CF2-C2258224.00309558@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF089AD255.99D19AC9-ONC2258224.002F8CF2-C2258224.00309558-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joel Nider <JOELN-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Joel Nider
> Sent: Monday, January 29, 2018 10:51 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: ib_create_qp failing
>=20
...
>=20
> I have used the net/smc module extensively as a reference, but there seem=
s
> to be something fundamental that I'm missing.  How can I find out what's
> going wrong here?

Hi Joel,
What ROCE device are you using?
There are many debug prints in the Mellanox drivers.
You should try enabling  dynamic debug for mlx4_ib or mlx5_ib, it might giv=
e you more information.

Good luck,
Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
