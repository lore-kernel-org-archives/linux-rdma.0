From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/20] IB/hfi1: Remove hyper-thread siblings by walking
 CPU mask
Date: Thu, 20 Apr 2017 20:34:20 +0300
Message-ID: <20170420173420.GR14088@mtr-leonro.local>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <20170409171537.10579.68545.stgit@scvm10.sc.intel.com>
 <20170410074904.GA26626@infradead.org>
 <5CDA63463B33C94CA80846587415F07704076B86@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DITGHUV3p5DjDsXt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5CDA63463B33C94CA80846587415F07704076B86-8oqHQFITsIGkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Struk, Tadeusz" <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--DITGHUV3p5DjDsXt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 20, 2017 at 05:20:18PM +0000, Sanchez, Sebastian wrote:
> The irq layer PCI_IRQ_AFFINITY flag makes pci_alloc_irq_vectors() spread all the interrupts around the available CPUs, however, the API doesn't allow to exclude the hyper threading CPU cores or limit the CPUs to use for the affinity mask. If the API had a way to provide an affinity hint into this function instead of having them automatically generated it provide more flexibility to the hfi1 driver.

It is open source, add it if you need it.

Thanks

>
> Sebastian

--DITGHUV3p5DjDsXt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj48RsACgkQ5GN7iDZy
WKf2gxAApd3EBpoAx31IBt+a9LFMvpz+nfs4StxNZtY+EruJMUnRdiIlhltSE7xO
eE7DEJrnfxghuc+N59RKf7bZM5U2/TvnKyqKD/LQ26quTgnn9+zOO5/9qUGmyWFp
Gqq4mDJRYKRBeQr/1zshXvjgPfp3Da+Bl4bxDIdPa0y6VTc0ueU7it94bQo2EGux
ZVYn0n/VVJ7U/aeIitK+Dao1UxjXW6KttCfwHW59ha9czTgXvBxYdBBmHDU4qSvs
9blMQECIVOtiCHfDHANYd1IU2/7SPmPu/DHL0Q7GClAetP/6ekxvxhVEsLJ0G6tE
npmcGC5804XfPCruubbXiipXN3RZxlYxfXLuuatWTqFVVzKr4vvMx/1zOgXAbj4q
qInRhr5faXfw40gpa/Qc0pQnh0NxHtyryyEoUVaSjiHLWIMPjIHTbg8mmw5YpTOg
5LJ6DlzhYfZMoT+K8+9ZK6LN7yplLnkb2YocQ05dCG8Y9nTRUoN3xBFSqIejL6ib
Fci9BtT695r330QyIOBvRlULPMu0m96dK58wffwr7qj/5LFdGFmBtNM5xBYuhIYN
nmflElaKNHM8tE+fnqhjzzsx3fGLuJffQT+kh630nVipfWUDhvk21UoL42kSo7J3
4IpiTiqrdRRalsCm0JgVq4UGftUtF8bbSVbXOpCahwC4A9dAjB0=
=9INZ
-----END PGP SIGNATURE-----

--DITGHUV3p5DjDsXt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
