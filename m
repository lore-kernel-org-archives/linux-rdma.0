From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [nvme-fabrics]Fabrics over ROCEv2
Date: Fri, 24 Jun 2016 13:02:21 +0200 (CEST)
Message-ID: <394543770.53385548.1466766141681.JavaMail.zimbra@kalray.eu>
References: <1755342088.51635051.1466689109109.JavaMail.zimbra@kalray.eu> <20160624071312.GD4252@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160624071312.GD4252-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hadas, Yishai" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Shoua, Moni" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Christoph,
Thanks for the answer. I do indeed have more general problems with
ROCEv2: ib_send_bw works fine for ROCEv1 but not with ROCEv2. I'm
going to follow with the Mellanox persons as it seems to be mlx4 or
configuration-related.

Marta

----- Le 24 Juin 16, =C3=A0 9:13, Christoph Hellwig hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org a=
 =C3=A9crit :

> Hi Marta,
>=20
> we've tested the NVMe over Fabrics code with both Mellanox and Emulex
> RoCE cards, although I don't remember if we were using RoCEv2.
>=20
> But your problem doesn't sound NVMe specific.  Can your first check i=
f a
> simple test using ib_send_bw works?

--=20
--=20

Marta Rybczynska=20

Phone : +33 6 71 09 68 03=20
mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
