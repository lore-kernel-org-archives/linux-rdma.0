From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Tue, 24 May 2016 13:57:54 -0400
Message-ID: <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IclfCcOB3j7BTxQjeoW9nSVmRekeVfh1f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB141819B27F9AAA360DCB420FB14F0-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IclfCcOB3j7BTxQjeoW9nSVmRekeVfh1f
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/24/2016 12:02 PM, Liran Liss wrote:
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> ...
>>
>> The following is a sketch, or outline, for an ioctl framework.
>> The purpose of the patch is to drive discussion and feedback on variou=
s design
>> decisions rather than low-level comments on the code, so that the chan=
ges can
>> be incorporated earlier in the development cycle.  The code is entirel=
y untested
>> and some functionality is not coded.
>>
>=20
> This approach focuses on facilities for arbitrary device-specific objec=
ts (which could basically fit GPUs, NVMe, whatever...), while our primary=
 goals are to replace write() with ioctl() and strive for a common *rdma*=
 object model.

Please be precise when you use the word "our".  In particular, I do not
count myself among your "our".

> In contrast, the patchset [1], focuses on the task at hand. The emphasi=
s is on a common framework for parsing and parameter validation. It follo=
ws the agreed-upon

Again, precision is needed here.  Agreed upon by whom?  Not I, and
evidently not Sean either.

> concepts such as a single ioctl request code for common objects,

I'm not sure I agree with this as a priority.

> natural mapping of the existing object mode (and hence easier backporti=
ng),

Nor this.

> typed attributes for extending the objects to accommodate multiple vend=
or features, and a unique ioctl request code for vendor-specific commands=
=2E
> --Liran
>=20
> [1] http://permalink.gmane.org/gmane.linux.drivers.rdma/36984

While concalls to discuss these topics are handy, it is easy to miss
objections or alternative priorities.

So let me sum up how I see things.

First, we had a security issue that needed addressed.  We did so with a
security check on the current ABI.  During the discussions about that, I
specifically told Linus we wanted to address it that way for now so that
we could work on getting the verbs 2.0 API that addresses some of the
shortcomings of the current API out the door, but do it right and not
rush things.  That verbs 2.0 API would fix the security issue up
completely where the security checks are no longer needed.

What we have today is a proposal to basically take the verbs 1.0 API and
convert it from write() to ioctl() with as little change as possible to
the API.  This is what the patchset you referenced is all about, and
what you and Jason have been talking about.  Allow me to be clear: this
is not verbs 2.0 API.  This is verbs 1.0 over ioctl.  Nothing more.  And
it does nothing to fix up the shortcomings of the verbs 1.0 API that are
playing out right now in things like the timestamp pacthset.

Sean's proposal does away with the rigid nature of the current verbs 1.0
API and makes it much more flexible on a per-driver basis.  This doesn't
address the end user API issues, but it at least cleans up the user
driver <-> kernel driver API so that one vendor's driver is not forced
to carry around all the baggage needed for every other vendor's drivers.

Under that model, each vendor only carries what they need.  It would
then be libibverbs responsibility to take that driver specific data and
present it to the user in a generic way.  The mechanism of that is not
yet known, but thinking about it is what prompted my email in the
"Further thoughts on uAPI" discussion, the one where I made the possible
wc processing example.

This is why I don't think it's possible to think about the verbs 2.0 API
and not also the user visible libibverbs API at the same time.  If all
we want to talk about is verbs 1.0 over ioctl, then yes, we can do that.
 But not if we truly want to discuss a verbs 2.0 API.  And I have yet to
gather from the discussions I hear from people that we are in fact
decided on pursuing a verbs 1.0 over ioctl API instead of considering a
verbs 2.0 API.  So please don't present things as though they are
settled.  As far as I can tell, they very much are not.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IclfCcOB3j7BTxQjeoW9nSVmRekeVfh1f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRJYiAAoJELgmozMOVy/dsKcP/0Q1KF1TtTY5z68APRYlCAx7
eMTfh6pqh4hXovp0rNp2gg9/OL47uHItRDTKVQ16ti77Rg4dx4DB5gnV01mfkQbx
3P3GHhoFVY/1FCOAzNFmotb8Fm7FVNFebGl1V4TcXc7gaasjqvmOBmG0lLefUdEw
FA8gHRK+CTumK/XxsVtxnfC5BeSyqDo8cu8KIxR6spZD/JOP9Gb3UZCSgLG39Qv0
FomfDbUR1nYhCtafryTRXB8+MAXB0lv46EvqwSfSk58bl6ZygCcHeb0WJypwUaO0
ONGvesp7U75+RcxPpLaqjUQfmaXGcgkWJXLCeMou37NlbcSXYM00A5/oY0tYRqYe
Ie9MqPBoQOYuNublEP48fyXk40+z0PZ9wIaeisds46IVyvZylsmZBYBvXFiwUzpB
S0VCYLeMMix93rAD+fGwfHtGliTn4GY/7YytRCCBnVhtwWJyS7+P5NOhWOjjOohp
e4qdcjSF891gN8GpfMj+5/dOLZqG6iCPpTLflj/3Dd0s9Up3U9NhaR9gktMXw8S1
gUor2BtNplsrz5kRn1TnCfig3MIQW4Z231QQc7Y02/h/w2vkvlrv82cT9HXwjxZ6
k0hFN+UGrz/NfGX9EvcrCqnEOR3xB9/fhJqEdWYSqlq1RJSa9OeUdhatnGKCav0P
DLAskhF0z+3paKGcdwOu
=OWTs
-----END PGP SIGNATURE-----

--IclfCcOB3j7BTxQjeoW9nSVmRekeVfh1f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
