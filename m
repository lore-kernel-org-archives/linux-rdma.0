From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: HFI1 code duplication todo
Date: Fri, 20 Nov 2015 11:58:18 -0500
Message-ID: <564F512A.1060808@redhat.com>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com>
 <20151119222319.GA17605@phlsvsds.ph.intel.com> <564F3F1C.4020508@redhat.com>
 <20151120163935.GA10091@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HVbsw1MtpLdWwAXOlGE0biFM4wubeEpIf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151120163935.GA10091-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HVbsw1MtpLdWwAXOlGE0biFM4wubeEpIf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/20/2015 11:39 AM, Greg KH wrote:
> On Fri, Nov 20, 2015 at 10:41:16AM -0500, Doug Ledford wrote:
>> To that end, I've opened my 4.4-rc branch and deleted the three
>> deprecated drivers from staging and moved hfi1 to the rdma tree.  I've=

>> sent an email to Linus to see if he's ok taking those changes, and if
>> so, I'll get them submitted and then open up my for-4.5 branch early t=
o
>> be able to start taking for-next patches.
>=20
> I think it's too late for that, especially given that I have 34+ patche=
s
> for the staging rdma drivers already in my tree in linux-next.

For hfi1 rename detection should work, for the other three, patches to
removed files are easily resolved as simply dropped patches.  So I don't
think it's that large of an issue.  Correct me if I'm wrong.

>  And the
> hfil1 code really doesn't look like its ready to merge into the "real"
> portion of the kernel tree, given the horrid nature of the patches
> submitted recently for it :(

I'm sorry, that doesn't make sense to me.  How can the quality of
patches that aren't part of the driver yet and are just being submitted
impune the readiness of the code the patches are supposed to be touching?=


And that's orthogonal to the issue that the primary TODO item for this
driver requires coordination between it, qib (in the RDMA tree), and the
upcoming soft_roce driver.  If the driver isn't moved, then we have to
coordinate between your tree and mine to make sure that no patches are
taken into your tree until after the patches they depend on have landed
in my tree.  And then you tree likely won't build unless you pull from
my tree and merge up first.  It's not really tenable.  That was why I
had suggested (and originally you agreed to) that I would handle the
entire staging/rdma tree.  However, since you changed your mind on that
issue, we now have this coordination issue.  I don't really want to deal
with that, so I would rather move the hfi1 driver and take care of the
all the needed patching myself going forward.

> I had expected the drivers to be deleted for -rc1, removing them now
> seems a bit late in the merge window.

Yes, I know.  I've been busy.  My apologies for not getting it in prior
to rc1.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--HVbsw1MtpLdWwAXOlGE0biFM4wubeEpIf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWT1ErAAoJELgmozMOVy/dRI4QAKhHzh1i8dRkbEBVMS2iNwkB
/X3JLtiWAqu3SUNLZ3rpU4pCStd8ERTcGcnBLDUiJnFwgXy6IXMKV+GgB5j7OOTg
olwlZkG9VK/ENXy43Sy5BEsk2/tnYqDlLWAb/UAw6ZG3Nv3smmzLqw0HUom26RJC
Ru4OUD/JBBe13k1ZCfCEJq8ISKDUdf0jdqMAUJDpkC1hRlemzYUZxZdUe8tAW5xK
AEvN81C9RWT+yC3VUbEQJmiHxmSsM1mlriu00BpqmLKBLbhqY67yxt/pJPLXILSS
9wS7ZDZOBeu8cPn8QV3cOhesa5HmliSAA/Gc1tTp4FEvg+w/vplxAQBMctuxHTog
Co+6kZP5sEz9EDZKUyoLgm4JwEVnVVvAM+CgxR5xADOK/9aQ1f6XSH9p10whUwww
82BKNatTPILzvUsD4LZL/ZqZ+QdjQMvjxYlUPiPViq0ySUU+kZCDh67v1egM4iAw
3SbVPWthLXklYP+1lify5P54SHqpSGsxhbadHNdM0dgZQEAVMWVczU+Efhf6MHuq
GFUC2KB03zXX5mm9JlMe1w/R2k2Kj+BHyzD9ykAIl07HlHHg/GofFuBAfHtDeBhm
mTScUADXlONDHSTNnLYB3nycO4Ep9s60bNKhqRWP2fik2YvQwcGLSWrsiAvv+AJ7
OtrZRaGw0qR93TWPyikp
=LM48
-----END PGP SIGNATURE-----

--HVbsw1MtpLdWwAXOlGE0biFM4wubeEpIf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
