From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 01/13] IB/core: Add get FW version string to the core
Date: Thu, 16 Jun 2016 12:46:31 +0300
Message-ID: <20160616094631.GV5408@leon.nu>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com>
 <1465971728-24104-2-git-send-email-ira.weiny@intel.com>
 <20160615064008.GS5408@leon.nu>
 <20160615152048.GB8690@phlsvsds.ph.intel.com>
 <20160615165106.GA10256@obsidianresearch.com>
 <20160615232602.GA4034@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XQSDX3NWE02rtiZq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160615232602.GA4034-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--XQSDX3NWE02rtiZq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 15, 2016 at 07:26:03PM -0400, ira.weiny wrote:
> On Wed, Jun 15, 2016 at 10:51:06AM -0600, Jason Gunthorpe wrote:
> > On Wed, Jun 15, 2016 at 11:20:49AM -0400, ira.weiny wrote:
> > > The default here is that a device does not provide a firmware string.=
  In that
> > > case the assumption is that there is no firmware.  Hence the empty st=
ring.  I
> > > don't think that reporting 0's or F's are appropriate if a device doe=
s not have
> > > firmware.
> > >=20
> > > In the cases you speak of I would expect the device to supply the fir=
mware
> > > function and report all 0s or all Fs for whatever version that may re=
present.
> > > (I'm assuming that would be some sort of debug or unreleased firmware=
=2E..)
> > >=20
> > > I could just as well done something like.
> > >=20
> > > snprintf(str, str_len, "<none>");
> >=20
> > Just don't provide a 'fw' sysfs file at all if the driver cannot
> > support it.
>=20
> This function is supporting both sysfs and ethtool.
>=20
> ethtool_drvinfo->fw_version is normally up to the device.  I've just prov=
ided a
> default.
>=20
> For example I see "N/A", "n/a", and "none" all used in the network stack.
>=20
> ./ethernet/freescale/gianfar_ethtool.c: strlcpy(drvinfo->fw_version, "N/A=
", sizeof(drvinfo->fw_version));
>=20
> ./rionet.c:     strlcpy(info->fw_version, "n/a", sizeof(info->fw_version)=
);
>=20
> ./fjes/fjes_ethtool.c:  strlcpy(drvinfo->fw_version, "none", sizeof(drvin=
fo->fw_version));
>=20
> I really think we are in the weeds here and are fine to leave it blank.

I'm fine with that.

>=20
> But if you wish, I can force all drivers to provide the string and then t=
hey can
> put something in like the above.
>=20
> Ira
>=20

--XQSDX3NWE02rtiZq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXYnV3AAoJEORje4g2clinJnAQAL2MfPKRRMx2xE4qDEBITU8a
2e9yXj1JnVMNSJIVhkS7TbpJYFbzDaAQNkfYJiJfFXwgqVSkrGoxzCyKdlaBtu8Y
4D8DbjgCREe9O7KykGjVL3WXjduO/AqFKvuSPYr2jPVr+9vYDypHYYi2/YWHJkag
3htat4uiXnrHZTrjn/nA2SQsEu/prsMOi5jhxt4NaZ0V3q9m2Q4D/xivct3dxmuy
KV4LOEWrR8Kg2ccgldgAiOYUwqMiB/qTFKa1Aax8AzE+sBFeR2+20Bp1FOzgr+US
20z1IsD/nDhAT7KuLCrLpufwiN20ZbSet5vlUYAdQVSyNeKzS9qSmFnk7ttHeOaC
xOdbRl+dd4SpWtFASDjU+DQLIPBleZpDfove4zfHmLF8qnWm4pyKyFOjVNvU1aWo
/WXNc9RVHrX0jgE8N8bjflDuo0LFB9btXPjNScsKhzINmPn+iWIvjZd9XyehWLuL
+WTloDeKM5y85kXtpevNfT2Et6aWfCrXaoNi5V9zOWBVl9LK07GFXjRWsSDDF39K
HWPnLSpEZWQPCxAGt0v7UQ0XkrPhrMxZKKAt3yQtb3kfrE80n0PIoCCUrIExlOZz
6/8Ex5/pinRI/tmfT7TsixeODlasjQBqPr25wt7TvH2A4bI2SmNsMuQI1EY9xR8j
abWiRk7kpiQQHIvdXxJ+
=yTOV
-----END PGP SIGNATURE-----

--XQSDX3NWE02rtiZq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
