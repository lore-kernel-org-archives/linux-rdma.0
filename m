From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Stepping down as maintainer (was Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management)
Date: Wed, 15 Apr 2015 08:39:13 -0400
Message-ID: <F6B0F954-1E60-4CE9-AF39-7A6E8C8EC47B@redhat.com>
References: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A82373A8FC0120@ORSMSX109.amr.corp.intel.com> <1428858993.3470.12.camel@dworkin> <20150413164238.GB17521@obsidianresearch.com> <4EC214DA-97F8-4BCD-AEA6-6FB539E820F1@redhat.com> <20150414234258.GA25810@phlsvsds.ph.intel.com> <232BEA5DF26EF54583B8B332938DD0B84BB8E335@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2074.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D5A2CA81-B8B8-48A1-8353-716695DD73CE"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <232BEA5DF26EF54583B8B332938DD0B84BB8E335-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Kankipati <Pradeep.Kankipati-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_D5A2CA81-B8B8-48A1-8353-716695DD73CE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Apr 15, 2015, at 7:43 AM, Pradeep Kankipati =
<Pradeep.Kankipati-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> We at Emulex, have been working with Doug on the RH inboxing effort =
for a while and feel this just makes complete sense for him to take on =
this role for all the reasons mentioned. Personally too I feel he is an =
excellent choice.

Regardless of what we end up doing long term, Roland is out at the =
moment, so 4.1 is happening more or less without him :-/

I went ahead and put together a 4.1 branch and pulled the patches I =
thought were ready.  That=E2=80=99s been pushed to my github.  I know =
it=E2=80=99s hard to get things done without being able to make sure =
your patches apply cleanly.  For instance, the namespace patches =
aren=E2=80=99t included, and that=E2=80=99s at least partially because =
they didn=E2=80=99t apply cleanly any more.  So, I included the =
following series of patches:

My IPoIB changes
Erez=E2=80=99s IPoIB changes
Or=E2=80=99s mlx4 changes
Sagi=E2=80=99s iSER changes
The two patch fixup to the CVE issue
A few other miscellaneous patches

Let=E2=80=99s take this as a starting point.  If there are other patches =
people think should make 4.1, please bring them to my attention and =
I=E2=80=99ll add them for review and possible addition to the list.

git://github.com/dledford/linux.git for-4.1


> Thanks,
> Pradeep
> --
>=20
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org =
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of ira.weiny
> Sent: Wednesday, April 15, 2015 5:13 AM
> To: Doug Ledford
> Cc: Jason Gunthorpe; Yann Droneaud; Hefty, Sean; Roland Dreier; Hal =
Rosenstock; David Miller; Or Gerlitz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; =
talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Amir Vadai; Sagi Grimberg; Haggai Eran; Shachar =
Raindel
> Subject: Re: Stepping down as maintainer (was Re: [PATCH for-next 0/9] =
mlx4 changes in virtual GID management)
>=20
> On Mon, Apr 13, 2015 at 01:14:40PM -0400, Doug Ledford wrote:
>>=20
>>> On Apr 13, 2015, at 12:42 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>>=20
>>> On Sun, Apr 12, 2015 at 07:16:33PM +0200, Yann Droneaud wrote:
>>>=20
>>>> That would make sense to have someone like Doug or Jason being the
>>>> potential successors to Roland in order to keep InfiniBand
>>>> subsystem vendor neutrality.
>>>=20
>>> Several people have been asking me privately, I am looking into if
>>> this would be possible or not.
>>>=20
>>=20
>> Same here (having been asked privately to look into doing this).
>> FWIW,
> Red Hat has agreed that they are willing to allow me to transition my =
job to a full time upstream focused position (as of now, I work on =
upstream around my deliverables inside the company).
>>=20
>=20
> I think Doug and Jason are both qualified.
>=20
> However, with Red Hat willing to dedicate Doug full time I think that =
makes Doug an ideal candidate considering the patch load.
>=20
> Ira
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo =
info at  http://vger.kernel.org/majordomo-info.html
>=20

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_D5A2CA81-B8B8-48A1-8353-716695DD73CE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVLlvxAAoJELgmozMOVy/dYbYP/2beiE4w7HDGvFUesczyxtI1
ayVFaX1kgeBTOyWwtslDfAtpNa6O6wNbPhKtSyPq2pPvtxt8DOBW0Unc4xxxv8TX
7wHE21knLFUEg0pIM4Wyfoq/Zxh2FWiP4e++S+qVgmPOZZ+NkESNlM4qpu1VRbg1
wjqmefbLRJrdw5QuZh7bCoZ53iFl6LA0orq9zt9v1NTXbmdi6I++RaUftC0/cLcM
AJUt0JzhIcm16EUT8EBuS3sCq8A0jiXFRse9+nZb26ButD7Do6Km7hH3PiN4aTqy
NW8ZQUZEj+QWwprVct9oRkl03aaj5gZT8NK8CHy0kr46olV563spcQTLlPNuPxYr
faQsMnlv1oHA1SvZi54Ir1LQxnw0JHEraryT9fd8rHjBavsQxtROqt3k0d8uckti
po38hB3E/DnTiWGqXsIZvs8pETyUHuyG6aajHslto79Sy2dxRRldkNb3DaW/g/jK
Ddv0rnXtppxCO4uxBuihZR5hyYJ6xQhBU1wJr/YHj3WR09nu9KP1ZmTWnitDIcW1
/4M7ZXuXMeIbywFXBNxYfXTyoIq/3PyymNHz5dniRc+gWWPOAWH7BMHaZTitK2wj
dD8Fu1ekY12ibySf5MMerclDOcjyPVG4UAtYdAi3nZPCgMvRfHFOWaPwhpEv3Rp8
F3thTedhL2WhHCsFezkQ
=VJTZ
-----END PGP SIGNATURE-----

--Apple-Mail=_D5A2CA81-B8B8-48A1-8353-716695DD73CE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
