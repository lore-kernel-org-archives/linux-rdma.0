From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Tue, 20 Oct 2015 12:31:07 -0400
Message-ID: <56266C4B.1060000@redhat.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
 <CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
 <561E510C.8060501@redhat.com>
 <CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d37ehHUpKpLwGG2Os20Kj6b2u2fGXtdsn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d37ehHUpKpLwGG2Os20Kj6b2u2fGXtdsn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/20/2015 12:25 PM, Or Gerlitz wrote:
> On Wed, Oct 14, 2015 at 3:56 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 10/14/2015 12:51 AM, Or Gerlitz wrote:
>>> On Sun, Oct 11, 2015 at 11:58 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>>> Hi Doug,
>>>> As we're soon on 4.3-rc5, could you please update how things look fo=
r 4.4?
>>>>
>>>> The mutlicast loopback prevention patches from Eran were intially
>>>> posted ~two months ago and went through testing by Christoph and Co.=

>>> [...]
>=20
>=20
>>> Hi Doug,
>=20
>>> So we're after rc5 and not a single word from you re the plans for th=
e
>>> next kernel, and your branch for that purpose contains exactly two pa=
tches... I do
>>> see few chunks
>>> of patches marked as under review in your patchworks, so there might
>>> be sign for getting some hope, is that real?
>=20
>> Yes Or, I'm working on it.  A new 4.3-rc pull request should come out
>> today and an update on the for next area probably as well.
>=20
> Doug,
>=20
> So we're after rc6 and still pretty much nothing in your for-4.4
> branch, are we getting there
> (e.g picking something from the backlog such as the self multicast
> loopback prevention and the
> rdma-cm name space patches) or for 4.4 we'd be coming naked?
>=20
> Or.
>=20

Another pull request for the final 4.3 fixups will go in today.  I
prioritized those over the for-next work.

Next I'll be pulling simple for-next items, then I'll be reviewing the
RoCE GID cadche usage in verbs/cma v2 patchset, then the Add RoCE v2
support v1 patchset, then the New fast registration API v5 set.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--d37ehHUpKpLwGG2Os20Kj6b2u2fGXtdsn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJmxLAAoJELgmozMOVy/d5+wQAKylpqT++OZeidcuyPsCky5h
AqWdWdypB62Q89GsXkhI3cnyvj+2VqV+rh9kyCguYyAEP8cZYQjBW3i3h2xaqAaL
690mZZT5oDe2o8E7JKj6TJ/Q0bE46LN0Mctb5ZcDpNfI8owPAsToM0ocbqS+O+gp
NtRevFbSmacT7MbSOoeebFH9aWuL11XfNE0sFo6bzCrk908sej4tSr9JL8SsSyTZ
PDGspvFlAJYh9XSPGXfAusL4K3TMZMJQUXrAYeKtqT4c5paNI2TvnP+CIkGjEqHV
vGU5Vq1eidEdxAwHf/D4VOXl3uPxZmuBtPJwnPvFQkr7hHQATeXagRjymcsffJu2
pTmQNihgfvB0/3QJzJ7zAw1USwjjDNnxM3fTkCkgwsxsET9T/J5cvUxhm3JSoB7H
VzgPIL2h+tPgal1vyonxOhTFlhvXgA885vxw9zMrKVzPSHLUB9B/G8y3NFhfGsv7
rV6eAbB7DzPXBkq2P/YXf6kZwC43MQu4ZJ05j+G4OwbH5ipn1yC39eP//K0OucqK
TPp55XU9vaOuqUhUO6/rftrGYAg2WxffkAWCfVFuwfHRS9yYLKtsXAtisoUbSaep
uTx1OMHBpMQhZthBlcCJPoXkhrfI9NWxvFkVeSJL5kOrKaiesM2TXW6Mqk36UPQP
XQctzDu8iJ8m3ntZXoZA
=YzGt
-----END PGP SIGNATURE-----

--d37ehHUpKpLwGG2Os20Kj6b2u2fGXtdsn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
