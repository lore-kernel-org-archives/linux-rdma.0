From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/security: restrict use of the write() interface
Date: Wed, 18 May 2016 17:40:00 -0400
Message-ID: <07725b77-3275-ea07-4315-13997aeed70f@redhat.com>
References: <1b7a157f0f701f65ee8de1c208df256e860d7b93.1463589719.git.dledford@redhat.com>
 <20160518204203.GB4268@whence.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Sh903NuLnouMs2Vrj7xS7wJ491odQ23fJ"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160518204203.GB4268@whence.com>
Sender: stable-owner@vger.kernel.org
To: Kamal Mostafa <kamal@canonical.com>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Sh903NuLnouMs2Vrj7xS7wJ491odQ23fJ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 04:42 PM, Kamal Mostafa wrote:
> On Wed, May 18, 2016 at 12:41:59PM -0400, Doug Ledford wrote:
>> Upstream commit e6bd18f57aad (IB/security: Restrict use of the write()=

>> interface) handled the cases for all drivers in the current upstream
>> kernel.  The ipath driver had recently been deprecated and moved to
>> staging, and then removed entirely.  It had the same security flaw as
>> the qib driver.  Fix that up with this separate patch.
>>
>> Note: The ipath driver only supports hardware that ended production
>> over 10 years ago, so there should be none of this hardware still
>> present in the wild.
>>
>> Cc: stable@vger.kernel.org # <=3D 4.2.x
>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>> ---
>>  drivers/infiniband/hw/ipath/ipath_file_ops.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/in=
finiband/hw/ipath/ipath_file_ops.c
>> index 450d15965005..1f94b560d749 100644
>> --- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
>> +++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
>> @@ -45,6 +45,8 @@
>>  #include <linux/uio.h>
>>  #include <asm/pgtable.h>
>> =20
>> +#include <rdma/ib.h>
>> +
>>  #include "ipath_kernel.h"
>>  #include "ipath_common.h"
>>  #include "ipath_user_sdma.h"
>> @@ -2244,6 +2246,9 @@ static ssize_t ipath_write(struct file *fp, cons=
t char __user *data,
>>  	ssize_t ret =3D 0;
>>  	void *dest;
>> =20
>> +	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
>> +		return -EACCESS;
>=20
> (Same as for the 4.4.x patch)...
>=20
> This needs to be "EACCES" (one fewer 'S').
>=20
> Thanks, Doug.  Queued up (with one fewer 'S') for 4.2 and 3.19 -stable.=


Thanks for fixing it up!

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--Sh903NuLnouMs2Vrj7xS7wJ491odQ23fJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPOEwAAoJELgmozMOVy/dOCsQAKjnjZVTOw9k+65GuVjJj+Dc
O+CdoS1LFNUuESHxaWizcWty/FR8rtNP5ODUKzm5KTKv96r1y5YYg3Y0nDl+deb5
EL7mnZEjHhGf9gpSiuv2zDK2+w40T8YIGgz+PjQvtgMsvzHRVoZqTRH7Nza53JC0
In4I5NFQHq9+OowKdc0aaWiQ/40oP5ma9OZwe/hY+KegJVKDMoPE5xKlD5AOgX5A
mhNJOt8QPuf9io6E9mOx4e95BY3GjHQCHjreHRCWLfJU8gPzyi/He6V0V9jS6nSq
s6odUmm3NBFL7G16WU3TjTJgODEozvtPFwMs1R3yiRkUXcsm6O+a0Vkqovto4RJi
W2a+oYp1O0trBmp15SrG/CXSFIStMUtYguOyUAGIFFlmT0KgC9KW8ViV+b7Pz4pr
g6UMnO0KrDNkxqYb0Wd/8g6XU/Z9LlzvlEu47XnVm5SlODf+QVZGTezja1USqk91
PqP2JEFx0ulARZqZZ+s5se00OIY6DHcdmiirxoj8r+qpgx8HUKjJ/FNIt/FA/Quc
O2Ui9Gjc8vNK2OcDBCCZM/dTxJVS7ECLVQc3UlcIYLak6IcN6+2g6vyDfCEZaj+I
AbfIcp985YBrOl/DYJcVERxDJUyaLOf4tHJBARbFSdGwB/MSkQUOQnqjQYaA1AhW
p4Ehjw1Qr0Lw2eEjBOHk
=pqo8
-----END PGP SIGNATURE-----

--Sh903NuLnouMs2Vrj7xS7wJ491odQ23fJ--
