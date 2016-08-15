From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 00/22] Add Hisilicon RoCE driver
Date: Mon, 15 Aug 2016 09:55:59 -0400
Message-ID: <c6bf07c3-769a-aa02-73fa-a623c0fd7bdc@redhat.com>
References: <1469099217-26071-1-git-send-email-oulijun@huawei.com>
 <1470155196.18081.10.camel@redhat.com> <57AD6FFA.1050108@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JaRd51t4a2ppi5O4ui1L2AHtO967bCmeu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57AD6FFA.1050108-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JaRd51t4a2ppi5O4ui1L2AHtO967bCmeu
Content-Type: multipart/mixed; boundary="lDCoFElvujQb2mVnN1kkN8nmknrJHgB8d"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Message-ID: <c6bf07c3-769a-aa02-73fa-a623c0fd7bdc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 00/22] Add Hisilicon RoCE driver
References: <1469099217-26071-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 <1470155196.18081.10.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <57AD6FFA.1050108-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <57AD6FFA.1050108-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

--lDCoFElvujQb2mVnN1kkN8nmknrJHgB8d
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/12/2016 2:43 AM, Wei Hu (Xavier) wrote:
>=20
>=20
> On 2016/8/3 0:26, Doug Ledford wrote:
>> On Thu, 2016-07-21 at 19:06 +0800, Lijun Ou wrote:
>>> The Hisilicon Network Substem is a long term evolution IP which is
>>> supposed to be used in Hisilicon ICT SoCs. HNS (Hisilicon Network
>>> Sybsystem) also has a hardware support of performing RDMA with
>>> RoCEE.
>>> The driver for Hisilicon RoCEE(RoCE Engine) is a platform driver and
>>> will support mulitple versions of SOCs in future. This version of
>>> driver
>>> is meant to support Hip06 SoC(which confirms to RoCEv1 hardware
>>> specifications).
>> I would like to thank you for being as responsive as you've been durin=
g
>> the review process.  I know you have put a lot of effort into
>> addressing people's questions/comments.  You've addressed the review
>> comments I had, as well as other peoples.  At this point, I don't want=

>> to say the driver is perfect, because as you continue to look at it yo=
u
>> will almost always find something you can nitpick (like this segment i=
n
>> hns_roce_cmd.h:
>>
>> enum {
>> 	HNS_ROCE_CMD_TIME_CLASS_A	=3D 10000,
>> 	HNS_ROCE_CMD_TIME_CLASS_B	=3D 10000,
>> 	HNS_ROCE_CMD_TIME_CLASS_C	=3D 10000,
>> };
>>
>> This is a case where you guys used the mlx4 RoCE driver as a template
>> to help you create your own...and their driver has to have different
>> timeout expectations for different firmware commands because some take=

>> a long time and others don't, and you ended up copying this TIME_CLASS=

>> stuff to your driver, but it isn't really needed and so they all have
>> the same value).  However, I believe you have brought the driver to a
>> level of quality sufficient for the initial submission to the linux
>> tree.  As such, I have taken v12 of your patchset.  I squashed many of=

>> the patches into just one patch, so the series now looks like this:
>>
>> dd778a9920a6 MAINTAINERS: Add maintainers for Hisilicon RoCE driver
>> 51db6bbe7de1 IB/hns: Kconfig and Makefile for RoCE module
>> 5e43122add63 IB/hns: Add driver files for hns RoCE driver
>> c2c3b9d9e463 devicetree: bindings: IB: Add binding document for
>> Hisilicon RoCE
>> c80815c0b214 net: hns: Add reset function support for RoCE driver
>> 92d21ac74a9e Linux 4.7-rc7
>>
>> Thanks for all the hard work in answering review comments, series
>> applied ;-)
> Hi, Doug Ledord
>=20
>    Thank you very much!
>=20
>    If we prepare to add new feature for HNS driver, which repo can we
> send patchset against?
>    :)

You'll have to send it against my hns branch.  I didn't submit the
driver this merge window because it had merge conflicts between your
code and other patches going in through Dave Miller's net tree.  I've
already been down this road with Mellanox where Dave gets some patches
and I get others and they have merge conflicts and then Linus yells at
me.  So, before I submit your driver, it has to go in without merge
conflicts in files touched by both you and other people at Huawei.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--lDCoFElvujQb2mVnN1kkN8nmknrJHgB8d--

--JaRd51t4a2ppi5O4ui1L2AHtO967bCmeu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXscn1AAoJELgmozMOVy/dzPUP/1dFxYtTNs+tncDNfYt8Kd95
RLjpvp/HVfbt4/DqsB1zoy4I6yR/Z1jzNm1d/d8gAkPGGUq+xHUuC6eJbDXjJtEe
3o3pYFphGsL94DLs2AGUB7R2K4VUkWhVVLlN3jpYOW42FlebyxCqmhpgCfjnoylP
rSlo6b/WIMt0eU3kSd+IgRohRXfNbgtiTgEUtPjuM5RfbYPdb57a7QvvHzODil3S
vHaqRL1mUB34awa6XRvMa0/yyCFCwsivd0arKOEyux5F4kmNNnFn7szOeJsM+8C/
JHob2EXDAU1iYzXE13p7YPyukjCu8nx8aakTfbpc06PV2ZcbNSEh11IB1x7atYAa
irM2LRSbGSDUgYViMvZJyv99L37EPp2GPs2kq+NT5xU1ScZzfbIK/bHt08P2tJTw
o5ENyqAV2yNi4Bx4lnul7TGFHREEDIELqbFCPspC1ktICapVmYG+gTtTzbNPsTag
e8MKW58siEtmz8AtbX+1XkDk4s8qxAlMREZ83TLqqu2vfT04MkulxBmsBxt1IOtr
VRz9Ppg88meI9JHQHz1SZeVuBJKitu7Hm2CSpMS4pL5M1ahl5bJZHFuIlOCSkvK9
eK9UhTlXO1YbYAdOqnmIsvgadzm/hPmTrF7ENIlbhPP3EZ9i2ImBwLmPxbJht76/
+WDXN2/FHC2V6ABenG6W
=qBuO
-----END PGP SIGNATURE-----

--JaRd51t4a2ppi5O4ui1L2AHtO967bCmeu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
