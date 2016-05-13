From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/6] IB/hfi1: Clean up char devs and destage driver
Date: Fri, 13 May 2016 13:16:36 +0300
Message-ID: <20160513101636.GE11827@leon.nu>
References: <20160512172500.11667.11333.stgit@scvm10.sc.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160512172500.11667.11333.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 12, 2016 at 10:27:49AM -0700, Dennis Dalessandro wrote:
> We realize there is still an on-going effort to redo the verbs uAPI and
> understand that may have an impact on our use of the /dev/hfi1_x cdevs and are
> looking forward to working with the community on that front. However we do not
> believe that alone should hold the hfi1 driver in staging.
>

There are the same believe for RSS and Selinux patches.

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXNamEAAoJEORje4g2clineqgP/3k44OWFcOnZcgOSiLzzmVp2
NnAKHnyd4U5NxwNvLp19VoHrLsVXQZ2b4y0F8groRijLejYDavZkRzemRfXtCaj+
5FCP2MTRo9LY5B8v4p93+Qso3CKMsf8wkFWEBDezZbZ7L5wx+5P0z3bEvEMTGOIW
jigpWTIww/wYHwakDBFK7/FqQsoUryPwnXE4oWdHPHSdfxhUVyOHYF8OZrR28eV1
/aOeyRlKR2GlmsFqBKj/mPVR/v08DYbHKMFeCmKkPs8c+YiBMYuUXbCpFrUzmJoB
QK8qjJoHisZwDQhDz9mtWzAw6DGZcO33g5uS23wJ54kFC7zR+WgSO0SYZsJsFpz+
9k4/fK78WG7g7uEiBBJHB6RbZrP7+ubyzHmaWN+BNZcWzlA7YCX2RIj6gV8azR9Y
cskrJIOJpwr/s7jmNC06PKHQOhVqpQSJsQVFkBPu37ujqjQ/rVPaEJq1m5ZKRR62
71xvG1bnr7mEPekWvinaru24zVOhr3dytKER8wKkR05e4g1ZAymkajQzKySYfqkl
tCfnEQDEcZ+gdpZIBWi6hhd0VM3oSVJVb5TLxKImY8omGdL18FoDrmwLVTwm9Slb
g1/gySscfiMju2hMrPE1lXrH82d0/TPD8E/KPsYUc5pY5CB8oEDpb8uuO0oRptxY
exY2JTRXCuYv+yZAYD3A
=iwfL
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
