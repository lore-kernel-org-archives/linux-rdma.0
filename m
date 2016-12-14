From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/2] IB/rdmavt: cq ktrhead worker fix and API update
Date: Wed, 14 Dec 2016 12:17:26 -0500
Message-ID: <8f55e78f-0c3b-c2ff-14f7-844d68a5d212@redhat.com>
References: <1476878840-14548-1-git-send-email-pmladek@suse.com>
 <1476968182.23693.14.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hnj1IrEO6rVBfqwDhF3DmMFBSIDiw4fco"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476968182.23693.14.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "pmladek@suse.com" <pmladek@suse.com>, "Hefty, Sean" <sean.hefty@intel.com>
Cc: "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hnj1IrEO6rVBfqwDhF3DmMFBSIDiw4fco
Content-Type: multipart/mixed; boundary="CUCLBb0OCKqOP5c3esQOvcm4lthXGUBvr";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>, "Hefty, Sean" <sean.hefty@intel.com>
Cc: "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
 "tj@kernel.org" <tj@kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <8f55e78f-0c3b-c2ff-14f7-844d68a5d212@redhat.com>
Subject: Re: [PATCH 0/2] IB/rdmavt: cq ktrhead worker fix and API update
References: <1476878840-14548-1-git-send-email-pmladek@suse.com>
 <1476968182.23693.14.camel@intel.com>
In-Reply-To: <1476968182.23693.14.camel@intel.com>

--CUCLBb0OCKqOP5c3esQOvcm4lthXGUBvr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/20/2016 8:56 AM, Dalessandro, Dennis wrote:
> On Wed, 2016-10-19 at 14:07 +0200, Petr Mladek wrote:
>> The kthread worker API has been improved in 4.9-rc1. The 2nd
>> patch uses the new functions and simplifies the kthread worker
>> creation and destroying.
>>
>> I have found a possible race when working on the API conversion.
>> A proposed fix is in the 1st patch.
>>
>> Both changes are compile tested only. I did not find an easy way
>> how to test them at runtime.
>>
>> Petr Mladek (2):
>>   IB/rdmavt: Avoid queuing work into a destroyed cq kthread worker
>>   IB/rdmavt: Handle the kthread worker using the new API
>>
>>  drivers/infiniband/sw/rdmavt/cq.c | 64 +++++++++++++++++----------
>> ------------
>>  1 file changed, 27 insertions(+), 37 deletions(-)
>=20
> Thanks for the patches. I'm going to take a closer look, I just now
> seen these.
>=20
> -Denny
>=20

These looked good to me, and you haven't objected, so I'm taking this
series.  Thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--CUCLBb0OCKqOP5c3esQOvcm4lthXGUBvr--

--hnj1IrEO6rVBfqwDhF3DmMFBSIDiw4fco
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUX6mAAoJELgmozMOVy/dSQAQALEwNGD/PbZDlMVyFwcvyBci
XBuMXRpGp0CFjHYrwP/mEwdmmFQ97hpt/ukdEhgTiFNqk/9Bw6/bDJO/KJ8/mN2c
9kNVhpX8ApcIifFdstz33vDK068KyWSvk+c30BfLOvfOyhL5QpQVlxoIsLqrXdP3
BWS0smTr2yiKUuj8W5rUpY+Q9aK7ehQMiFghFzaX/B8kNjZA3eVK/HSazO2nPJEG
Oe157w5Y65C6Zt8QOelIJFiMSK+hd+teRedxDZkqibCdAAYkaNe0QbiUPb83u/jn
JQy50PE/rnjeztjXRQaxh6aX3U5U74XY9Nlpv8jLyvu2t3CC42JKjVpB9mLykRGY
/+ptKSWn1DfcMq5/TvBd22HSjwQm5w5hfjVwMrvfU7iYhw+huQsyMlunSMvZ8gq2
5RKBe49xtdOfEVOIGPF5XrQe5w+UyVDOjd8njxIc95BQjY1sTybkq7kl9Dn9J1Yp
9lX/sf5NcjeMarkDileI4bZo1wEdRMuotDJXuYfaehYK1HGCvUqwYi8N4rAMzoN5
XIkHqrH+zB+Xi1gisug5a3vB/401xKxM3NMLKX7heGhgXuLtOQL93kBpBjaPSPPZ
X7qieRWKqF3yKIujTnh1kHtgrOz/Ilc3a0gYmanREC5dOlqWWLGZShSmH4Xvf/sp
ZCwabVXLFzCcfRz9TxQA
=X+/4
-----END PGP SIGNATURE-----

--hnj1IrEO6rVBfqwDhF3DmMFBSIDiw4fco--
