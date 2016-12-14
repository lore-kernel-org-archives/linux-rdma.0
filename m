From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Support RAW Ethernet when RoCE is
 disabled
Date: Wed, 14 Dec 2016 14:06:20 -0500
Message-ID: <b7032e2a-2be8-3e34-348f-8df9253ff5a3@redhat.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="no2ecJK6MlEsLAiCVQ19tgm0VS74PXKLN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--no2ecJK6MlEsLAiCVQ19tgm0VS74PXKLN
Content-Type: multipart/mixed; boundary="1REQBcaT9h4FaMMTUo5A3sEIK1sXJIPPm";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
 Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
 Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>,
 Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <b7032e2a-2be8-3e34-348f-8df9253ff5a3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Support RAW Ethernet when RoCE is
 disabled
References: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--1REQBcaT9h4FaMMTUo5A3sEIK1sXJIPPm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/27/2016 9:51 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> Please find below the patch set from Or. I didn't add version notation =
to this
> patch set, because it was enriched extensively over initial version [1]=
, from
> one mlx5-only patch to native IB core support.
>=20
> It is tested against v4.9-rc6.
>=20
> From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> On some environments, such as certain SRIOV VF configurations, RoCE is
> not supported for mlx5 Ethernet ports. Currently, the driver will not
> open IB device on that port.
>=20
> This is problematic, since we do want user-space RAW Ethernet (RAW_PACK=
ET QPs)
> functionality to remain in place. For that end, we change the relevant =
driver
> flows such that an IB device instance is created in that case as well.
>=20
> Following the previous post [1], Doug wanted us to enable a way for
> applications to query what QP types are actually supported on a device.=

> This series adds that functionality on device/port granularity, since
> some drivers (mlx4) could support different protocols per port and
> hence different QP types per port.
>=20
> QP types are basically derived from the protocol/s supported on the por=
t. We
> added two protocols (raw packet and usnic) to have a protocol set which=
 is
> consistent with what is currently upstream.
>=20
> Patches 1-7 deal with the new query and patches 8-10 with the mlx5 spec=
ific
> changes.

I took only the last three patches until we settle on the issues brought =
up.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--1REQBcaT9h4FaMMTUo5A3sEIK1sXJIPPm--

--no2ecJK6MlEsLAiCVQ19tgm0VS74PXKLN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZgsAAoJELgmozMOVy/d5AsP/1cLag6WnPjNF4tW05LfhoNY
mYMAga2wMIgKe7c7QxfCU9Hp8ohknKS1xGzKIYJmPm6nXCBlgzCfmi/DLFpKhyND
+UgsQpT+UvDOZguD9P0/oSG2IknZyuiXyJtwTLebj3snrQPD5PocSf12+wG8YIZG
YXc37C3YxSEknqy03XOM54NBDseUc0Az+qfdI8gcIG+ewVN0Aw7mO08LCDa6IRsR
81URFcjTUpTWhcxoNzGdGeI1ZwT28/TIKSmnFIslKArOHjJWwGLA45cLYvqWlsnA
v5CUIVWHsv9hDn/MaLZAVGnNziBAlPgU35TG6lzstQcOb+RR2OKuUciIIY1sFdRY
EdmwwpuTVxM0mMwmqnHMwi0nVGz93F1xo+DrpzvVEkeDGIG8k4dev+wl57s2mt9/
sH5umNGkqlYLGTxp/OVLGpFiOzvWv5tJtm/8nAUzWGB4Zr1MMNplRYdtI1+awNf6
jULD8Ww7+nP3Z1+RbOIl654sgWmJbHJ5mJ/5K/OIT9mMUpTDi5XYirpcnQW0SkKU
8oUx3YwSpvmk9z/NZNuwxy6u0xKt8VKRrtXsieP+TcZuLrIGLomjGen0agOFJRrY
ggVxyCi4DjWeSo2C1q0oiI9+kSeh4gkeVU/Ru+PteXOFE36qAP9llK5vNOsvVui5
VSg6D5uU5M6Em1mPxxs2
=GJAV
-----END PGP SIGNATURE-----

--no2ecJK6MlEsLAiCVQ19tgm0VS74PXKLN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
