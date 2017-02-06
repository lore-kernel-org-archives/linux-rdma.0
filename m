From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Mon, 6 Feb 2017 10:56:56 +0000
Message-ID: <SN1PR07MB22070381E7566FA819E5F8F8F8400@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485446182-5109-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This patchset from Leon adds direct access to mlx5 devices.
>=20
> The libibverbs API is an abstract API. It is agnostic to any underlying
> provider specific implementation. While this abstraction has the advantag=
e of
> user applications portability it has a performance penalty. For some
> applications optimizing performance is more important than portability.
>=20
> The mlx5 direct verbs API introduced in this patchset is intended for suc=
h
> applications. It exposes mlx5 specific low level data path
> (send/receive/completion) operations, allowing the application to bypass =
the
> libibverbs data path API.
>=20
> The proposed interface consists from small number of hardware specific he=
aders
> with relevant inline functions and conversion logic from ibverbs structur=
es to
> mlx5 related structures.
>

Hi Yishay,
While I'm always for better performance, I'm not sure driver specific APIs =
is the way.
This will hurt portability for users.

Thanks,
Ram


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
