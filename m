From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/5] IB/mlx5: Report Scatter FCS device
 capability when supported
Date: Thu, 21 Apr 2016 10:07:16 +0300
Message-ID: <20160421070716.GE12730@leon.nu>
References: <1460902778-5977-6-git-send-email-matanb@mellanox.com>
 <201604172352.60qppaot%fengguang.wu@intel.com>
 <20160421012442.GA30527@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160421012442.GA30527-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 20, 2016 at 09:24:43PM -0400, ira.weiny wrote:
> I will do my best to review this.  But to save time I'll wait for the kbuilds
> to be fixed.

This kbuilds are related to shared code patches which are required for
this patch.

We sent them in advance [1] and it is already part of netdev tree [3].
Once Doug will apply these patches [3], kbuilds errors will disappear.

[1] http://marc.info/?l=linux-netdev&m=146056392230963&w=2
[2] http://marc.info/?l=linux-rdma&m=146075537926850&w=2
[3] http://marc.info/?l=linux-rdma&m=146099436110034&w=2

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXGHwkAAoJEORje4g2clin5rkQAJVUTbXiNT9wbdIrjEGl5kGr
DOHanGkmS86T5E/x10Wb6tX5ld8GKp74/kWcd2nEVIDhKsJt34JdSLLGPbORG1lp
yNokMsK5LibHgImcxROFBgb4dL+p20yZ0eEeLgIq6IP50eqV9hu0hmcf2sgjhzDv
euU7pLWh/PayTBw/kNV7hpfKdn9O8CSxaKMKXfoGr4Sa6JkbxiaCQTUBGoPBsLex
L0Bhhhg/04uZa22AH9TLSreYdzVlDsoQnyYLLU46+h6QukJQIr/Kds1F3/YrIueT
HikolSqPXWEs10sEzqcimD8RprNUIfaNkoU2aUSciDXkdi2YdcAyCOjjCRYm555G
IG+d4YmKEsx3+6NkjY2uPwY5dbYivxZ3EtPwYHcRnaIow5Ph7wlpPeRULSqTOS54
Y+wyzn/+a2PnpR12xRWDg29bd6Z6BrWrPjhmOGu6q8IfyiGhaX3HS9c+qQzcOpyr
QXmYSPbPFPybhwqv3CDFuh3YtcB5Tm79WhXVv0Ku0TS/zNVEZmCEyCHjLw7PwgOd
Z3ZgyYlm9If/vaOtvmoVUfekeW01dWXM2TZrzKy/Mdb/ZZhQpkrFWNjXQVQffUyO
WjxAXVEqMGNCzIbG47IJ3pXcPpuwbKFXs8qsI6OyuQU3srs7YrnZp1zQfBJ5XbXq
rgAVHsUq345SQFNMFWwc
=yVR6
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
