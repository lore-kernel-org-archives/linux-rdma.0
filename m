From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/mlx4: Report checksum offload cap when query
 device
Date: Mon, 21 Sep 2015 17:59:59 -0400
Message-ID: <56007DDF.30502@redhat.com>
References: <cover.1442413048.git.bodong@mellanox.com>
 <68bea4df2c89e5457aaaccf914756bc309d742a7.1442413048.git.bodong@mellanox.com>
 <55FB7AE8.2070304@redhat.com>
 <CAJ3xEMg31JSPU2_gW0OGjC9rdTgDRcx=7LnuPncD6+gCE7nRMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k6vAOdMBpDU9wreaikIRCwr2nxF60qEHN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMg31JSPU2_gW0OGjC9rdTgDRcx=7LnuPncD6+gCE7nRMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k6vAOdMBpDU9wreaikIRCwr2nxF60qEHN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/21/2015 05:41 PM, Or Gerlitz wrote:
> On Fri, Sep 18, 2015 at 5:46 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 09/16/2015 11:56 AM, Bodong Wang wrote:
>>> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>  drivers/infiniband/hw/mlx4/main.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/h=
w/mlx4/main.c
>>> index 8be6db8..a70ca6a 100644
>>> --- a/drivers/infiniband/hw/mlx4/main.c
>>> +++ b/drivers/infiniband/hw/mlx4/main.c
>>> @@ -217,6 +217,9 @@ static int mlx4_ib_query_device(struct ib_device =
*ibdev,
>>>               props->device_cap_flags |=3D IB_DEVICE_MANAGED_FLOW_STE=
ERING;
>>>       }
>>>
>>> +     props->csum_cap.eth_csum_cap |=3D IB_CSUM_SUPPORT_RAW;
>>> +     props->csum_cap.ib_csum_cap |=3D IB_CSUM_SUPPORT_UD;
>>> +
>=20
>> This patch highlights something I didn't think about on the previous
>> patch.  Why separate eth/ib if you have per QP flags?  The QP denotes
>> the ib/eth relationship without the need to separate it into two
>> different caps.  In other words, you can never have an IB qp type on e=
th
>> because the only eth QP types we support other than RAW are all RDMA a=
nd
>> not IP.  Really, there's enough spare bits in ib_device_cap_flags that=

>> you could do away with the new caps entirely.  Right now, we support U=
D
>> (which we already have a flag for), we can add two flags (for RAW and
>> RC) and that should cover all of the foreseeable options as that would=

>> allow us to extend IP CSUM support to cover connected mode and cover a=
ll
>> of the current options.  I don't see us doing IP traffic in any other
>> situation, so I thing that should suffice.  Bits 25 and 26 could be us=
ed
>> for the two new bits.  Then you just need to extend the bits to user s=
pace.
>=20
> Doug,
>=20
> The vendor may support the offload for a certain QP type only over
> certain link.

Exactly my point.

> E.g mlx4 support checksum for UD QPs only over IB but
> not over Eth,

As it should be.  We are, after all, talking about IP embedded in UD
RDMA.  Over IB that makes sense.  Over Eth it makes no sense.  If you
are going to do IP on Eth, then just do IP, don't do IP in UD.  I see no
reason to support this construct.

>  checksum for RC QPs isn't supported,

But could be for IB.  The fact that it isn't is why there is an ongoing
effort to work around this issue.

> and RAW_PACKET QPs
> are available anyway only for Eth links.

Correct.  And this will never be available on IB.

> But if this is what you think
> needs to be done, I guess we can do that.

Here's the only matrix of IP checksumming that makes sense:

1) UD over IB (because it is one of the supported IPoIB types)
2) RC over IB (same as above)
3) Raw ETH over Eth (because IP over Eth makes sense and is a common
type of packet to send on Raw Eth, but Raw Eth will never be sent on IB
as it isn't supported there at all)

Anything else would require adding more Raw ETH QPs elsewhere, or
expanding the IPoIB spec to include more connection types.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--k6vAOdMBpDU9wreaikIRCwr2nxF60qEHN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWAH3fAAoJELgmozMOVy/dK8QP/3q+xh7JrgqLKFMzITFDvjxR
JlWLacDZdfB4zOO7mEJ8ElUOGQ1Ws8f9sfBvWuo/MT7jTZWhtUhsGVh6ghlqs4Ji
ZxoNFpWvdNtkyPUsrwyd+xrHCgz9EFo6olIqzHZlJH7zeXqmP5C1JsUrtY8OE9E0
rE58l42Gk2B17Kj92Eqa5EEdU1y+9BACuU+nnB5jsMmse/rC7P8Tj/mhR8JXWZaM
LBBsZOmxUWjAwVFKPvUqwNcq/KXeG+IhdgjfQP7yCSujg1J8Zp/DfZQjDEWLIhsg
i4+VEjFWkpdOK0u0+vbFsInEdOssZxnG6LwHMV+Lin1FDi82pHK/NlwKF11I6xiq
JZpTx1F31djxGXBbqQcd9W1jI6cgN48BSQFCFvhi8zP89ZQ18gJTGD2WNHV6DVNB
kapnLP1Ic89qyX9h07ztZzdYg2RYKvanQz+zBqAGbcqfO0nXf2u7dtR8vGlyi8SG
7UhFxv3yVDl5ND1rjsnLtUnyxDCAugKBWXQwpWJ9SLtYyTHue7F+Iu5XtKiuur9Q
I0UKzUCIDu8EWpMraXkhymi7c3rYXqBETPveP2au76hRjXE/ly6L5mLPHGEinVZP
ADMnVpNW2IRY469aMPEYm2uGosvW07uKCXCJf6ZoQAMBZ/4zzL9P5hR9+nqfWO56
M0K6t/ZhZgdA4J+dlJ5o
=FxQp
-----END PGP SIGNATURE-----

--k6vAOdMBpDU9wreaikIRCwr2nxF60qEHN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
