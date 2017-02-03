From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/cma: Fix reversed test
Date: Fri, 3 Feb 2017 13:34:28 -0500
Message-ID: <2fde1e87-a345-4697-e205-051a3973e624@redhat.com>
References: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
 <1485552696.13218.0.camel@sandisk.com> <1485561952.2432.31.camel@redhat.com>
 <20170128065927.GP4149@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6kp3EIebxmjj3o6Qdlj4odw2MUCgFt8eS"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170128065927.GP4149@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6kp3EIebxmjj3o6Qdlj4odw2MUCgFt8eS
Content-Type: multipart/mixed; boundary="NQuh6BplNUcD1UwrU4AIsqLPf3goCEq7M";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>,
 "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
 "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
 "sean.hefty@intel.com" <sean.hefty@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Message-ID: <2fde1e87-a345-4697-e205-051a3973e624@redhat.com>
Subject: Re: [PATCH] IB/cma: Fix reversed test
References: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
 <1485552696.13218.0.camel@sandisk.com> <1485561952.2432.31.camel@redhat.com>
 <20170128065927.GP4149@mwanda>
In-Reply-To: <20170128065927.GP4149@mwanda>

--NQuh6BplNUcD1UwrU4AIsqLPf3goCEq7M
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 1/28/2017 1:59 AM, Dan Carpenter wrote:
> On Fri, Jan 27, 2017 at 07:05:52PM -0500, Doug Ledford wrote:
>>> Do you think this patch needs "Fixes:" and "Cc: stable" tags?
>>
>> It does not.
>=20
> We always should have fixes tags.
>=20
> When I'm reviewing, I try to look up the patch which introduced the bug=

> so I can figure out what the intent was.  Having a Fixes tag speeds up
> my work.
>=20
> Looking at how the bug was introduced sometimes helps to prevent bugs
> from recurring in the future.  For example, I've seen several bugs
> introduced because the right people weren't on the CC to review it.  Fo=
r
> this particular bug it feels like probably this bug could have been
> detected with more testing.  I doubt it would have made it into a
> released kernel.
>=20
> Also it let's you CC the original authors and hopefully they can Ack it=
=2E

OK, in my mind, there is a specific reason for Fixes: tags, and it
relates to the automated means by which other maintainers pull patches
for long term stable trees.  Because both the buggy patch and this fix
are being queued in the same general kernel release, there is no need
for this patch to get automatically pulled for any of the long term
stable kernels.  Hence my statement that it doesn't need a fixes tag.  I
don't disagree with your reasons for wanting one, but even if you added
the fixes tag, the Cc: stable is definitely not needed.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--NQuh6BplNUcD1UwrU4AIsqLPf3goCEq7M--

--6kp3EIebxmjj3o6Qdlj4odw2MUCgFt8eS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYlM00AAoJELgmozMOVy/d0N0P/35uKixWGcTgjO48Vhcsn/ea
s7G0ZzCVkRtMNYlZ3oLzOB6ymWJgba1VDN6VUqk7cp0/x0ehWBGleUTHMC1rIRTv
Y5Cmr1UHi5Nk21TYkGWgclVEJ+wk5MoRX5iS8XR9Q2yhogoUtkCBzCvIPBge/8aA
aF/axkbQ/G00kvAiD5pHeVyNLMzdBHFmkGSPzMt/XZOKXsSARzD8cwApe+7hp/H6
7KI2dV86kH/BhCfk7GGOi3k1L12uQNZJwOtX0UktzgOYq38pzbiD18ARzOxbBiZ9
9iNVACiOfAra/6/yUtDjVHZ0owS5WVksO9rC59nl+9QKV4chLz+IiaZre3d7EK4F
9iuAXd8A7sn2mFpH469o5Fp4n1jwqiGIamLJX/3HP0D42ME2+pztCbqWX85KQ/Lh
/ImyIws+ke5+SqzsA3uHoi3rfIRToIPb2FuLrUZHhAeCLE4H87uoN27GVbLlYr2W
qZ3w95aMoqiGxxe6dNyiHxlNLiGBYDU76cZTWTYrj6H7W7mg4cg4e2P/vuqe0L86
UYr4XgOJwItp6q7ppsJUeVRR5jmt9rvSRaIgdXUnTNxRHGuKan6NX20LI/7UrIlz
E+ryNrk1SFExdGeFiHqeyZRVJcOGDZze1kTUil25pfHBnnEnPOOFrvp/INJZS+s5
4EKjAg4ZMJ4ojNuH6Vl2
=RJHR
-----END PGP SIGNATURE-----

--6kp3EIebxmjj3o6Qdlj4odw2MUCgFt8eS--
