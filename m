From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: deprecating amso1100
Date: Wed, 29 Jul 2015 10:34:50 -0400
Message-ID: <55B8E48A.5080608@redhat.com>
References: <55AE93E0.9060002@opengridcomputing.com>
 <1AE4059B-F6BD-48ED-A1C6-8A9024DDF217@redhat.com>
 <D2F193D21ECD8C45917AD3D5B26513300C49590A@CRSMSX101.amr.corp.intel.com>
 <0F66BC31-60A1-4513-B858-17A75BFD42DA@redhat.com>
 <55B8E30D.5090205@redhat.com>
 <017301d0ca0b$423decf0$c6b9c6d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vGtTsnXJTdMHxdh6V4EBL9uD64SgrL1Lj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <017301d0ca0b$423decf0$c6b9c6d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vGtTsnXJTdMHxdh6V4EBL9uD64SgrL1Lj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/29/2015 10:31 AM, Steve Wise wrote:
>=20
>=20
>> -----Original Message-----
>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>> Sent: Wednesday, July 29, 2015 9:28 AM
>> To: Dennis Dalessandro
>> Cc: Steve Wise; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: deprecating amso1100
>>
>> On 07/21/2015 04:45 PM, Doug Ledford wrote:
>>>
>>>> On Jul 21, 2015, at 4:42 PM, Dalessandro, Dennis <dennis.dalessandro=
@intel.com> wrote:
>>>>
>>>>> -----Original Message-----
>>>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>>>>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
>>>>> Sent: Tuesday, July 21, 2015 2:49 PM
>>>>> To: Steve Wise
>>>>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> Subject: Re: deprecating amso1100
>>>>>
>>>>>
>>>>>> On Jul 21, 2015, at 2:48 PM, Steve Wise <swise@opengridcomputing.c=
om>
>>>>> wrote:
>>>>>>
>>>>>> Hey Doug,
>>>>>>
>>>>>> How should I submit changes to deprecate amso1100?  The HW hasn't =
been
>>>>> sold since 2005, and the SW has definite bit rot.  Its time to remo=
ve it...
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Steve.
>>>>>
>>>>> Send me a git patch that uses git mv to move it to staging and we=C3=
=A2=E2=82=AC=E2=84=A2ll leave it
>>>>> there for a release or two and then remove it after that.
>>>>
>>>> Steve, "git format-patch -M" does a nice job creating a patch that c=
an actually be looked at via email.
>>>>
>>>> http://marc.info/?l=3Dlinux-kernel&m=3D143593782206479&w=3D2
>>>>
>>>> For the Ipath driver I was going to send directly to the staging mai=
ntainer/list. Doug, should that come to you through linux-rdma
>> instead?
>>>
>>> I sent an email to Greg K-H to ask that question.  It doesn=E2=80=99t=
 matter to me.  If you want, send the email to this list and if I get a r=
esponse
>> from GKH that he wants to take it, I=E2=80=99ll just point him to it o=
nce he lands.
>>
>> I'll be sending these through to Linus (as agreed with Greg).  However=
,
>> the patches need a TODO file added to the driver directory when it is
>> placed in the staging tree (that's a mandatory requirement of being in=

>> that tree).  In this case, the TODO would just be to remove the driver=

>> as some point in time.  That point it pretty arbitrary, but I would
>> suggest removing the driver in the 4.6 merge window.
>=20
> Sure.  Will you create this file or do you want a patch from me?

If you don't mind, resubmit please.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--vGtTsnXJTdMHxdh6V4EBL9uD64SgrL1Lj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuOSKAAoJELgmozMOVy/dQoMQAIV77wN3Pe1RPoSr/J2X/k1m
bZ/8HkFXbIuexVFlk8QXjwM7wnUf+StO5bdG800LNooqnDkyM42wJ67/eqvhq+vO
S30E4q5Wmn+m0BT46t6w3uNW0WPnfcs3TUkTl5w1N6aoZf/x7zC+5zfvnf0y+WfA
imuwaQEsefMumC/9tDuoOuaLovEzub7liO3LYw6fPGCCfF0Akxej3jAGADhGijd9
GZfTyxQ3EuxWMt25NB/Nds/GVBRQAnbq5wEU0t+SjJ9flnu9gmO3gjNs3QeNawIQ
0EYJ6Hxo6b6Z+BayT4iKrT/lQcSyIA68w+RxH6P2IdEV4B/7vQ6xp5e8X6ggdSDm
NHdtWRzuBIg20XBHAu/biwRwOmv0IhEK8KcCKxFOMKuIvzExAm4SeUR9wIVrWG58
F7K9Szxk7+HE+eiSkdyrXbVru66UAt9d17oxE5yM36pkPtk/B5fhdjrc/lZAq0yw
ASb7w2rRi8YS/cqI0AxTwkEGmfEDKYbdRD3EVh2c978UFaaSxvnuzzT9DO3k1R93
t9VrZc6ig3IfdP40ju5kHK6mpdjeAjOkmSXeKf12zeArcp2oR/+hg/UwjRWRAtOr
dx3+4W6O7g1D0pbDYkpwhlk7m8cyOSGsTtt89IhbL+yD/lbgg+6niZobzaIT9Q+H
HQcaZTlBb5I7OVfLEyxB
=pulx
-----END PGP SIGNATURE-----

--vGtTsnXJTdMHxdh6V4EBL9uD64SgrL1Lj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
