From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Thu, 28 Sep 2017 10:05:32 -0400
Message-ID: <11835f93-c251-8d33-5c7b-eedef64bdb62@redhat.com>
References: <1505885986-5873-1-git-send-email-Michal.Kalderon@cavium.com>
 <1506518845.82712.15.camel@redhat.com>
 <CY1PR0701MB20126E3E86A45619079DFCAC88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170927165339.GI2297@mtr-leonro.local>
 <20170927165610.GJ2297@mtr-leonro.local>
 <CY1PR0701MB2012A41A0744D17AD3CD10DB88780@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20170928032725.GO2297@mtr-leonro.local>
 <CY1PR0701MB20122CDD0A73BB963A43755288790@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HAP4G1NpWxiATmx5CMxAMvWE2MjP6l1II"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR0701MB20122CDD0A73BB963A43755288790-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HAP4G1NpWxiATmx5CMxAMvWE2MjP6l1II
Content-Type: multipart/mixed; boundary="6qBnOIV7D3q7SUovdCi7HmXS81BlqbaCI";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Message-ID: <11835f93-c251-8d33-5c7b-eedef64bdb62-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
References: <1505885986-5873-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
 <1506518845.82712.15.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CY1PR0701MB20126E3E86A45619079DFCAC88780-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
 <20170927165339.GI2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <20170927165610.GJ2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <CY1PR0701MB2012A41A0744D17AD3CD10DB88780-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
 <20170928032725.GO2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <CY1PR0701MB20122CDD0A73BB963A43755288790-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
In-Reply-To: <CY1PR0701MB20122CDD0A73BB963A43755288790-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>

