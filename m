From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v4 2/2] IB/qib: use arch_phys_wc_add()
Date: Wed, 22 Apr 2015 09:54:38 -0400
Message-ID: <1429710878.45956.94.camel@redhat.com>
References: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
	 <1429653035-19424-3-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-i1OaxEyZGKNoZjkKBi/K"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429653035-19424-3-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, luto@amacapital.net, mst@redhat.com, linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>, Toshi Kani <toshi.kani@hp.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Roland Dreier <roland@purestorage.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Antonino Daplas <adaplas@gmail.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Dave Hansen <dave>
List-Id: linux-rdma@vger.kernel.org


--=-i1OaxEyZGKNoZjkKBi/K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-04-21 at 14:50 -0700, Luis R. Rodriguez wrote:

This:
> +	/* MTRR was used if this is non-zero */
> +	if (!dd->wc_cookie)
>  		vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);

And this:
> +		dd->wc_cookie =3D arch_phys_wc_add(pioaddr, piolen);
> +		if (dd->wc_cookie < 0)
> +			ret =3D -EINVAL;

don't agree on what wc_cookie will be on error.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-i1OaxEyZGKNoZjkKBi/K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN6geAAoJELgmozMOVy/dINYQAJVTs2h1J+xLHdOCMfjEZeW+
fnyf6xbapVV/GaP5VMoJVpZmYLCYgwjJdUTVfYtY80RaahnH8cbJfgPxiYYtQgKE
A+M8S9rKNsUM1P4NpxhHm1eKQT3bPEwJm/zvIIGN9d5+9t+/tb1cFSXB5JX+3Fj9
HCuTibuq0Wz4/wyBMhCX/x1c7VB/oSImUOruXXIO1WDX2D8a/N1xWjYb9NIDC0KN
hZnLFqDXSEopDVaoNXExuy4HPbXCPC6aRaWUo0kQYeXiNjchmz9Gd5FTV9J9/Oig
0mxe58sksx+3Sj+pEdFOON0kKNawGQ22eun51By+U69OAqyoXi63I3dhR6J0DtXR
Fl5fLCmTvKyr1c/zwzXwBQRWSOqg4ZLc5mk1VIQXN6iax3NZhMNo7tfLJ9tcceTa
CikprNiQWJuJhG5USuxW7u2M4ZIk5NnqVa5sYgb2+JTlDp/zvIz8/UdF71h0yPuD
oPEzr6IeRWSrPPyPQT055+3LyzaeRokbRmKPtWi044iJ8XD7fZzACha15zPts+dX
nCk4jqlkS6x4wYmj0MruZCFr/7nBZP1f/yNX2nMN+3QD1NdwQuP27IlS2zDJj/DT
94giD43UUxEgcqC/eQBpxJ7xoS2MQ5fcC6m+WchlE6CVw95kZojyxRnkYtJGgyDQ
m4tBzsqPGq58MMnI9Fz6
=pViF
-----END PGP SIGNATURE-----

--=-i1OaxEyZGKNoZjkKBi/K--
