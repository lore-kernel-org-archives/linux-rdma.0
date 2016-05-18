From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/security: Restrict use of the write() interface
Date: Wed, 18 May 2016 13:57:51 -0400
Message-ID: <c6c952ea-3562-48e1-cf56-5b8c810654f1@redhat.com>
References: <02bf2ebafbc5d757c0d250d8e5fba3ebdc7393fd.1463590718.git.dledford@redhat.com>
 <20160518172012.GA6879@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C2Po7uJGpBukwncCeD8PXr3UP12W8J8BK"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160518172012.GA6879@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C2Po7uJGpBukwncCeD8PXr3UP12W8J8BK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 01:20 PM, Greg KH wrote:
> On Wed, May 18, 2016 at 12:58:38PM -0400, Doug Ledford wrote:
>> From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>>
>> The drivers/infiniband stack uses write() as a replacement for
>> bi-directional ioctl().  This is not safe. There are ways to
>> trigger write calls that result in the return structure that
>> is normally written to user space being shunted off to user
>> specified kernel memory instead.
>>
>> For the immediate repair, detect and deny suspicious accesses to
>> the write API.
>>
>> For long term, update the user space libraries and the kernel API
>> to something that doesn't present the same security vulnerabilities
>> (likely a structured ioctl() interface).
>>
>> The impacted uAPI interfaces are generally only available if
>> hardware from drivers/infiniband is installed in the system.
>>
>> Reported-by: Jann Horn <jann@thejh.net>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> [ Expanded check to all known write() entry points ]
>> Cc: stable@vger.kernel.org # 3.14.x
>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>> [ Expanded to include removed ipath driver, and dropped non-existent
>>   hfi1 driver ]
>> ---
>>  drivers/infiniband/core/ucm.c                |  4 ++++
>>  drivers/infiniband/core/ucma.c               |  3 +++
>>  drivers/infiniband/core/uverbs_main.c        |  5 +++++
>>  drivers/infiniband/hw/ipath/ipath_file_ops.c |  5 +++++
>>  drivers/infiniband/hw/qib/qib_file_ops.c     |  5 +++++
>>  include/rdma/ib.h                            | 16 ++++++++++++++++
>>  6 files changed, 38 insertions(+)
>=20
> I don't understand, is this only for 3.14.x?

Yes.  You already applied the same patch against 4.5.x, but without the
update to include the ipath driver and with the hfi1 driver still in the
patch.

>  If so, what is the git
> commit id in Linus's tree for this?

Sorry, forgot that: e6bd18f57aad


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--C2Po7uJGpBukwncCeD8PXr3UP12W8J8BK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPK0fAAoJELgmozMOVy/d2F0QAK6Ty2ZqXwqg2HFJCIHPViuN
a2pUtrs0whjzkzvJVp8gWGWBAe2vnm7FXgYVFlb4kxG3pbvXCcMswPEhah8yeNgX
hqqLI3BZSIJ3RUr2SRLqw1tsVjNaZYEBzYU9hUfILPVDLDkw5Dj0vkP4bbUp0wnW
0r2ad+bGGWBdnHK0L8x7vVTzbeberQDjPmDNFpyR99potOiJRCxOEslG+Iwb+aRD
UBdNm2ZaDawP+DyOMJGVXVw7UtXrlwhuWBl+9HvlGQqfTu0G291cl8TT5lXfYPal
WamxiZEuBMaBjFZRxcypGrAD4WBrXLhUjBy8h2WawVQRcNTRYuVWKHOcewWQVktD
W9p7bH1VP+IQmmY7PawSu/UY+H11lpZ4z3qN8p2A61dqiaj0MkMysX4m94kesfMC
3ysYlAouILVzzFOemCzyu9hNBZWqKiWTLFUAwTQixlC+kQ7dPQoIfbMvDfHiMIvR
Md+P2pKt4H2Qtn9KyKtz615uWnLgYhC35olVyN3bSr/UhZvA8iKzvXPPwJnqtXpT
WrOQfEm9vwHNwOlWxS32rKIxDwoUwtQpn9wgoR8nTOHYnvHdmgOxWV+9Xht6btWg
5OOiuYKrUtCxia/+5+qSOioarxLYiDOWFXndfv7IYbn4c1tPYFVaXBnliizLNuUE
DPoJhrUrmr85gWe5S0ja
=Noj1
-----END PGP SIGNATURE-----

--C2Po7uJGpBukwncCeD8PXr3UP12W8J8BK--