--6qBnOIV7D3q7SUovdCi7HmXS81BlqbaCI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/28/2017 2:22 AM, Kalderon, Michal wrote:
>> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
>> Sent: Thursday, September 28, 2017 6:27 AM
>> On Wed, Sep 27, 2017 at 08:33:38PM +0000, Kalderon, Michal wrote:
>>> From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> Sent: Wednesday, September 27, 2017 7:56 PM On Wed, Sep 27, 2017 at
>>> 07:53:39PM +0300, Leon Romanovsky wrote:
>>>>> On Wed, Sep 27, 2017 at 04:18:50PM +0000, Kalderon, Michal wrote:
>>>>>> From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>>> Sent: Wednesday, September 27, 2017 4:27 PM
>>>>>>
>>>>>>> On Wed, 2017-09-20 at 08:39 +0300, Michal Kalderon wrote:
>>>>>>>> Initialize the rdma_type (iWARP or RoCE) which is set
>>>>>>>> according to device configuration in qed.
>>>>>>>>
>>>>>>>> Fixes: e6a38c54faf ("RDMA/qedr: Add support for registering an
>>>>>>>> iWARP
>>>>>>>> device")
>>>>>>>>
>>>>>>>> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>>>>>>> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>>>>>>>
>>>>>>>> ---
>>>>>>>> This patch applies cleanly on k.o/for-next-merged
>>>>>>>>
>>>>>>>> Changes from V0:
>>>>>>>> - Added Fixes in commit comment.
>>>>>>>
>>>>>>> Sorry, I was wrong in my email to the previous posting of this pa=
tch.
>>>>>>> I had pulled this v1 patch from patchworks, not the original
>>>>>>> patch, and so the Fixes: line was yours.  Patchworks did not add
>>>>>>> the Fixes: line to the v0 patch when I downloaded it just now.
>>>>>>
>>>>>>> That being said, I still can't build with this patch ;-)
>>>>>> Are you building against the rdma-next branch ?
>>>>>> The patch requires the iWARP series, originally this was tested
>>>>>> against for-next-merged, what's the error you're getting ?
>>>>>
>>>>> On rdma-next:
>>>>> drivers/infiniband/hw/qedr/main.c: In function =E2=80=98qedr_add=E2=
=80=99:
>>>>> drivers/infiniband/hw/qedr/main.c:780:7: error: =E2=80=98struct qed=
r_dev=E2=80=99 has
>> no member named =E2=80=98rdma_type=E2=80=99; did you mean =E2=80=98rdm=
a_ctx=E2=80=99?
>>>>>   dev->rdma_type =3D dev_info.rdma_type;
>>>>>        ^~~~~~~~~
>>>>>        rdma_ctx
>>>>> make[4]: *** [scripts/Makefile.build:311:
>>>>> drivers/infiniband/hw/qedr/main.o] Error 1
>>>>
>>>> My config:
>>>>
>>>> =E2=9E=9C  linux-rdma git:(rdma-next) grep QED .config CONFIG_QED=3D=
m
>>>> CONFIG_QED_LL2=3Dy CONFIG_QED_SRIOV=3Dy CONFIG_QEDE=3Dm
>> CONFIG_QED_RDMA=3Dy
>>>> CONFIG_INFINIBAND_QEDR=3Dm
>>>
>>> Thanks Leon for helping out with this. Unfortunately i'm not seeing t=
his.
>>> The rdma_type field was added with the following patch:
>>>
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/dledford/rdma=

>>> /+/e6a38c54faf38498170e227c82ea25cb8bc1ae71
>>>
>>> When running git log on the k.o/for-next I see the patch (last in lis=
t
>>> below), applying this patch on top of  rdma-next works for me and
>> compiles cleanly.
>>>
>>> 2e2f2d0 RDMA/qedr: Fix rdma_type initialization
>>> 1848757 Merge branches 'hns' and 'misc' into k.o/for-next 931bc0d IB:=

>>> Move PCI dependency from root KConfig to HW's KConfigs 7ae6f2a Merge
>>> branch 'qedr' into k.o/for-next
>>> bd491d2 RDMA/qedr: fix build error without ipv6
>>> 89fd257 RDMA/qedr: Missing error code in qedr_init_user_queue()
>>> 847cb1a RDMA/qedr: fix spelling mistake: "invlaid" -> "invalid"
>>> 69ad0e7 RDMA/qedr: Add support for iWARP in user space
>>> e411e05 RDMA/qedr: Add iWARP connection management functions
>> de0089e
>>> RDMA/qedr: Add iWARP connection management qp related callbacks
>>> fb1a22b RDMA/qedr: Add support for read with invalidate, supported in=

>>> iWARP
>>> f5b1b17 RDMA/qedr: Add iWARP support in existing verbs
>>> e6a38c5 RDMA/qedr: Add support for registering an iWARP device
>>>
>>> am i missing something ?
>>
>> I refreshed my branches now and it worked, but your git log history lo=
oks
>> strange. Where did you see the commit 1848757 and 931bc0d?
>=20
> git://github.com/dledford/linux.git
> git log --oneline -- drivers/infiniband/hw/qedr
> https://github.com/dledford/linux/commit/1848757c3d8bff3addf881c8bcc2b8=
5e25ccf25e
>=20
> I was under the assumption a patch goes to github before k.o - is this =
not the case ?=20

It does.  I always send things to github first, wait for 0day testing
results, then send it to k.o if it passes.  However, what is important
here, is that if it *doesn't* pass 0day testing, then I will rebase the
branch to fix the broken patch in some cases.  Once a patch series lands
on k.o, if it's broken, we will either revert or incrementally patch thin=
gs.

> Thanks again,=20
>=20
> Doug - are you still seeing issues with this patch ?=20

I'll recheck today.

> Thanks,
> Michal
>=20
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/log/=
?h=3Dk
>> .o/for-next
>> Age	Commit message (Expand)	Author	Files	Lines
>> 3 days	Merge branch 'qedr' into k.o/for-nextfor-nextk.o/for-next	 Doug=

>> Ledford	11	-91/+1208
>> 3 days	Merge tag 'v4.14-rc2' into k.o/for-next	 Doug Ledford	12044	-
>> 388475/+631018
>> 3 days	Linux 4.14-rc2HEADmaster	 Linus Torvalds	1	-1/+1
>>
>> =E2=9E=9C  linux-rdma git:(iwarp-compile) git log --oneline f350695723=
7b (HEAD ->
>> iwarp-compile) RDMA/qedr: Fix rdma_type initialization
>> 7ae6f2a3d552 (rdma/k.o/for-next, grdma/k.o/for-next) Merge branch 'qed=
r'
>> into k.o/for-next
>> 0d9c2ff1c9f7 Merge tag 'v4.14-rc2' into k.o/for-next e19b205be43d (tag=
:
>> v4.14-rc2, rdma/master, origin/master, ml/master, grdma/master,
>> grdma/hns, backup/master, master) Linux 4.14-rc2
>>
>> Thanks
>>
>>> thanks,
>>> Michal
>>>


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--6qBnOIV7D3q7SUovdCi7HmXS81BlqbaCI--

--HAP4G1NpWxiATmx5CMxAMvWE2MjP6l1II
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZzQGsAAoJELgmozMOVy/dnTMP/RPLkBXPjfcYmk7PyvLcW5ga
jTQQ18OEH01LFleJ91ZHrImyuWsPD5WX7rOFBOu/pY3kgo9tlfflsSyamshyIkgM
bTfGSUr/BDrfQWwepIGfHsG3sIJHeQd56ayRfjSMQ/2wUW/nl4AxdbclI2YN/VDH
WUgAcBWzdqLcFdj7wamEOjc/cheVdVy2egzs4wiYO7TfLLcXogwpgpTLURAi47s3
yMofrlLzNzlG/FCBRyK2rMMNoxahcY/0c6TPuegQpS2jkY5DzKpNqtBDqIxhyy/C
bT38Jj6urpATOfwyeIMHXPNH44psYPvhe4sSgKuptOmTTV8TsLVVqu8rN67Lb5zv
Y12DgaUZDohbzdQqaJO3NKNOcNgE6KIJRXxAyQ8IqQ8VsE1NrBPcQ5Cgy/GzUcAr
yVdJarBhLv91pEJvp3EjqY3LG/vPBrU6JApG49iDIaN21RQr6B14SB6kBMkeEr/j
9K+iiSRNPrNpxrEnfW2+u5A4efspGtfksvQ3U2vh8qiBAl6SGfdbIn5C/x2io9Lg
jMyQyn7INuiOCbY/mT8YEl38VvtQCDmc/+CxrqglJJW7PFuljwocS7hSwH163AId
RI0+ZH/VCNAVhqnfBQsK3BmI4Nwjpzdiv+/PVDKrztTH/IgfXAfV/zFXYN68NAQY
5k7l2baPa+Zfftr7NxFH
=uBGM
-----END PGP SIGNATURE-----

--HAP4G1NpWxiATmx5CMxAMvWE2MjP6l1II--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
