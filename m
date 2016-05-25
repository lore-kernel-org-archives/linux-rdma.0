From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 0/2] libibverbs memory barrier fixes
Date: Wed, 25 May 2016 10:57:42 -0400
Message-ID: <5745BD66.20404@redhat.com>
References: <20160520200053.6983AE0B9D@smtp.ogc.us>
 <3ffd3089-ede9-aebf-4781-2e012bc65252@redhat.com>
 <00c801d1b694$f9d7f5b0$ed87e110$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="skGVR1OVtGUJuIOfh5BIKWsoKO3xrMRPg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00c801d1b694$f9d7f5b0$ed87e110$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Noa Osherovich' <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--skGVR1OVtGUJuIOfh5BIKWsoKO3xrMRPg
Content-Type: multipart/mixed; boundary="axe1mOD9P52lXOLwoVfWMnrKur9Q2qLkc"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Noa Osherovich' <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <5745BD66.20404-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 0/2] libibverbs memory barrier fixes
References: <20160520200053.6983AE0B9D-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
 <3ffd3089-ede9-aebf-4781-2e012bc65252-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <00c801d1b694$f9d7f5b0$ed87e110$@opengridcomputing.com>
In-Reply-To: <00c801d1b694$f9d7f5b0$ed87e110$@opengridcomputing.com>

--axe1mOD9P52lXOLwoVfWMnrKur9Q2qLkc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/25/2016 10:51 AM, Steve Wise wrote:
>> On 05/20/2016 03:43 PM, Steve Wise wrote:
>>> This is v2 of the ARM64 mb* support, plus an additional patch to fail=

>>> compiles if there is no platform implementation of the memory barrier=
s.
>>> I've included the 2nd patch because I think it is important to not
>>> assume any default barrier implementation.  Getting it wrong can resu=
lt
>>> in data corruption.
>>>
>>> Changes since V1:
>>>
>>> Put the RFC tag back on because I want to retest this series.
>>>
>>> Implemented the ARM64 memory barrier macros from scratch using the AM=
D
>>> reference docs.
>>>
>>> Added 2nd patch to fail compiles if no mb* macros exist for the platf=
orm.
>>>
>>> Steve Wise (2):
>>>   libibverbs: add ARM64 memory barrier macros
>>>   Fail compiles if no platform specific memory barriers exist
>>>
>>>  include/infiniband/arch.h |   15 +++++++++------
>>>  1 files changed, 9 insertions(+), 6 deletions(-)
>>>
>>
>> Please remember to use --thread=3Dshallow when sending patch emails us=
ing
>> git send-email (which is what I assume you did).
>>
>> Let me know how the testing comes out.  The patches look fine to me
>> (thanks for adding the second one, it's the right thing to do).
>>
>=20
> Hey Doug, the series tests good with cxgb4 on ARM64.  Do I need to repo=
st a
> final series, or can you merge v2?=20
>=20
> Hey Noa, have you all had a chance to test this series?
>=20
> Thanks,
>=20
> Steve.
>=20

Repost a final please.


--axe1mOD9P52lXOLwoVfWMnrKur9Q2qLkc--

--skGVR1OVtGUJuIOfh5BIKWsoKO3xrMRPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRb1mAAoJELgmozMOVy/dGzYQAI7SWWJ0RDYEQ8GiE3PZ8NYo
v4ITv/pttA3b/tGdHzm5drJVlT4B/C+TNePxsWOMESnXcfF6wNkgHQPMVNuHy+dw
IYqeRBiHTCXX/uLAXA+0mdQz8wKDK+fBM2RCLxjJhDnTQvrjQuOZvGyRQZcoGyKG
jACCkvbIlp2rHrjlIKTK7oiYxEiBWokQG674jBg1o5xUo8b7/H++jpjtdwTEaupw
99QsSLiBR4GEDAhDR+eppWQ+4uK+lohpDI7BhSbzvTp3QjLwbaDEM4I3aufUI8sr
KiFdpE+XHCYdNpEMGGE0SjVRk6NasXqIHdjjrrbkjr3AzPDO3pokySouCpwSFucu
BxL9PWpgOTjxGemfrwGeryu3aXxl+T3OQU4dlw+c0oU5ayMmqw7vPsm0rQBKmxXr
KEZ+rTEphRQvbTnJcV5YEToWYgkOhcc9cFgvGHypzffVbuq65WqDuqM0bdHBOllg
uQ4mkm55/8h3wpxZa8mg6HFiRlkv/DHtfhkl8h0axMFIXeIKpw8Cx+Xh8kxVcd0l
AR05tGCBeBcAhV75vM+SM9NaxcZ1ib3PMFNEGTc9QFUCwVqAiq6Yl5tBclt3/HLm
50Rz+3WfE5U+9EHSO3yPOrqLrnoHGFWmU/dHEXPEM46bYQQPnXWtiUxRXvbePzN1
Z2fF/ZrEJvdtUzQM773W
=fxUH
-----END PGP SIGNATURE-----

--skGVR1OVtGUJuIOfh5BIKWsoKO3xrMRPg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
