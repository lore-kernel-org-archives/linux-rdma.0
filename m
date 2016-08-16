From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 00/22] Add Hisilicon RoCE driver
Date: Tue, 16 Aug 2016 08:07:03 -0400
Message-ID: <e91c0b31-c2e0-7167-3775-def0e1d47a2a@redhat.com>
References: <1469099217-26071-1-git-send-email-oulijun@huawei.com>
 <1470155196.18081.10.camel@redhat.com> <57AD6FFA.1050108@huawei.com>
 <c6bf07c3-769a-aa02-73fa-a623c0fd7bdc@redhat.com>
 <57B2782B.1030908@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ld28399jjE356KLWnjV9uSLeBu0NEs6wB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57B2782B.1030908-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ld28399jjE356KLWnjV9uSLeBu0NEs6wB
Content-Type: multipart/mixed; boundary="5EUfVcsBW6pX4CkbXGmiwoki2bSAgWRNT"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Message-ID: <e91c0b31-c2e0-7167-3775-def0e1d47a2a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 00/22] Add Hisilicon RoCE driver
References: <1469099217-26071-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 <1470155196.18081.10.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <57AD6FFA.1050108-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 <c6bf07c3-769a-aa02-73fa-a623c0fd7bdc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <57B2782B.1030908-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <57B2782B.1030908-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

--5EUfVcsBW6pX4CkbXGmiwoki2bSAgWRNT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/15/2016 10:19 PM, Wei Hu (Xavier) wrote:
>=20
>=20
> On 2016/8/15 21:55, Doug Ledford wrote:
>> On 8/12/2016 2:43 AM, Wei Hu (Xavier) wrote:
>>>
>>> On 2016/8/3 0:26, Doug Ledford wrote:
>>>> On Thu, 2016-07-21 at 19:06 +0800, Lijun Ou wrote:
>>>>> The Hisilicon Network Substem is a long term evolution IP which is
>>>>> supposed to be used in Hisilicon ICT SoCs. HNS (Hisilicon Network
>>>>> Sybsystem) also has a hardware support of performing RDMA with
>>>>> RoCEE.
>>>>> The driver for Hisilicon RoCEE(RoCE Engine) is a platform driver an=
d
>>>>> will support mulitple versions of SOCs in future. This version of
>>>>> driver
>>>>> is meant to support Hip06 SoC(which confirms to RoCEv1 hardware
>>>>> specifications).
>>>> I would like to thank you for being as responsive as you've been dur=
ing
>>>> the review process.  I know you have put a lot of effort into
>>>> addressing people's questions/comments.  You've addressed the review=

>>>> comments I had, as well as other peoples.  At this point, I don't wa=
nt
>>>> to say the driver is perfect, because as you continue to look at it =
you
>>>> will almost always find something you can nitpick (like this segment=
 in
>>>> hns_roce_cmd.h:
>>>>
>>>> enum {
>>>>     HNS_ROCE_CMD_TIME_CLASS_A    =3D 10000,
>>>>     HNS_ROCE_CMD_TIME_CLASS_B    =3D 10000,
>>>>     HNS_ROCE_CMD_TIME_CLASS_C    =3D 10000,
>>>> };
>>>>
>>>> This is a case where you guys used the mlx4 RoCE driver as a templat=
e
>>>> to help you create your own...and their driver has to have different=

>>>> timeout expectations for different firmware commands because some ta=
ke
>>>> a long time and others don't, and you ended up copying this TIME_CLA=
SS
>>>> stuff to your driver, but it isn't really needed and so they all hav=
e
>>>> the same value).  However, I believe you have brought the driver to =
a
>>>> level of quality sufficient for the initial submission to the linux
>>>> tree.  As such, I have taken v12 of your patchset.  I squashed many =
of
>>>> the patches into just one patch, so the series now looks like this:
>>>>
>>>> dd778a9920a6 MAINTAINERS: Add maintainers for Hisilicon RoCE driver
>>>> 51db6bbe7de1 IB/hns: Kconfig and Makefile for RoCE module
>>>> 5e43122add63 IB/hns: Add driver files for hns RoCE driver
>>>> c2c3b9d9e463 devicetree: bindings: IB: Add binding document for
>>>> Hisilicon RoCE
>>>> c80815c0b214 net: hns: Add reset function support for RoCE driver
>>>> 92d21ac74a9e Linux 4.7-rc7
>>>>
>>>> Thanks for all the hard work in answering review comments, series
>>>> applied ;-)
>>> Hi, Doug Ledord
>>>
>>>     Thank you very much!
>>>
>>>     If we prepare to add new feature for HNS driver, which repo can w=
e
>>> send patchset against?
>>>     :)
>> You'll have to send it against my hns branch.  I didn't submit the
>> driver this merge window because it had merge conflicts between your
>> code and other patches going in through Dave Miller's net tree.  I've
>> already been down this road with Mellanox where Dave gets some patches=

>> and I get others and they have merge conflicts and then Linus yells at=

>> me.  So, before I submit your driver, it has to go in without merge
>> conflicts in files touched by both you and other people at Huawei.
>>
> Hi, Doug Ledord
>=20
>     I am very sorry about it.  I have dissucsed with pepole responsible=

> for NiC HNS driver,
> and we will do our best to ensure no confilct again.
>    Can you give me suggestion how we should solve problem this time?
> Maybe we send
> patch aginst your hns branch to solve confilct,  or other method?
>=20
> Regards
> Wei Hu
>=20
>=20
>=20

The only patch that had conflicts in the series above is this one:

c80815c0b214 net: hns: Add reset function support for RoCE driver

Send me a new version of that patch that doesn't have conflicts and
we'll go from there.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--5EUfVcsBW6pX4CkbXGmiwoki2bSAgWRNT--

--Ld28399jjE356KLWnjV9uSLeBu0NEs6wB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXswHnAAoJELgmozMOVy/dtRQQAJf7zrMKSwihCssaHyRYe4I/
eLfRmTDZlyD2yTdBUISbDk1qlAJyw0H1WEIeVmZX4eC/2nwWZKNAS585FnkKqwls
ivJj05MX/ijhpWBo/dszoL22257z25uV9ADWKih8eckE+TULS+8uyqxNDiEzPIkx
VgRSGlpP1jvtYnoxp1vFlE0LEiSrm5ACOBHJCFvPeovaTx2GZRU+tp0+Op1qWTwl
TMHnL3F+V/WNICW2TA0Tk5xRdm2am5GAsFRqx3eW9cP5+RBUK5ngaBs20zNwkvtg
LmynWBeDqQp2ipDJM5EpFPp/EDmia7HEK7qZDs8CAsEliCuhBkC3uLEOKn/BTh+H
rAtsZ7w5TzNVpBS3ngiCTpM2r1Tz484aW37RXuAQGFUgRlcWRtATCIazG+8RLx10
D8PZoVIVUEDGgFDJMpMbkAjvqU95OdRpSo3C379xLCCG9wB+nh/YuaqX13LlGRpf
9VHmjcC9i+XYu3KQlC3tWCzu/ZFacK7rkDGbBYifntr7FY67wiCHSKK7ZuBYiO7e
nin98jC1pmheiVk7fPA8J58rMqTCB8nknfmFxHrKe7VrLPbCQh9xLdHKwo1ADSXS
VKRkSoZdqjF1b/4B8DoTR6UT6uSMvd8Ggo9F463d29zYsf4aR94sRg5NKdmssmnI
Pe5z4WbGlPj2VrKpVqtQ
=jqFb
-----END PGP SIGNATURE-----

--Ld28399jjE356KLWnjV9uSLeBu0NEs6wB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
