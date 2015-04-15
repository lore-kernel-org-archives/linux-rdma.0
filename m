From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Stepping down as maintainer (was Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management)
Date: Wed, 15 Apr 2015 09:07:52 -0400
Message-ID: <A9BA9CD2-D441-4B3C-85B0-C98A0FF05B1B@redhat.com>
References: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A82373A8FC0120@ORSMSX109.amr.corp.intel.com> <1428858993.3470.12.camel@dworkin> <20150413164238.GB17521@obsidianresearch.com> <4EC214DA-97F8-4BCD-AEA6-6FB539E820F1@redhat.com> <20150414234258.GA25810@phlsvsds.ph.intel.com> <232BEA5DF26EF54583B8B332938DD0B84BB8E335@CMEXMB1.ad.emulex.com> <F6B0F954-1E60-4CE9-AF39-7A6E8C8EC47B@redhat.com> <552E6164.7000802@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2074.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_953BB138-FCE8-4DB3-A2DD-148346AECA4D"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552E6164.7000802-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Pradeep Kankipati <Pradeep.Kankipati-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_953BB138-FCE8-4DB3-A2DD-148346AECA4D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Apr 15, 2015, at 9:02 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> =
wrote:
>=20
> On 4/15/2015 3:39 PM, Doug Ledford wrote:
>>=20
>>> On Apr 15, 2015, at 7:43 AM, Pradeep Kankipati =
<Pradeep.Kankipati-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> wrote:
>>>=20
>>> We at Emulex, have been working with Doug on the RH inboxing effort =
for a while and feel this just makes complete sense for him to take on =
this role for all the reasons mentioned. Personally too I feel he is an =
excellent choice.
>>=20
>> Regardless of what we end up doing long term, Roland is out at the =
moment, so 4.1 is happening more or less without him :-/
>>=20
>> I went ahead and put together a 4.1 branch and pulled the patches I =
thought were ready. That=E2=80=99s been pushed to my github.  I know =
it=E2=80=99s hard to get things done without being able to make sure =
your patches apply cleanly.  For instance, the namespace patches =
aren=E2=80=99t included, and that=E2=80=99s at least partially because =
they didn=E2=80=99t apply cleanly any more.  So, I included the =
following series of patches:
>>=20
>> My IPoIB changes
>> Erez=E2=80=99s IPoIB changes
>> Or=E2=80=99s mlx4 changes
>> Sagi=E2=80=99s iSER changes
>=20
> Hey Doug,
>=20
> Did you pull v3?

Yes.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_953BB138-FCE8-4DB3-A2DD-148346AECA4D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVLmKoAAoJELgmozMOVy/dOJ8P/3rsA7VuphKhCDHXwuwB8lcd
3YxuHIOb6xu0ja6wLYdJbVMH0SHTYU9LKR4415u9DnmQr/7gdYxeyFxfOA7q4rkt
5L5b2fkCXXlyd1YMiBSvJurnPlKCr4a4g1Z1Ulqv5Q2ZM5THdEaI04HKLl80R3Z2
2rkz0Up6V22kND32lYsBfRxX1TF6Ip8u3IiP5KjEQjoVZzy9tl7I/0WqmDu2b1qQ
GV2RKhu2WjhSung5efD+4ZUws2GUlH17W6KbT4WSer5wWzIj72+KGc5URYGCKD68
hl5pWC9d5eqJD06I3OYxsCy8wATSi2TYtm/jhTNbVzvV+dtQx0s+D7PImj9NjC3F
inhyRCsMrW1Nrm0B28CSt5BpxuS1CKagS/XMJ7G7kwdnyQUxyJ38pv/j+fOOk0on
iDp+5wNqSTymTCL4dbMZQTQYamOu2zx/ZSLIXgoFzlHN55vyvGOrECBixGrQjKsd
4FueqFwdUZtx9MVI0UTkLxi//58uyUhsLvHJOjMTyfbh+mN0g/4I+Skpf04emeZE
pKP5LTnGU0hGAT3mil7xTSh9XDWFxJsFMSCGFvWRCCYJu6Tk56x721YUXgcyPp9e
jzBmT6YL4uObgJGZgRM9D/Y0EvgW/Zxuix7EkGqo5zBB4pd2oTtkjxOtzhagAkEa
neftF12L4dI7ZBGd8ft7
=cQtt
-----END PGP SIGNATURE-----

--Apple-Mail=_953BB138-FCE8-4DB3-A2DD-148346AECA4D--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
