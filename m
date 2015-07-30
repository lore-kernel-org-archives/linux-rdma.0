From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Demux IB CM requests in the rdma_cm module
Date: Thu, 30 Jul 2015 11:33:13 -0400
Message-ID: <55BA43B9.7050801@redhat.com>
References: <1438167991-17211-1-git-send-email-haggaie@mellanox.com>
 <55B8E7F6.2030603@redhat.com> <55B9E848.6040907@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ojvUCBMhiAggKJs2J8OcX6cXdTfbCPKri"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B9E848.6040907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ojvUCBMhiAggKJs2J8OcX6cXdTfbCPKri
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 05:03 AM, Haggai Eran wrote:
> On 29/07/2015 17:49, Doug Ledford wrote:
>> This doesn't apply on to a clean 4.2-rc4 kernel tree.  Can you please
>> rebase against either that or my to-be-rebase/for-4.3 branch of my
>> github repo?
>=20
> Sure. Keep in mind that this patchset also depends on the patch from
> Matan's series to protected the device and client list with a rwsem [2]=
=2E
> Do you want me to add it to this series?

You added it to the series, which is OK and I've picked that series up.
 In general though, if there are two different patch series that both
need the same patch, I would prefer it if that one patch is sent by
itself so I can grab it and not included in either of the other two
series.  I think some of the patches that didn't apply were when I
forgot to remove a duplicate patch found in two different series.

> Haggai
>=20
>>> [2] [PATCH for-next V5 02/12] IB/core: Add rwsem to allow reading dev=
ice list or client list
>>>     http://www.spinics.net/lists/linux-rdma/msg25931.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ojvUCBMhiAggKJs2J8OcX6cXdTfbCPKri
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVukO5AAoJELgmozMOVy/dAvQP/2+FRzGRcJYvK5oe9nLSjP2d
5bFrGRIur7ea1yypvlh1Zla+yBjWisA7uf0HTPoxTLgkyxhDUaQx4lEQGMuh0pj8
t30VhydcjylDbNq5HMta1yl2P1Yfh/O6Uw14ldNi5JEIq/pHyhyORF0fT1NxUIp8
e1xdXFgGoiXHPPTbEtFyD2EO7i0RwbjBto/d2AqQ5qo6rUbSxPNqmAnWSIa5yTXd
S62+PMgG1By2BbzIzaYoeenSODEGUzMY59T3JqKkVAHwmo6Rtc5VYdtkSOd62r0t
w76htPTcvtV/s8E2IMpBWblePvPhiNlsMgatzxiBdolNbl4kOFqsJhtTbLppAE89
+u/hGahsjuP1Kt0hGrLmbnHpFnXEhT4UKx0tpNngEZ731OCYVI8+D3+lKUl9v4Fm
eb8Gago6Y4wFhbwrQ6Puml+59Cc6JsIk/lm9chfHVX5r7VDw1FC8wh9S3xiwAOMH
Uwh/9y5GcwzeMLDIFEmO3X8QhnAbNg1AXDWr4w6H5e/Tog8g+vTT/M9HeW7RoZDo
KcCcSiN2m6vmxsi/UdfU39WeEQexqQh6/WL2DUiTwmKoTM2wWfwxfqNCfyJXVnUK
tZPtCxtkeBTFD1MYOGd3PXS/5mXPikO2lPk9+4Lcq+GlRuAaBaxjqrjZmn8+D+FS
c1v/HD0zKnpRpthRHI6n
=+ns+
-----END PGP SIGNATURE-----

--ojvUCBMhiAggKJs2J8OcX6cXdTfbCPKri--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
