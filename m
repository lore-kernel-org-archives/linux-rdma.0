From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
Date: Tue, 26 Sep 2017 12:23:35 -0400
Message-ID: <4707c600-7aec-2c14-11d6-0443c2a835e3@redhat.com>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
 <20170925155749.GO25094@mtr-leonro.local>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3@redhat.com>
 <20170926051349.GA1230@mtr-leonro.local>
 <20170926065600.GA6816@mtr-leonro.local>
 <6fa41141-cae5-da51-94ef-afe5bdec22bd@redhat.com>
 <20170926162140.GF6816@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kXTOFwn066vFN48i3VLnlB2SSpuOfjPi8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926162140.GF6816-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kXTOFwn066vFN48i3VLnlB2SSpuOfjPi8
Content-Type: multipart/mixed; boundary="aKHLxpVbfKcFc6mP5dqAcocStiI03AlXX";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <4707c600-7aec-2c14-11d6-0443c2a835e3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085-5FK+k9557ZBZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <1506179005.120853.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925035910.GL25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925155749.GO25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170926051349.GA1230-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <20170926065600.GA6816-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <6fa41141-cae5-da51-94ef-afe5bdec22bd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170926162140.GF6816-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170926162140.GF6816-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--aKHLxpVbfKcFc6mP5dqAcocStiI03AlXX
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/26/2017 12:21 PM, Leon Romanovsky wrote:
> On Tue, Sep 26, 2017 at 12:03:01PM -0400, Doug Ledford wrote:
>=20
> <...>
>=20
>>>> He started to complain about empty merge commit with v4.13-rc1, and =
continued with explanations
>>>> about difference between back and forward merges. From my point of v=
iew, my intention to base
>>>> shared pull request on latest -rcX is exactly forward (good) merge, =
because it ensures that
>>>> all our future submissions for net/net-next/rdma-rc/rdma-next are co=
mpletely in sync and
>>>> ready to go.
>>
>> This is why, when I submit a pull request for -rc, I also merge it int=
o
>> for-next.  It keeps this up to date as you say, without needing to pul=
l
>> in all of the -rc, so it gives Linus an easier history to look at.  It=

>> does not, however, sync up the net side of things.
>>
>=20
> Doug,
>=20
> What is the bottom line for the bases for shared pull requests?
>=20
> Thanks
>=20

Just base it on either A) my current for-next or B) -rc2.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--aKHLxpVbfKcFc6mP5dqAcocStiI03AlXX--

--kXTOFwn066vFN48i3VLnlB2SSpuOfjPi8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZyn8HAAoJELgmozMOVy/dC7gP+wWaexwW892/hhJkZGs/F/q2
i2C9O/gq7G/rqRGZRMJoYqWoH7JB4UirdwU3RXtUGXgEdBAp8AqizeqzU9lwCPM+
9zqj+ciZux/d7tXMuhpicAcDqCKA0bEFZqglV9AReMg1l1foyHzxEIkZbeMeDHEx
RqdlLOVoyOqy9qAtdG+zeGdFrAmDIwKM48Mxxcg/JZID5mLEUzVVhISOHJlI6gg/
8lGn5fY9TYlgweX3NY5K4AtUiDxZy7jQR8mv0WJ4aJs0hWsUUoumr4crTrTJg9Ca
MIZOFCtQQpQHcrQIwutpurM5yi5Ia6d2WKFpElns6UvslrEfEyfy2MXUXykNd9An
UMds+UxdnOGoH7zZy4lYw0VLtVDELoRXqFAy2f2qR6yezKgjit4hApwfWX/ed023
f9YA9Fym4ZkyU3U3iIUjWHa9odPokyVonDyIMhBuAG91ADd4ceLgLKlxdib2SjzB
UwkA3KkXNFa/JVTvj5arGvSGkkpTukD67KBq07pKlrAFS35ZSJPApQKeDsVl9dnI
X8fu/rh7p5ysvdLyX00WaRD793xYnNM0LdfdyykvU4kXKMOP0m83YIhMqi9rdh9+
OOaUg9dokPO4k9dRzo8pRjpSBAgxIsNVdWDULDHz9GTmCyf2Oxa6aRaArlwGp1iN
tQ8a60gBiG7PFKzLNv+q
=xH+K
-----END PGP SIGNATURE-----

--kXTOFwn066vFN48i3VLnlB2SSpuOfjPi8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
