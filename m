From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 7/7] IB/core: Change wc.slid from 16 to 32
 bits
Date: Wed, 9 Aug 2017 13:18:14 -0400
Message-ID: <bf3cb685-a0ac-9a5a-4bc7-19cde53f8b09@redhat.com>
References: <1496943469-44017-1-git-send-email-don.hiatt@intel.com>
 <1496943469-44017-8-git-send-email-don.hiatt@intel.com>
 <1502219143.3002.10.camel@redhat.com>
 <772a7324-5d42-3259-7881-483722fc1f2e@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XpewT2ALTMdxiDFhsKJmwDD97uCEIaCOE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <772a7324-5d42-3259-7881-483722fc1f2e-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XpewT2ALTMdxiDFhsKJmwDD97uCEIaCOE
Content-Type: multipart/mixed; boundary="EQNadoa6aJgORn9pwwQo3pE7KAX33a06s";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <bf3cb685-a0ac-9a5a-4bc7-19cde53f8b09-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 7/7] IB/core: Change wc.slid from 16 to 32
 bits
References: <1496943469-44017-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <1496943469-44017-8-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <1502219143.3002.10.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <772a7324-5d42-3259-7881-483722fc1f2e-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <772a7324-5d42-3259-7881-483722fc1f2e-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--EQNadoa6aJgORn9pwwQo3pE7KAX33a06s
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/9/2017 12:46 PM, Don Hiatt wrote:
> On 8/8/2017 12:05 PM, Doug Ledford wrote:
>> On Thu, 2017-06-08 at 13:37 -0400, Don Hiatt wrote:
>>> slid field in struct ib_wc is increased to 32 bits.
>>> This enables core components to use larger LIDs if needed.
>>> The user ABI is unchanged and return 16 bit values when queried.
>> Hi Don,
>>
>> My comments here are not really about this particular patch, I just
>> grabbed it from the pile as one to respond to.  But my question is
>> this:
>>
>> Multiple of these patch say the user ABI is unchanged and return 16 bi=
t
>> values when queried.  What's your plan for a long term solution to
>> this?  Eventually, the user ABI will need to be extended to support
>> 32bit LIDs, yes?  Or do you plan to try and hide this forever?
>>
>> As for the kernel to user space driver API, I waffled a bit about
>> whether we shouldn't go ahead and return the 32bit value to the driver=

>> and let it do the conversion to 16 bit for the user ABI, then decided
>> this method provides a cleaner means of supporting newer kernels with
>> older verbs OPA drivers and so didn't object, but it still leaves the
>> question about the long term plans here.
>>
> Hi Doug,
>=20
> Our long term plan is to use the new verbs 2 API for extending
> the LID size. We do not plan to keep this hidden forever and plan to
> use the new API once it's available.

Good.  That's more or less what I wanted to hear ;-).  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--EQNadoa6aJgORn9pwwQo3pE7KAX33a06s--

--XpewT2ALTMdxiDFhsKJmwDD97uCEIaCOE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZi0PXAAoJELgmozMOVy/dHjcQAINIJaG5kRqxSmXJLtOdjatK
VJpZG5Q3i2S2mRbYmJ+9+q9mURSDoEYKrQNRudwC4MAYS5+cf6wdxsh0bhrzHlC6
/CNchZr7ZrA8lfONBcZ9FxTrY3k9ShZbtRzyF/rFBaccgYCB5IY+vKZ40kgSCNAh
j/SU7IK6d0jhRsqUhVOfMUtJqcTcyqEcfENXXh2d5kAnKvQY6ntyOIBIoJGvD5s4
9LhHSg6sT59JSruegwayPhZh1/l4FS5c+8soOaGc+RtrVFer7epWXDRQw1Hw6Hrm
LkU2U7uLJhcf+86cCA1CZKw4JteJQFLRdg0CvhJ4VtrRgUhXGuD93GrCZVryUOoc
NiMSw222ci+dwCcuFfhnjzoNrPfNEx3iWuWuaw1124JNEgjgmq2qDSBe4O/c0bPB
072f4126JdUXgX4cCl/WQomtFbluuMuNPUvyB4Vz+GYSYwuxgrSdiZFHyIRSrGQu
Fz8Ae7tM6UNc8Z27/E7Jz0ZBAykvd5yeJPlWE/DNFN/wWawMNN7Hev4BIIHKpqo0
pY+iVm6dEdsGD+5dDUQTG7DcSF5saTTE/d8oXNnrPYhfcQeR0r273tNggy25xmB5
7eHBibDwVt5tAd4qqinrCS/M8JXaozqQdlBCuZ0GEAR3bnp4ZJQEeoesgTsBCEvp
ANgkm1CsGnQj6KXCXueA
=Mpa8
-----END PGP SIGNATURE-----

--XpewT2ALTMdxiDFhsKJmwDD97uCEIaCOE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
