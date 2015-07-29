From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: deprecating amso1100
Date: Wed, 29 Jul 2015 10:28:29 -0400
Message-ID: <55B8E30D.5090205@redhat.com>
References: <55AE93E0.9060002@opengridcomputing.com>
 <1AE4059B-F6BD-48ED-A1C6-8A9024DDF217@redhat.com>
 <D2F193D21ECD8C45917AD3D5B26513300C49590A@CRSMSX101.amr.corp.intel.com>
 <0F66BC31-60A1-4513-B858-17A75BFD42DA@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xgCMBJ9VUcP4tIacGmjdbNT03X5x2RMlg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0F66BC31-60A1-4513-B858-17A75BFD42DA-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xgCMBJ9VUcP4tIacGmjdbNT03X5x2RMlg
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/21/2015 04:45 PM, Doug Ledford wrote:
>=20
>> On Jul 21, 2015, at 4:42 PM, Dalessandro, Dennis <dennis.dalessandro@i=
ntel.com> wrote:
>>
>>> -----Original Message-----
>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
>>> Sent: Tuesday, July 21, 2015 2:49 PM
>>> To: Steve Wise
>>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Subject: Re: deprecating amso1100
>>>
>>>
>>>> On Jul 21, 2015, at 2:48 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org=
>
>>> wrote:
>>>>
>>>> Hey Doug,
>>>>
>>>> How should I submit changes to deprecate amso1100?  The HW hasn't be=
en
>>> sold since 2005, and the SW has definite bit rot.  Its time to remove=
 it...
>>>>
>>>> Thanks,
>>>>
>>>> Steve.
>>>
>>> Send me a git patch that uses git mv to move it to staging and we=C3=A2=
=C2=80=C2=99ll leave it
>>> there for a release or two and then remove it after that.
>>
>> Steve, "git format-patch -M" does a nice job creating a patch that can=
 actually be looked at via email.
>>
>> http://marc.info/?l=3Dlinux-kernel&m=3D143593782206479&w=3D2
>>
>> For the Ipath driver I was going to send directly to the staging maint=
ainer/list. Doug, should that come to you through linux-rdma instead?
>=20
> I sent an email to Greg K-H to ask that question.  It doesn=E2=80=99t m=
atter to me.  If you want, send the email to this list and if I get a res=
ponse from GKH that he wants to take it, I=E2=80=99ll just point him to i=
t once he lands.

I'll be sending these through to Linus (as agreed with Greg).  However,
the patches need a TODO file added to the driver directory when it is
placed in the staging tree (that's a mandatory requirement of being in
that tree).  In this case, the TODO would just be to remove the driver
as some point in time.  That point it pretty arbitrary, but I would
suggest removing the driver in the 4.6 merge window.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xgCMBJ9VUcP4tIacGmjdbNT03X5x2RMlg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuOMNAAoJELgmozMOVy/dGq0QAIPgLh7a6ObKrryO+AkLjiM0
rIds7LF66Y3KiUwib0URA0730tqzUjT6KbdQTi+mOltyAxKKH48hm4l6Qu0N8qJ5
QmxILSZxYf6mnfJ3C6dlBo1+ERJirPv563fhdld/Z51QaPB+2LFu3zQ+gxIYGoWh
9OCv3iHaGgq+AWzzenIrOXO4tqgUr00S9dxdJ3cMDuiB7FNQIgNAKkYU5+71BqcR
gqPkckwACz3E9fQuGla+TL8Xlsdo2tAyRkpdrMuzE/oof6chwGwRLnKi5I8YWpC3
GPiPUGVnECWovzlflZbTzI1GoUeTw7sGajqzJ4yXkXp0/4CBLFPZ+t0bdoSQ/q8E
aGYoaOAjm0heX2zGsb2iH+lsNxQZh2r80wdzCOPmWn0jUFcuBpTMy2QfjCZBS3t5
BqnpygiHYavRsLriqYTDlxGyhDBrLvPjVa8xnGWN8k9ec4xeuzjdQUDvbXAN+IMj
/1PmtEv07uOJtbNkJhJXLGdUJMq0ZOzOXLXQ5L5y966au/VdosVXbbGNAMX9IKYW
uP6JR+H1DkYHBuZauInFCAkSKu+3zbKzJrk8WGngZgefC2uXHOpuqeA76prJpr0j
BhiQkGWyUam+0g65yMe3UpHOz7j/4xoSbzPtR/7ZNe6d47qK7aRwJK5LEXoFwNAS
0SSIE91QhFVvd33lNgd2
=vPGu
-----END PGP SIGNATURE-----

--xgCMBJ9VUcP4tIacGmjdbNT03X5x2RMlg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
