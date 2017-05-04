From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Thu, 4 May 2017 14:50:00 +0200 (CEST)
Message-ID: <310709514.10440651.1493902200194.JavaMail.zimbra@kalray.eu>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu> <823aa3f0-685f-4569-11d6-238cc4f0b126@grimberg.me> <780938034.8003164.1493824767084.JavaMail.zimbra@kalray.eu> <20170503155316.GA14334@obsidianresearch.com> <1493827096.3901.4.camel@sandisk.com> <77ada146-67eb-9dce-d252-6ac630c9a1e8@grimberg.me> <20170503162708.GO22833@mtr-leonro.local> <1493829456.3901.13.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493829456.3901.13.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, samuel jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Wed, 2017-05-03 at 19:27 +0300, Leon Romanovsky wrote:
>> On Wed, May 03, 2017 at 07:01:14PM +0300, Sagi Grimberg wrote:
>> > > As far as I know the compiler only does that for compile-time consta=
nts. In
>> > > this case the divisor (max(queue_size / 2, 1)) is not a compile-time=
 constant.
>> >=20
>> > We could theoretically do a (sig_count & max(queue_size / 2, 1)) but
>> > that would only do well with power of 2 sized queues...
>>=20
>> IMHO, It is not-so-big-deal limitation.
>=20
> Hello Marta, Sagi and Leon,
>=20
> How about changing nvme_rdma_init_sig_count() such that it always returns
> a power of two? The "+ 1" in the code below makes sure that the argument =
of
> ilog2() is larger than zero even if queue_size =3D=3D 1. I'm not sure whe=
ther
> the time needed to compute ilog2() would make it necessary to cache the
> nvme_rdma_init_sig_count() return value.
>=20
> static inline int nvme_rdma_init_sig_count(int queue_size)
> {
>        /* Return the largest power of two that is not above half of (queu=
e size + 1) */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 1 << ilog2((queue_size +=
 1) / 2);
> }
>=20
> Bart.

This looks like a good idea to me. Then the division can change into
an AND. I'll come back with another version soon.

Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
