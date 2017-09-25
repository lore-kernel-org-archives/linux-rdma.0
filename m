From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
Date: Mon, 25 Sep 2017 10:53:01 -0400
Message-ID: <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t0gCGPSnKk63V0qmxI49Th3bWRcwjHIm5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170925035910.GL25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t0gCGPSnKk63V0qmxI49Th3bWRcwjHIm5
Content-Type: multipart/mixed; boundary="xKfNx8E8avpu9v1MTwb8OeahlPggnwHCb";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <5abacb7d-3e86-4e12-ce95-a8fe472a6a09-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085-5FK+k9557ZBZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <1506179005.120853.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925035910.GL25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170925035910.GL25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--xKfNx8E8avpu9v1MTwb8OeahlPggnwHCb
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/24/2017 11:59 PM, Leon Romanovsky wrote:
> On Sat, Sep 23, 2017 at 11:03:25AM -0400, Doug Ledford wrote:
>=20
> <...>
>=20
>>
>> I want any shared pull requests to be based on nothing newer than an
>> rc2 kernel.  I branch my for-next branch at rc2, so if your pull
>> request is on something later it will pollute my main for-next branch
>> to merge it.  I plan to merge my own -rc pull requests after rc2 into
>> my for-next branch, so you won't be missing code that goes into later
>> rcs if you base your work on my for-next branch, so that's a second
>> alternative starting point for your shared pull requests should you
>> need it.
>=20
> From our experience, it is not feasible to demand shared pull
> requests on "newer than an rc2 kernel".

I said "nothing newer than an rc2 kernel".  Did you mean to leave out
the nothing?

> The magic of shared pull request
> is in the fact that it is based on the same origin for both trees.

Correct.  So, for instance, I'm opening up my for-next area today and it
will be based on a clean v4.14-rc2.  What I'm then asking for is that
subsequent driver shared pull requests be based on a v4.14-rc2 tree.
Your last shared pull request was mostly OK, but it was based on a
v4.13-rc4 kernel and so it would have simultaneously brought in your
patches and also all the changes between 4.13-rc2 and 4.13-rc4.

> In our case the same origin is Linus's tree and his official -rcX, whic=
h
> for sure will be in both trees.

Right, that what I want.

> Once shared pull request is based on that tree, it will apply cleanly
> on both netdev and RDMA without pollution of the trees.
>=20
> And again, shared pull request shouldn't be based on any patches
> accepted to netdev and/or RDMA which are not in Linus's tree.

Exactly.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--xKfNx8E8avpu9v1MTwb8OeahlPggnwHCb--

--t0gCGPSnKk63V0qmxI49Th3bWRcwjHIm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZyRhNAAoJELgmozMOVy/dDK0QAI/odHxhegVNVhwQo5kwiLS5
GHvaAx9cXucTPVRtuIsdBVxLGtM8+/8H4xfq/hSW6MG1WjA/BuuKdDwqwVmnIIqK
RboAotcjcr/owAFXhZz3asW9au5DU3cCOrkXnn3gAZDWN18NeHZYXJ0QgP5C89Ue
Cs67R5UMWbFRMr5bAHhvVXzQIUITBS33UrIGPgYSyQ1tQYaQpACt09/Yu19ZT6U8
QdmVMP/Z8GA/uNymwYvA275/BHtNEioIafcVJFimtICSUisAvdwruk2Uhrl6+RXm
wsDXQXi2mejfoM8mOkW7l+qVB/RzFgFwU3rcD952y/ut7nivK8W+ltkMoQg4EDOq
EPUyG7c9lDDlp61oOxHdvLJdtcC+eXaytkarhCPb//8yOQR1wJAxaKVNc/uu+nfv
1s8ioFQJUcv2vrm3aFkRHT57dnz5lUEz6tsQsIrjIZbSMqvpCisxR143xe99glnE
s97QcrAT9fE2vXoGXfRgWLGGtgZA1jesh6Osq6z2wij8GpeJr4ch27PGjTKdQhpB
m2Tw/I91fgCHD6JiGxehE76etfMNvOlGTfXM6pLoRZbC/RRqMJdnk7lIH7KBuEbr
RKUbs0fA5O68ebfmUy5eRslCS46HbffsNiJuPTHZvETveR7eAXkY3uVUQHt53B1T
P/sVszkrnjRJ1/933Ge/
=/PFn
-----END PGP SIGNATURE-----

--t0gCGPSnKk63V0qmxI49Th3bWRcwjHIm5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
