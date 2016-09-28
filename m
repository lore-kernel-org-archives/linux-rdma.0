From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
Date: Wed, 28 Sep 2016 14:55:11 -0400
Message-ID: <57EC120F.7070506@redhat.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-12-git-send-email-jgunthorpe@obsidianresearch.com>
 <57EC0B75.3000101@redhat.com> <20160928184708.GA31472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="6UDcbDSkXme6cBLXU9UoVOrR5QUGPbqG6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160928184708.GA31472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6UDcbDSkXme6cBLXU9UoVOrR5QUGPbqG6
Content-Type: multipart/mixed; boundary="9jrVQ0hFQ8x4sXLBK0XKJJIscTvB3tx8G";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Message-ID: <57EC120F.7070506-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
References: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1474658228-5390-12-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <57EC0B75.3000101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <20160928184708.GA31472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160928184708.GA31472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--9jrVQ0hFQ8x4sXLBK0XKJJIscTvB3tx8G
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/16 2:47 PM, Jason Gunthorpe wrote:
> On Wed, Sep 28, 2016 at 02:27:01PM -0400, Doug Ledford wrote:
>> On 9/23/16 3:17 PM, Jason Gunthorpe wrote:
>>> Necessary to reproduce the Debian packaging.
>>>
>>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>>  CMakeLists.txt                       |  3 ++
>>>  srp_daemon/srp_daemon/CMakeLists.txt | 29 ++++++++----
>>>  srp_daemon/srptools.default          | 14 ++++++
>>>  srp_daemon/srptools.init             | 89 ++++++++++++++++++++++++++=
++++++++++
>>
>> Would it be best to have directories for related install files for a
>> specific OS?  For instance, srp_daemon/debian/ and srp_daemon/redhat/?=

>> It's not that I expect to put a redhat init script for srpd in place,
>> but the script for debian is likely to not work properly on redhat, so=

>> having it in an OS directory would at least make that clear.
>=20
> To be clear, there is already an initscript that (perhaps?) is for
> RedHat - but it isn't even close to the Debian version. So this patch
> introduces two scripts for srp_dameon, which I hated doing..
>=20
> I'll drop this patch from the series and we can go ahead with the
> other patches in the series.
>=20
> For now I'll put the initscript in the Debian packaging patch and we
> can think about what to do later. I think it can be moved to the
> debian/ directory as well.
>=20
> Going forward I think we need to make some decisions..
>=20
> 1) Do we want to do something with the initscripts so distros can use
>    them? Is that even possible? I think Debian uses the bundled
>    acm initscript, didn't look at suse.

I'm in favor of providing a good, reliable, correct set of startup files
for each of the major distro flavors.  One of my main reasons for that
is it makes it possible for us to try and provide some level of startup
script parity and commonality between the distros.  And allows us to fix
bugs across all the distros as once even if we didn't necessarily hit
the bug on each distro.  Of course, the distros may ignore our scripts,
but we can try.

>=20
>    Is Debian the only major distro that still ships init scripts?
>    Does FC/RH exclusively ship systemd unit files now?

We're almost entirely systemd now.  We only have EL 6 that still uses
init scripts, and I doubt we will ever put this package into EL 6.  So,
we might as well be all systemd as far as this repo is concerned.

>    Maybe we should delete the initscripts entirely.

Not if Debian still uses it.  And I'm not opposed to providing a Red Hat
init script in case someone wants to put this package on EL 6 themselves.=


> 2) I'd like to support cross-distro systemd unit files upstream.
>    Is that feasible?

Maybe....I'm not entirely sure about that.

> We are short unit files, could you
>    contribute yours?

Absolutely.  I'd like to basically import the entire redhat rdma package
into this, but it will take a little sorting things out to get all of
the files and such in the right place.  And that's a precursor to our
srpd unit file as it lists a specific dependency on the rdma unit file.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--9jrVQ0hFQ8x4sXLBK0XKJJIscTvB3tx8G--

--6UDcbDSkXme6cBLXU9UoVOrR5QUGPbqG6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7BIQAAoJELgmozMOVy/d5yQP/i598bEtO2GzhEVxTfdICXtY
ie7NVwi9WX1vGfqGB5QEirlJWrf7m3ag/C8W290WTUNsiSmpxoHntIjnykCXtFMS
G30Ru2rsU4+TG0hA65N/g9g0gxArvY6Mfkn/e7tyjAq9yLtmOsPB0iF34j2pevi6
blf/j/ZYzG3QkhbhPqB7JkeYc/Yw0ztyS9so76AuGh8AVhlwRoyGMGuQoSY70fxP
pmAFU/qJoHIkxEdqog3dmL2+m6fZKW4eAtb1u+FC54iLmMWy7G7616t2Ic4M9xT0
EakzJvaVxQlf+YqbJqbZXdOWIJ/hJd9wd8SLoeGHTpTYe1btaV0acqcDYi3iD+1m
YLtj/HhD6dgo0cRLaojDgy9ciPPDPfHJP3UDd6cyYe4HJJWu0MiZjvq6XVfWmo24
doohHekZpTdfuA/AsDNhb5ib1j1HOutbsuFZjltYB/hgzzpw5YxWyudX9JUkozxN
kf01eaDffkrsaUOivlscyECpSs66IvWSawlfNRBnmzYR7LTxFgunyy5AfDekw0xO
ptgkp6GcPqh13SskHNZ6IGfOaDdjrzHn6RKi6N/wY5NbbsNvGfo0DXR60VzdNUCM
oWFJgfPSi/J3rWy6vWoW4XZBHHOafgyoKLhO28MBop9KdakB0oh0ejQIoaUrIHoK
nJPfPPG0D0Q3lWG5CV+o
=cjXo
-----END PGP SIGNATURE-----

--6UDcbDSkXme6cBLXU9UoVOrR5QUGPbqG6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
