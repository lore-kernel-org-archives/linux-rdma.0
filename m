From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [nvme-fabrics]Fabrics over ROCEv2
Date: Fri, 24 Jun 2016 16:41:19 +0200 (CEST)
Message-ID: <490655406.54097546.1466779279070.JavaMail.zimbra@kalray.eu>
References: <1755342088.51635051.1466689109109.JavaMail.zimbra@kalray.eu> <20160624071312.GD4252@infradead.org> <394543770.53385548.1466766141681.JavaMail.zimbra@kalray.eu> <8AB89CFA-063B-4C85-9B68-3BAE2E9F0B1D@mellanox.com> <1187980791.54028200.1466778741463.JavaMail.zimbra@kalray.eu> <E47B62BF-F8ED-40B9-8700-33CDFDB5AD1A@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E47B62BF-F8ED-40B9-8700-33CDFDB5AD1A-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hadas, Yishai" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Shoua, Moni" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Le 24 Juin 16, =C3=A0 16:38, Majd Dibbiny majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org a =C3=
=A9crit :

>> On Jun 24, 2016, at 5:32 PM, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org> w=
rote:
>>=20
>>=20
>>=20
>> ----- Le 24 Juin 16, =C3=A0 15:40, Majd Dibbiny majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org a =
=C3=A9crit :
>>=20
>>>> On Jun 24, 2016, at 2:02 PM, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>=
 wrote:
>>>>=20
>>>> Hello Christoph,
>>>> Thanks for the answer. I do indeed have more general problems with
>>>> ROCEv2: ib_send_bw works fine for ROCEv1 but not with ROCEv2. I'm
>>>> going to follow with the Mellanox persons as it seems to be mlx4 o=
r
>>>> configuration-related.
>>> Hi Marta,
>>>=20
>>> Do you run with RDMA-CM?
>>> Can you please provide the command lines you use and the GIDs table=
?
>>=20
>> Hello Majd,
>> Yes, it's using RDMA-CM. I have re-connected the network and the
> This might be related to the fact that you need to configure the RDMA=
 CM mode
> using configfs. (By default it's V1)


This isn't in fact working for me in 4.7+ (does work fine in OFED kerne=
l 3.10).
Write to default_roce_mode does give Permission denied even for root (h=
aven't=20
debugged this one, however).

--=20

Marta Rybczynska=20

Phone : +33 6 71 09 68 03=20
mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
