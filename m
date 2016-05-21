From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Fwd: Re: [PATCH] IB/security: restrict use of the write() interface
Date: Sat, 21 May 2016 10:27:56 -0400
Message-ID: <f08a20a3-9c4a-9c17-7cfd-6f25990cdbda@redhat.com>
References: <0ab5724f-d6db-20eb-dd60-35aae9d6d9d6@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3dTJ1neATBpxg0hAs5MEOuQwlomROTGwO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0ab5724f-d6db-20eb-dd60-35aae9d6d9d6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-stable <linux-stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3dTJ1neATBpxg0hAs5MEOuQwlomROTGwO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hmmm, for some reason, reply-all didn't get either list.


-------- Forwarded Message --------
Subject: Re: [PATCH] IB/security: restrict use of the write() interface
Date: Sat, 21 May 2016 10:07:12 -0400
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Organization: Red Hat, Inc.
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
CC: Kamal Mostafa <kamal-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/21/2016 01:32 AM, Greg KH wrote:
> On Wed, May 18, 2016 at 01:40:13PM -0700, Kamal Mostafa wrote:
>> On Wed, May 18, 2016 at 12:46:11PM -0400, Doug Ledford wrote:
>>> Upstream commit e6bd18f57aad (IB/security: Restrict use of the write(=
)
>>> interface) handled the cases for all drivers in the current upstream
>>> kernel.  The ipath driver had recently been deprecated and moved to
>>> staging, and then removed entirely.  It had the same security flaw as=

>>> the qib driver.  Fix that up with this separate patch.
>>>
>>> Note: The ipath driver only supports hardware that ended production
>>> over 10 years ago, so there should be none of this hardware still
>>> present in the wild.
>>>
>>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 4.4.x
>>> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  drivers/staging/rdma/ipath/ipath_file_ops.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/staging/rdma/ipath/ipath_file_ops.c b/drivers/st=
aging/rdma/ipath/ipath_file_ops.c
>>> index 13c3cd11ab92..f237a2e2a086 100644
>>> --- a/drivers/staging/rdma/ipath/ipath_file_ops.c
>>> +++ b/drivers/staging/rdma/ipath/ipath_file_ops.c
>>> @@ -45,6 +45,8 @@
>>>  #include <linux/uio.h>
>>>  #include <asm/pgtable.h>
>>> =20
>>> +#include <rdma/ib.h>
>>> +
>>>  #include "ipath_kernel.h"
>>>  #include "ipath_common.h"
>>>  #include "ipath_user_sdma.h"
>>> @@ -2243,6 +2245,9 @@ static ssize_t ipath_write(struct file *fp, con=
st char __user *data,
>>>  	ssize_t ret =3D 0;
>>>  	void *dest;
>>> =20
>>> +	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
>>> +		return -EACCESS;
>>
>> This needs to be "EACCES" (one fewer 'S').
>=20
> And so goes the "if it isn't in Linus's tree, and it is asked to be
> merged into -stable, it is almost always wrong" proof :(
>=20
> Doug, why did you send these if you didn't even build them?

It's a bit embarassing that I did a typo while copying the fix from qib
to ipath (I used middle mouse click to copy the previous line, but the
return line was so simple I hand typed it and my muscle memory of using
correct spelling bit me in the ass), but it's not the end of the world.

>  Because of
> that, I _know_ you didn't test them, how do I know these are safe to
> apply?

These are patches to 10+ year old hardware that I don't even have any
more.  Nor does anyone else likely.  In this case, it has to be "the
devil you know versus the devil you don't", and the devil you know is a
security issue, and you know that the qib driver was originally lifted
directly from the ipath driver and so they are very close to identical
in major portions of their code, and you know that the fix was tested in
qib modulo my copy-n-paste error.

> ugh.

The fix is good, just my copy of it was broken.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD




--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3dTJ1neATBpxg0hAs5MEOuQwlomROTGwO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXQHBtAAoJELgmozMOVy/dBRMP/Rj6CSH76uMFc089wNB6Bjmc
3fLvlph1zQ9i2s6wCPLU2SW8t+7culjZxA4JBg1qYhvrLBQC8nSB5ijTyl+bo4dH
8oAEhMhcfXO2tVPnptHhNBh3LYa8mQVRyRTxTuv2YgF1OPSuyGbTL1Yka/yluw3L
RMtS17cJFrthyGJeYUNH+6EOjeAgjKnLPBp1RQujogF3x40ZXooZvDisIuCII7SL
5jeHbm3mL8cCaDCHQvO9+Aij2PObSiFpHxSX5cjoz0ivFZLBbw5oPhL8zMa7GV3U
mfP+5YMnVKy7mWy84zR1FtCjXidQGPVhyICrtRhPSsQlSZOpwV4ZPtRfDyqrJ/Ha
O0I49Fy5Lc15P1PK+mjL0xyIVpXooC2v4ZildW95/gSqqZeIPu1+Dew3s/sfBlYL
eMngGtieBrO+O5uu913CkClKH+ON88foWJIid7lmBn8xfyXz+5WNEff2XfhwYGKY
j5XMcqW2qqSjHG9L2OZs04XNWgUqNk8CQ90ZrvzFzgHDMB5FDD+Z1wPYtEIVHf0v
F7yKV7ZozvBzlm5UXRz6qP+NhT7a67ExRDp8Y8J7vD9ZygmMI5uz10e1niCBjq7R
dM7q43nths/jvsveavEzad1jDAvQHPnU5d1fP6VhO9dFQ2G3IhxMW5WmyXUbCcpi
H8djXalP6yyqpwMJm+Cn
=mHom
-----END PGP SIGNATURE-----

--3dTJ1neATBpxg0hAs5MEOuQwlomROTGwO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
