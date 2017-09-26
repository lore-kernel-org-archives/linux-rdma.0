From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
Date: Mon, 25 Sep 2017 22:31:47 -0400
Message-ID: <7c01cef3-0471-8339-3498-1d9ec4f8a9d3@redhat.com>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
 <20170925155749.GO25094@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LvCBOLN3j5NePmh3VOwgTvgGqWbw4s8Xt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170925155749.GO25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LvCBOLN3j5NePmh3VOwgTvgGqWbw4s8Xt
Content-Type: multipart/mixed; boundary="R746BWfh0q7SIU4WQK8osJgNJHfe7OsoJ";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <7c01cef3-0471-8339-3498-1d9ec4f8a9d3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw patch
 submissions)
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085-5FK+k9557ZBZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <1506179005.120853.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925035910.GL25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170925155749.GO25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170925155749.GO25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--R746BWfh0q7SIU4WQK8osJgNJHfe7OsoJ
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/25/2017 11:57 AM, Leon Romanovsky wrote:
> On Mon, Sep 25, 2017 at 10:53:01AM -0400, Doug Ledford wrote:
>> On 9/24/2017 11:59 PM, Leon Romanovsky wrote:
>>> On Sat, Sep 23, 2017 at 11:03:25AM -0400, Doug Ledford wrote:
>>>
>>> <...>
>>>
>>>>
>>>> I want any shared pull requests to be based on nothing newer than an=

>>>> rc2 kernel.  I branch my for-next branch at rc2, so if your pull
>>>> request is on something later it will pollute my main for-next branc=
h
>>>> to merge it.  I plan to merge my own -rc pull requests after rc2 int=
o
>>>> my for-next branch, so you won't be missing code that goes into late=
r
>>>> rcs if you base your work on my for-next branch, so that's a second
>>>> alternative starting point for your shared pull requests should you
>>>> need it.
>>>
>>> From our experience, it is not feasible to demand shared pull
>>> requests on "newer than an rc2 kernel".
>>
>> I said "nothing newer than an rc2 kernel".  Did you mean to leave out
>> the nothing?
>=20
> Most probably I translated it incorrectly. I wanted to say that all
> shared pull requests will be -rc2, -rc3, e.t.c. and probably will never=

> be -rc1. Did you mean the same?
>=20
>>
>>> The magic of shared pull request
>>> is in the fact that it is based on the same origin for both trees.
>>
>> Correct.  So, for instance, I'm opening up my for-next area today and =
it
>> will be based on a clean v4.14-rc2.  What I'm then asking for is that
>> subsequent driver shared pull requests be based on a v4.14-rc2 tree.
>> Your last shared pull request was mostly OK, but it was based on a
>> v4.13-rc4 kernel and so it would have simultaneously brought in your
>> patches and also all the changes between 4.13-rc2 and 4.13-rc4.
>=20
> Why is it "undesired behavior"? Anyhow git request-pull to Linus will
> filter all patches which already exist in Linus's tree and you will get=

> merge of -rc fixes for free in your for-next.

You obviously have not been paying attention when Linus yells at me.
This is something he specifically does *not* want, and if you send me a
shared pull request that is based on, say, -rc4, then I can't merge it
into my for-next branch and instead of I have to carry a separate branch
and send a separate pull request just for that branch.

The reason is that Linus wants to be able to pull up gitk on my pull
request and see the changes I am submitting for easy review.  If I merge
a shared pull request that also includes an update to the -rc level of
my tree, then all those -rc patches get mixed into the gitk ordering and
it makes it hard for Linus to find just the patches he wants.  So, this
is a Linus issue, not so much my issue.  If he didn't care, I wouldn't
either, but this is the way it is.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--R746BWfh0q7SIU4WQK8osJgNJHfe7OsoJ--

--LvCBOLN3j5NePmh3VOwgTvgGqWbw4s8Xt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZybwTAAoJELgmozMOVy/dq7QQALVm8zjRWFhAqyzkn26xDRdb
MVg6cMb45+yC0f/evpnpylbrkMsaQ/a3oXjJU4pGYOKSh9uQp4G+vO7RhQNlgQZV
VuPEcUZV786wSK7ALtGJUTh0XazuZGzFEmqAEH7684Yl6mHxKeNcTHJaP3mwbOyx
JzESboAWulbYDmHqW03RS3X5CkZ5KqH8l5rtLiGE71SfRrntck1Ah3CZTucpVUr1
i9lySIIzVdVeppPhPGFrFiWALWd3G4T8ybzAxxzkOb8fIVOYVbnUkl2EAX58U+Y/
580rV9R04TIN02sO5t2zynCpYLKI9KhWW+C6xl5C8/iOT7qtn2gcrtRW4mMbuWi+
LybL+/oWJ53DnAKwin6udzneaogIOqzpLMwDbxlGBqkhVBPsTkq4dJqGqjtHwIIA
JBoGCnmUCgV8a7fD/P04FtuP9hRQ+2JI718CWoK6X3JAJnJH1Ln9QFzpM+6774Om
FJy60Z2DXSWjFdrDwqu4wKZM25jy1xkC3A7uy++XEd5K4ebdXNftTPTOsb/C3DwL
lgyDiR9vkzUJX5KDYYl0/kfvDMgiQ9EcFZNf7jkiZwcP4faqF/gevLbn5NycMYO7
q7OYdE9B6PwufZayBiWDRRXu8h4oTBDdMbL1C3KnrR2X+LHGhymtcihPkv0hVh70
A4v6VmlHXtI2I+8JglzX
=MujP
-----END PGP SIGNATURE-----

--LvCBOLN3j5NePmh3VOwgTvgGqWbw4s8Xt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
