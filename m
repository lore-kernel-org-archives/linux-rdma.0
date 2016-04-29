From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] IB/isert: convert to the generic RDMA READ/WRITE
 API
Date: Fri, 29 Apr 2016 10:45:34 -0400
Message-ID: <e7959da7-79ca-0422-fbc9-9b3814516e1b@redhat.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-13-git-send-email-hch@lst.de> <57227ADC.80000@redhat.com>
 <572349AA.2070407@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tTV2dOcouLOib7DQ05x4NnandAOJ3S8aB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <572349AA.2070407-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tTV2dOcouLOib7DQ05x4NnandAOJ3S8aB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/29/2016 07:46 AM, Sagi Grimberg wrote:
>=20
>>> Replace the homegrown RDMA READ/WRITE code in isert with the generic
>>> API,
>>> which also adds iWarp support to the I/O path as a side effect.  Note=

>>> that full iWarp operation will need a few additional patches from Ste=
ve.
>>>
>>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>>> ---
>>>   drivers/infiniband/ulp/isert/ib_isert.c | 841
>>> ++++----------------------------
>>>   drivers/infiniband/ulp/isert/ib_isert.h |  69 +--
>>>   2 files changed, 85 insertions(+), 825 deletions(-)
>>
>> Hi Sagi,
>>
>> I've seen your reviews on the smaller patches in this series, but this=

>> one in particular has your name all over it.  If you could review it, =
I
>> would appreciate it ;-)
>=20
> ~800 LOC deleted, what's not to love ? :)

Well, if it neutered support for something in the process, it wouldn't
be to love ;-)

> The patch looks fine to me,
> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>=20
> I did some light testing with rxe and it works fine (no signature stuff=

> though). I've asked Mellanox folks to get this set into their regressio=
n
> systems and still hoping to get their tested-by tag, but if we don't
> hear from them by the merge window I don't think we should block it.

Good to hear, thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--tTV2dOcouLOib7DQ05x4NnandAOJ3S8aB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXI3OOAAoJELgmozMOVy/dgnsQAJITN8S66e/Ny0Jng3VqqiSj
xfLQy0iSZ1BlfQGZLq515mtrjHi/muZzeAESjtbIR1U36GcW8CwZLb8V66F+ycP1
JdC1y6cuTFacC+ilxTyKjqpzUEsepTqwlsyzudcblp+VwffKUyuKS+2btff8bagv
ozD+zSrGKiSs2qgmVMfLASAV3EBcVCnrwAneXUmJMVqaYlCUzReoCRs0pi0u/408
1+T1LThSmnwKehCAmtG3Tx2wDreI2B27hmeKNeq9ZYXnxvvPkn+sAJ/060c6pxeR
oznCytA55ItH53vbjktI4kMi69Fybq1MLVgTEGCkbuzEugUtU9E9WmB++e3iEP7l
t1qIvgnwEO3lIbdisl26mWmNILPmfzMdU+Ti+Ls3s084LAKWUk5RFo1JPhawkzSL
Ns8xV23d/FxpUVqBvHmaiIkK9ch0yhHEj/cZQ4mZLQuVAXXRW6QbUen7r0cBjBkD
znuqZamaMwS7VjZJj3IvdFbowqF+g6a08LZqFxfrmlgSKKEQlvhcbbeasuwOmatC
fXemuy68KXWvRAEMB+1inG6sQQVyCzq3Sa5zzYrZIrkoE/FXqebEPlBqMbL6zCWP
lVKBMNLosJDZpWunWB3NTTyCN6X4phk8IOr019tD8Ab4sM+5063mgUBGi00i1AHV
DAlh3qS4SmiKNLHYN9wq
=6C7N
-----END PGP SIGNATURE-----

--tTV2dOcouLOib7DQ05x4NnandAOJ3S8aB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
