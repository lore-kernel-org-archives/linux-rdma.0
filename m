From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core v2 4/4] redhat/spec: build split rpm packages
Date: Thu, 3 Nov 2016 14:35:29 -0600
Message-ID: <581B9F91.4050407@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161020153357.27286-1-jarod@redhat.com>
 <20161020153357.27286-5-jarod@redhat.com>
 <20161027211059.GA7224@obsidianresearch.com>
 <20161028171147.GJ42084@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="i22uxodbjduFCpmlv32IPcPnBIIQwSIxR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161028171147.GJ42084-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i22uxodbjduFCpmlv32IPcPnBIIQwSIxR
Content-Type: multipart/mixed; boundary="RPDds5FG7b7Bg3BKFa2JWd6tm3sL9HWcj";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <581B9F91.4050407-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core v2 4/4] redhat/spec: build split rpm packages
References: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161020153357.27286-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161020153357.27286-5-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161027211059.GA7224-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20161028171147.GJ42084-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <20161028171147.GJ42084-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--RPDds5FG7b7Bg3BKFa2JWd6tm3sL9HWcj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/28/16 11:11 AM, Jarod Wilson wrote:
> On Thu, Oct 27, 2016 at 03:10:59PM -0600, Jason Gunthorpe wrote:
>> On Thu, Oct 20, 2016 at 11:33:57AM -0400, Jarod Wilson wrote:

>>>  Url: http://openfabrics.org/
>>
>> I guess we should change this url to
>> https://github.com/linux-rdma/rdma-core ?
>=20
> Either one works for me.

We should get the github url in.

>>>  Source: rdma-core-%{version}.tgz
>>> -BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
>>> +# https://github.com/linux-rdma/rdma-core
>>> +BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XX=
XXXX)
>>
>> I always wondered why there was so much variability in spec files
>> here.. I followed the Fedora guidelines, should we copy the above into=

>> the other spec file?
>=20
> I believe the current Fedora guidelines actually say "just omit
> BuildRoot", because rpm will figure out a sane default by itself. The o=
ne
> with mktemp was introduced by the security-conscious/paranoid, I just
> copied it over from another of the specs I was merging together here, n=
ot
> sure what the "best" route is here now.

We won't be putting this anywhere that requires the buildroot be
specified, so I would leave it out.

>>> +%package -n librdmacm-utils
>>> +Summary: Examples for the librdmacm library
>>> +Requires: librdmacm%{?_isa} =3D %{version}-%{release}
>>
>> Why the requires? Shouldn't auto shlib dependencies take care of that?=

>=20
> Probably. I think this was another legacy bit copied over from a
> stand-alone spec file.

Actually, no.  When you have a -utils package that goes with a library
package, standard procedure is to tie them directly like this.  The auto
dependency stuff will allow, say, librdmacm-1.1.17-1 and
librdmacm-utils-1.1.16-1 to happily satisfy each other since the later
librdmacm provides all of the sonames and apis that the -utils package
needs.  This is as designed as you want a librdamcm update to not
trigger a required update of, say, openmpi, unless there is truly a
change that requires it.  But, for the utils that go with the library,
even though we don't *have* to update them with the library, we want
that to happen automatically, so the explicit requires makes that happen
even if librdmacm-utils was excluded from the update command.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--RPDds5FG7b7Bg3BKFa2JWd6tm3sL9HWcj--

--i22uxodbjduFCpmlv32IPcPnBIIQwSIxR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJYG5+RAAoJELgmozMOVy/dn70P/2aAopGF3jLynodwYbTFy70o
bEWsOgoz7WZTSMzuc/QRIWCSsXMMv/LM6bLDNHaovmuhM5nf2nNn6/0Bl2jUQUYy
PXkwrUojHDLpawki9v2S/BobUcSlkgDe5HDvlgQujMbSrZrej5m75S/BASGMVuAn
rRZzgUsp78FA6DrJQL4zGIn/vl8TJ95LUMBN7Y/pW6L5/of96jxBYcadwGdf4ppJ
brJ62ifawBrtZKsTvNCOv67HrbVSI2VI0tBaCM9EKR7aVYD2+aH95DdvXnfOaHno
tAWLBsZ8sShqgcKjGhUx7nTipXq57WiRH1YyOdeGSsATA3YD3qqPHwbCvFvkH1LK
dwb62CiY17dS3i6sH5nxYToBUcVPtcxD3o/8fGc2jJEXZ4DZTsKYNIjY47slneMV
qJEDfpsXgOzr2hGOxUF/4gNBWFVJLoW+FRab9PgKahuE7aZ3N4BXvQGVhkBZNX4d
706uL36BtfF/dlpF4rg5hxTRZAPRnd2VnBmvjgcZPEVyj60X9gj/dlsVB38GD7GU
q3zA7tqsQb1i1WFP16qWisH7zq5AeleYuLaii/19NGnocBf3FBP3Z645m6F9f2/4
N0my5asDbuuST4SuDkOqdw0g0BP6vfb8yASvYZETB8n6v37U64CqdzxbWNKyU2jU
KpXoj6XL8t4zCvsVRxEj
=UIh+
-----END PGP SIGNATURE-----

--i22uxodbjduFCpmlv32IPcPnBIIQwSIxR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
