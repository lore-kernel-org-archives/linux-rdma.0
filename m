From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 3 May 2017 15:07:45 -0400
Message-ID: <3bbd412e-f361-e657-1f84-835b5f80388c@redhat.com>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu>
 <823aa3f0-685f-4569-11d6-238cc4f0b126@grimberg.me>
 <780938034.8003164.1493824767084.JavaMail.zimbra@kalray.eu>
 <20170503155316.GA14334@obsidianresearch.com>
 <1493827096.3901.4.camel@sandisk.com>
 <92010426-c898-0a56-e615-bbf6eb1c5e7e@redhat.com>
 <1493828639.3901.11.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GLdUhLfBSh5dFusQ7E5HRlaCpNLqhl8h3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493828639.3901.11.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GLdUhLfBSh5dFusQ7E5HRlaCpNLqhl8h3
Content-Type: multipart/mixed; boundary="UaE7fCx5S765Ve8LFoleFxTj04SN57UaU";
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
Message-ID: <3bbd412e-f361-e657-1f84-835b5f80388c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
References: <79901165.5342369.1493805915415.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
 <823aa3f0-685f-4569-11d6-238cc4f0b126-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
 <780938034.8003164.1493824767084.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
 <20170503155316.GA14334-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1493827096.3901.4.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <92010426-c898-0a56-e615-bbf6eb1c5e7e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <1493828639.3901.11.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <1493828639.3901.11.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--UaE7fCx5S765Ve8LFoleFxTj04SN57UaU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/3/2017 12:24 PM, Bart Van Assche wrote:
> On Wed, 2017-05-03 at 12:17 -0400, Doug Ledford wrote:
>> On 5/3/2017 11:58 AM, Bart Van Assche wrote:
>>> On Wed, 2017-05-03 at 09:53 -0600, Jason Gunthorpe wrote:
>>>> On Wed, May 03, 2017 at 05:19:27PM +0200, Marta Rybczynska wrote:
>>>>
>>>>>> where
>>>>>> 	queue->sig_limit =3D max(queue->queue_size / 2, 1);
>>>>>
>>>>> I tried to avoid that because this adds a division in the fast path=
 Bart
>>>>> was unhappy about in v2.
>>>>
>>>> The compiler switches divide/multiply by powers of two into fast bit=
 shifts.
>>>
>>> Hello Jason,
>>>
>>> As far as I know the compiler only does that for compile-time constan=
ts. In
>>> this case the divisor (max(queue_size / 2, 1)) is not a compile-time =
constant.
>>
>> Sure it is.  The only thing that needs to be constant for the compiler=

>> to do the right thing is the '/ 2' part.  queue_size need not be
>> constant, and the max is performed after the division.  I would fully
>> expect the compiler to get this right and convert it internally to the=

>> equivalent bit shift, but if it didn't you could always just write it
>> that way in the first place:
>>
>> queue->sig_limit =3D max(queue->queue_size >> 1, 1);
>=20
> Hello Doug,
>=20
> In my comment I was referring to "% max(queue_size / 2, 1)" and not to
> "queue_size / 2".

Sorry, too much context was cut for that to come through.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--UaE7fCx5S765Ve8LFoleFxTj04SN57UaU--

--GLdUhLfBSh5dFusQ7E5HRlaCpNLqhl8h3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZCiqBAAoJELgmozMOVy/dT8MQALr9+OQO99jLMU8cujZmEqwb
0krIdgxW2Q1ec9n5Sr5D1eXJvtZuG6dD9XiNGUMriHrP9VXzvQVKJREWjMlPh7jO
XQrJ69fiStLmEgPTLbxCFJ1hRKEO6EqpkVoFnywPw1oU0deVOESZc2dKvXM6Tva/
j69AW9PNiIgcu57ogTjaEFWnR1C/b11+AHXHb7hBrXxH/bL/oOwx7aiICFiDmU+7
falSiDZb6GIQDZfIED84WuuNbgM1cvz2Biv4af7LVVjG5YSxZnZFPRUE0kacBUtz
+FsufMzDRCTDZ9uWLQE29JyxRA3cjh1ZiJ6tLwPtXnKSzBkxl+36Ma2FGNxQG1Uz
Y/Wgl2ShDNXfnIP3DvAqgVMSZaOgQGhfOoPFXV8+Wnpep1C7yYvNaoPLQLL550ng
Tnn6LG6xS9Rs3W3ty7tb9/rsYg7sr9ma/qcPF7j7YA945/KbeVA5K/0MGVZttUDs
WcpfqMLIdqhRnacIRu4R5zE7ImMdedlHKEQCNAENTmDqV5dJqDBxgfUSzfzTtiw2
FksdtJVX5mPlLbiaJRzHTYhzUsi8Ieer5SXF+2Rwx6Uy5gLysfkcDkVjndRAbokZ
zgfiBr8bhJZgjEyVesFkhHRsexfw9h+/2aPJZuKAQBn3TsgovSsEkI0uoAbnBtv7
0sjDZIK7owR3ehCBU47B
=Z8xX
-----END PGP SIGNATURE-----

--GLdUhLfBSh5dFusQ7E5HRlaCpNLqhl8h3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
