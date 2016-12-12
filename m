From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Reorganize structures to align with HW
 capabilities
Date: Mon, 12 Dec 2016 17:15:14 -0500
Message-ID: <47f91af9-f1f8-e888-d680-81d6ceac0efe@redhat.com>
References: <20161206221620.36524-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gwQmiaiMLFlRvAW1BSawVKcHf9eqXI3xN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206221620.36524-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gwQmiaiMLFlRvAW1BSawVKcHf9eqXI3xN
Content-Type: multipart/mixed; boundary="Q7vW7nFvJNAMmONo6KgM0L9oekh4EChxe";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <47f91af9-f1f8-e888-d680-81d6ceac0efe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Reorganize structures to align with HW
 capabilities
References: <20161206221620.36524-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20161206221620.36524-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--Q7vW7nFvJNAMmONo6KgM0L9oekh4EChxe
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/6/2016 5:16 PM, Henry Orosco wrote:
> Some resources are incorrectly organized and at odds with
> HW capabilities. Specifically, ILQ, IEQ, QPs, MSS, QOS
> and statistics belong in a VSI.
>=20
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Big churn patch applied, thanks ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Q7vW7nFvJNAMmONo6KgM0L9oekh4EChxe--

--gwQmiaiMLFlRvAW1BSawVKcHf9eqXI3xN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTyFyAAoJELgmozMOVy/dvBwP/21Oz64ZPP05du4BhsfCS6QF
qBlJ5LNEzViTtT2IVv4/llgJ5jqYAD+xCRun/gm2BEKkHtP35GqzrWQw7jf0Se+G
JVcO7RFHkX75Kj5btX9pG3UrFBxFmd3EgX6iVw21P8IjLXunuGDRT6bnzdzbnYMs
Q/jrHn44qmGX+Qx+oyrah7LZmpxnCa7WlfNXsqDytcBXz3U5eXYMSCIgXaKv2I80
4rOjVcVfyZXCOfzlrbc9e1qjke4ALMMjS/xFqtstHMqpq6ouGoZOUz67prDlpnv1
2KUNNLaniPOIt2/y5ff8rXltSwtXFBd27MXhxUMN8RZNZwKR+8aB/wTTj9KZWHat
GiinmpInzUPtwLo/D9q3C4zvDqST1dFyyUK3FLkipL9ha30vE7Md2JkgGQ2fRXLL
tuxJhREg/HwSWZuRtRygbKABKAOS5mSN46kpi/FR7z64YYZldQAYIkQ6A4hvW0tV
5ocROIzH94FVhINuozSuWHa84KAGnUkChhAtmGo9NXDx4uxI3dYO30O2I4LfsUgf
WT8kT+Jv2IdQdDhwz9bHMu6kuSHpUJViqLwBj4jQz6ad4mK1BNcGWVXOhxyLZlyr
QoEWWr5aJPTqcOOBGTevGFASBrCUtm6sVDoUbdregudKUaJaX0e+PiZj9tfwnOeb
IqCmJ2nDYVQJcAOPogiR
=UfAU
-----END PGP SIGNATURE-----

--gwQmiaiMLFlRvAW1BSawVKcHf9eqXI3xN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
