From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [nvme-fabrics]Fabrics over ROCEv2
Date: Fri, 24 Jun 2016 13:40:26 +0000
Message-ID: <8AB89CFA-063B-4C85-9B68-3BAE2E9F0B1D@mellanox.com>
References: <1755342088.51635051.1466689109109.JavaMail.zimbra@kalray.eu>
 <20160624071312.GD4252@infradead.org>,<394543770.53385548.1466766141681.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <394543770.53385548.1466766141681.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 24, 2016, at 2:02 PM, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org> wr=
ote:
>=20
> Hello Christoph,
> Thanks for the answer. I do indeed have more general problems with
> ROCEv2: ib_send_bw works fine for ROCEv1 but not with ROCEv2. I'm
> going to follow with the Mellanox persons as it seems to be mlx4 or
> configuration-related.
>=20
Hi Marta,

Do you run with RDMA-CM?
Can you please provide the command lines you use and the GIDs table?

Thanks
> Marta
>=20
> ----- Le 24 Juin 16, =E0 9:13, Christoph Hellwig hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org a =
=E9crit :
>=20
>> Hi Marta,
>>=20
>> we've tested the NVMe over Fabrics code with both Mellanox and Emule=
x
>> RoCE cards, although I don't remember if we were using RoCEv2.
>>=20
>> But your problem doesn't sound NVMe specific.  Can your first check =
if a
>> simple test using ib_send_bw works?
>=20
> --=20
> --=20
>=20
> Marta Rybczynska=20
>=20
> Phone : +33 6 71 09 68 03=20
> mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
