From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [nvme-fabrics]Fabrics over ROCEv2
Date: Fri, 24 Jun 2016 16:32:21 +0200 (CEST)
Message-ID: <1187980791.54028200.1466778741463.JavaMail.zimbra@kalray.eu>
References: <1755342088.51635051.1466689109109.JavaMail.zimbra@kalray.eu> <20160624071312.GD4252@infradead.org> <394543770.53385548.1466766141681.JavaMail.zimbra@kalray.eu> <8AB89CFA-063B-4C85-9B68-3BAE2E9F0B1D@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8AB89CFA-063B-4C85-9B68-3BAE2E9F0B1D-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hadas, Yishai" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Shoua, Moni" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Le 24 Juin 16, =C3=A0 15:40, Majd Dibbiny majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org a =C3=
=A9crit :

>> On Jun 24, 2016, at 2:02 PM, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org> w=
rote:
>>=20
>> Hello Christoph,
>> Thanks for the answer. I do indeed have more general problems with
>> ROCEv2: ib_send_bw works fine for ROCEv1 but not with ROCEv2. I'm
>> going to follow with the Mellanox persons as it seems to be mlx4 or
>> configuration-related.
>>=20
> Hi Marta,
>=20
> Do you run with RDMA-CM?
> Can you please provide the command lines you use and the GIDs table?
>=20

Hello Majd,
Yes, it's using RDMA-CM. I have re-connected the network and the machin=
es have=20
rebooted (unrelated panic) and now it's working fine. If I'm able to re=
produce=20
the problem, I will keep you updated.

Thanks for the help all,
Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
