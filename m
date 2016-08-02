From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 00/22] Add Hisilicon RoCE driver
Date: Tue, 02 Aug 2016 12:26:36 -0400
Message-ID: <1470155196.18081.10.camel@redhat.com>
References: <1469099217-26071-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-aD14aQggynfO+OcpZ3bJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469099217-26071-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-aD14aQggynfO+OcpZ3bJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-07-21 at 19:06 +0800, Lijun Ou wrote:
> The Hisilicon Network Substem is a long term evolution IP which is
> supposed to be used in Hisilicon ICT SoCs. HNS (Hisilicon Network
> Sybsystem) also has a hardware support of performing RDMA with
> RoCEE.
> The driver for Hisilicon RoCEE(RoCE Engine) is a platform driver and
> will support mulitple versions of SOCs in future. This version of
> driver
> is meant to support Hip06 SoC(which confirms to RoCEv1 hardware
> specifications).

I would like to thank you for being as responsive as you've been during
the review process. =C2=A0I know you have put a lot of effort into
addressing people's questions/comments. =C2=A0You've addressed the review
comments I had, as well as other peoples. =C2=A0At this point, I don't want
to say the driver is perfect, because as you continue to look at it you
will almost always find something you can nitpick (like this segment in
hns_roce_cmd.h:

enum {
	HNS_ROCE_CMD_TIME_CLASS_A	=3D 10000,
	HNS_ROCE_CMD_TIME_CLASS_B	=3D 10000,
	HNS_ROCE_CMD_TIME_CLASS_C	=3D 10000,
};

This is a case where you guys used the mlx4 RoCE driver as a template
to help you create your own...and their driver has to have different
timeout expectations for different firmware commands because some take
a long time and others don't, and you ended up copying this TIME_CLASS
stuff to your driver, but it isn't really needed and so they all have
the same value). =C2=A0However, I believe you have brought the driver to a
level of quality sufficient for the initial submission to the linux
tree. =C2=A0As such, I have taken v12 of your patchset. =C2=A0I squashed ma=
ny of
the patches into just one patch, so the series now looks like this:

dd778a9920a6 MAINTAINERS: Add maintainers for Hisilicon RoCE driver
51db6bbe7de1 IB/hns: Kconfig and Makefile for RoCE module
5e43122add63 IB/hns: Add driver files for hns RoCE driver
c2c3b9d9e463 devicetree: bindings: IB: Add binding document for
Hisilicon RoCE
c80815c0b214 net: hns: Add reset function support for RoCE driver
92d21ac74a9e Linux 4.7-rc7

Thanks for all the hard work in answering review comments, series
applied ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-aD14aQggynfO+OcpZ3bJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoMm8AAoJELgmozMOVy/dhr8P/2lhPl0gTUTfGQbEuYMNcOhS
MIXLidsqC8T2Tv+ERS6EZCETD4rXVZp9WcBHCW3Nyi/FiwU3sxf+Pc0slO6i6Tai
kKGzDivv+tzx7Cfac6mAZkzS84ajit592NfTW53WzHeUhsfpgTx6VBmQbfYTxb/C
jAOLW2TbHK7g0oldgXYXe5RfplMe9SlNU5N0XRKnVIFwPHscdVVwFdqSVDlIekII
FxvisISpLfpb/zq1gRNm3swURA49Zg6agk/Kc01HsGFaqcMSNadwlvAjkl+B8tM1
FyVbENrJnaawEnoFBiKNMS6SdFoIj9JJhCj1j3gXsrHUWIjqxcrXjZK1Z8aWyE7D
JWDYMM2IGd79ZKLasnNG8dfUgVzS5OFJtVYDMb7yLuqEQe8a1GvLzk9E7gkveuW6
R5RcRgtkE0VrStN/oD9taAn9oreSIln2EH1WCjJZ4a4UUO6ICGGDgacjdur/RuYF
FYNxwReQZnThe6n3iaNjDXfy1svt5LyDaBaaUaKkGRll5BEsz/I126fjkbXKxYVE
zDILPd0iEfncgXqjuSuHfkNzv4LwvDo29cSyFrXlmbEKFTMq/wMhYvUk3CHFaTRa
WYq1Wdk9tyhIbUAqOiSBFO1FSihrkoklTGlxTXE/fLoIrUR4EC0nAoHgprCZxs8j
UTLBDByGxnUOkrbrXwH6
=VOWB
-----END PGP SIGNATURE-----

--=-aD14aQggynfO+OcpZ3bJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
