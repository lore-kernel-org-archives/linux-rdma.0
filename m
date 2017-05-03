From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 3 May 2017 12:17:05 -0400
Message-ID: <92010426-c898-0a56-e615-bbf6eb1c5e7e@redhat.com>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu>
 <823aa3f0-685f-4569-11d6-238cc4f0b126@grimberg.me>
 <780938034.8003164.1493824767084.JavaMail.zimbra@kalray.eu>
 <20170503155316.GA14334@obsidianresearch.com>
 <1493827096.3901.4.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iSp5aDTNaOjMqm6FQ89bifXoHUtc0QEAk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493827096.3901.4.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iSp5aDTNaOjMqm6FQ89bifXoHUtc0QEAk
Content-Type: multipart/mixed; boundary="Gg5SQLv1f2AcHTrTBPcSW72D1Umuu91vF";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>,
 "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>,
 "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>,
 "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
 "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>,
 "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <92010426-c898-0a56-e615-bbf6eb1c5e7e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
References: <79901165.5342369.1493805915415.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
 <823aa3f0-685f-4569-11d6-238cc4f0b126-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
 <780938034.8003164.1493824767084.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
 <20170503155316.GA14334-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1493827096.3901.4.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <1493827096.3901.4.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--Gg5SQLv1f2AcHTrTBPcSW72D1Umuu91vF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/3/2017 11:58 AM, Bart Van Assche wrote:
> On Wed, 2017-05-03 at 09:53 -0600, Jason Gunthorpe wrote:
>> On Wed, May 03, 2017 at 05:19:27PM +0200, Marta Rybczynska wrote:
>>
>>>> where
>>>> 	queue->sig_limit =3D max(queue->queue_size / 2, 1);
>>>
>>> I tried to avoid that because this adds a division in the fast path B=
art
>>> was unhappy about in v2.
>>
>> The compiler switches divide/multiply by powers of two into fast bit s=
hifts.
>=20
> Hello Jason,
>=20
> As far as I know the compiler only does that for compile-time constants=
=2E In
> this case the divisor (max(queue_size / 2, 1)) is not a compile-time co=
nstant.

Sure it is.  The only thing that needs to be constant for the compiler
to do the right thing is the '/ 2' part.  queue_size need not be
constant, and the max is performed after the division.  I would fully
expect the compiler to get this right and convert it internally to the
equivalent bit shift, but if it didn't you could always just write it
that way in the first place:

queue->sig_limit =3D max(queue->queue_size >> 1, 1);


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--Gg5SQLv1f2AcHTrTBPcSW72D1Umuu91vF--

--iSp5aDTNaOjMqm6FQ89bifXoHUtc0QEAk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZCgKBAAoJELgmozMOVy/dMXYQAIM/iDC1M9BbpGnd3+mO8bMs
2wvA8PYiq99WBjV0b11mwj44T/+63aDffaqJU3O2Cqw7PN30ecRF/5VJs6y72b/O
aR1AUC4K8sAkTHblv7AxtkvwISPXUzdQMLVAKpucrcvr1k6drUNCXof3n2AlR4Oz
IBYfl/K+ajSQF6cikg2zCBQDBuzweMl05NclP2sH8k27JV/M7yuRvjP6sZ0padrH
xnzGG8waLYDyVJFfZO0FaH7CVf1V+xHEEGUYZOAVgHmKfHqTp5O1CatDKWMXaUid
30zskLzvl7IBtBkHIr8vs7cKK3DnRCS8M1iEQXA7scT/hNqZHTDeUqFEXMfJfZEG
27UfDUSKsrfxICrzixzE4VmFXUfwDxNBAQGFLD1ew/8GRZZ15g3ZxLKeENWveSXD
mwlvftzae70p1Snho6ksJPoXa62+EJvtgEBrUk+JJzm3BaC2mBQxDmzmBbzTxLI1
KNUANSEgXi9GE15FVUnM0ryvmsdWVp9GBlct+sdcSP+C5MpttfXniZmzW/N4fzvK
wzFozz5aN3usY6OVkzlR/FC1uABwVl89nWIPNvtIFbBziR4ZFohquxEwymN7pHkr
Zl8Ie7BPXUxi5c0NJ1VNs8ZLfKe7URS610tXykVJvAO65bL/1HdeVTP4jyYwYB/u
LhyinD5LEO68fRlsUALz
=+Z/x
-----END PGP SIGNATURE-----

--iSp5aDTNaOjMqm6FQ89bifXoHUtc0QEAk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
