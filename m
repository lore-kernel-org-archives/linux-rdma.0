From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Fri, 29 Apr 2016 11:06:46 -0400
Message-ID: <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me> <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com> <20160429051755.GC774@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ccpXMOIp9o5IHsH1VL8oe7vvlwrpRheA3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160429051755.GC774-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ccpXMOIp9o5IHsH1VL8oe7vvlwrpRheA3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/29/2016 01:17 AM, Leon Romanovsky wrote:
> On Thu, Apr 28, 2016 at 10:09:15PM -0400, Doug Ledford wrote:
>> On 04/28/2016 10:01 AM, Or Gerlitz wrote:
>>> On Thu, Apr 28, 2016 at 2:56 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wr=
ote:
>>>> On Thu, Apr 28, 2016 at 02:17:29PM +0300, Sagi Grimberg wrote:
>>>
>>>>> FWIW, I'd love to see ib_rxe upstream asap. In fact, I even have
>>>>> some patches to contribute for it.
>>>>
>>>> We are planning on submitting it in very near future.
>>>
>>> So.. lets get this going, Linus made a comment [1] that we might not
>>> go up even till rc7, which means there very little time left, Moni?
>>>
>>> On a related note, is there ANY patch merged for 4.7? Doug, are we
>>> again going to have have it in
>>> all-patches-merged-on-the-same-night-10-days-after-the-merge-window-o=
pened
>>> manner?
>>
>> I have topic branches started.  The generic RDMA READ/WRITE API is
>> almost ready to go once Christoph answers the last few things.  That's=

>> really the only one in queue right now that's big in terms of core
>> changes, most of the rest of the stuff is all driver or ULP specific.
>> The RSS patches haven't got much review yet.
>=20
> Doug,
> These patches are long time here in mailing list and they were reviewed=
 as
> all other patches in this mailing list.

That's not true.  The RSS patches in particular tend to get no review.
No one appears to care about them.  V1 was posted way back last year and
no one had anything to say about them.  I don't know when V2 was, it's
no longer in my mailbox.  Then v3 has been on the list for 12 days and
again, no one has responded.  No review at all does not mean
automatically accepted.

My slowness on the patches is that you are doing this in an obviously
device specific way.  The only device that will support RSS this way is
mlx5 devices.  But, I'm wondering if there isn't a more generic way to
do this that can be done in the core or in the driver during WQE
processing.  Maybe we can scale performance by having a more
multithreaded process approach without resorting to firmware specific
effects.  If that were the case, that would be my preferred way to go.
Until I have the spare time to investigate if this approach is possible,
it leaves these patches in limbo land.

>> The SELinux patches are in RFC stage, and IMO should be shelved until
>> verbs 2.0 API is settled so we only have one API to apply it too,
>=20
> SELinux code adds hooks which are deep in IB/core code and doesn't
> play with ABI at all.

They snoop ABI.  If they ABI changes, they would possibly need to be
changed in order to continue to be able to read the elements.

 This is unrelated to ABI change initiative which
> anyhow will be required to support existing IBTA specification.
>=20
>> --=20
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>               GPG KeyID: 0E572FDD
>>
>>
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ccpXMOIp9o5IHsH1VL8oe7vvlwrpRheA3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXI3iGAAoJELgmozMOVy/dzMIQAJLsOcImRjMdfQJnkRiH1juP
U/TH4oMEp/fAIwHEsMIEJMtJ8Ee1+fg9DdhOXIRxQkDCT8PTEQZ1AqhbZbYJI9wT
ZlE6ut534JVz3ETYdeLU+vWCso5hT0hFau1DLnS+bH1W6RhM5tf88OxLt1VTnjUq
kksPD1lFWVsnLoNJRvIrKI2713eixMNYN85HpqhjFjcJ0h/qcqTcQGYGMSDPRHwl
vua8oasRj1E8WmvHVTdhHczFzeiJ7Jz+6qUnxpwkw4K38IdD7aA1e6tH04MbKSqc
PhegbLmvA+tbR7fXQ9NYWHb7t2QWDKfUolBb0ac+WBF23uQ0aS50M+xb29HAzt3+
1JbA/V01j2SWvHdXcVJQi04mJ9qM19ZX9JbYiOLgsWwTyk258BBAXCiSz6S1lGqk
VqYwkMjl9rSGwv95Ff9/KKTF4HAOFdcZ/NIhBAUFFA3R+N5VREYfBFEy52JVdRg4
DNBEJoFCCRWl5vkqksNz+xo2G9C4daGoT1gxuek24s14Y5/SyWDDp8SaQvfjgq73
/aSgKkBcuNOytRlBVnSgwoe9J1E2VgI6sF1+ZIuUCFMj6T6GzB0muigffnD6yBeB
UfMxuhzfHvK3J0lE87vCVaLASrQtzPFi64dOaHOP7v3AnPVIT4NwlEO0eCbm9LKi
g1u+l/4Lzl2v0lQEBQJD
=oetQ
-----END PGP SIGNATURE-----

--ccpXMOIp9o5IHsH1VL8oe7vvlwrpRheA3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
