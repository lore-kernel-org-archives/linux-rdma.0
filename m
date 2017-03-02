From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 20/20] IB/core: If the MGID/MLID pair is not on the list
 return an error
Date: Thu, 2 Mar 2017 17:13:43 +0200
Message-ID: <20170302151343.GD14379@mtr-leonro.local>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
 <20170301182426.29989.77369.stgit@scvm10.sc.intel.com>
 <20170302140028.GE9525@mtr-leonro.local>
 <4d49f7ab-5bc5-029c-4321-fd349c9dc0f8@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8nsIa27JVQLqB7/C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4d49f7ab-5bc5-029c-4321-fd349c9dc0f8-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 02, 2017 at 10:01:25AM -0500, Dennis Dalessandro wrote:
> On 03/02/2017 09:00 AM, Leon Romanovsky wrote:
> > On Wed, Mar 01, 2017 at 10:24:32AM -0800, Dennis Dalessandro wrote:
> > > From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > A list of MGID/MLID pairs is built when doing a multicast attach.  When
> > > the multicast detach is called, the list is searched, and regardless of
> > > the search outcome, the driver detach is called.
> > >
> > > If an MGID/MLID pair is not on the list, driver detach should not be
> > > called, and an error should be returned.  Failure to do so can leave
> > > the Multicast list out of sync with what the driver has.
> >
> > It took me a while to understand your last sentence.
> > Can we add Fixes line and submit it to stable too?
> >
> > Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
>
> We'll reword the last bit there and add the fixes line and Cc stable.

Thanks, I appreciate it.

>
> -Denny

--8nsIa27JVQLqB7/C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli4NqcACgkQ5GN7iDZy
WKeZww/+InIQmEuf/pDi5ULzi+mmbapl03FX9CG0PEau42AYljDZD7J5ivSFpbmy
qNBcJTiT8qIQOFodZisKAnrpKZDl5kztiFnVsGsgldKrgeVUcHYxW7TLdZgow5Lw
RUUzzdGCdlVefWTSOb7VejjP1VoEXF7XG5P8xTAXZDnvrStnk3lpN8vw0vzU6HKJ
yfQaUMwVWbsxVvGKj+xXYBt1do1uZeAnOCnRoSDRgryi3do5DO/YtCAWHVLmWzJP
DCMkL6qshgxplvhQHQTJ9g5dmq41jtZT9dZRBMmsKoRyonya2MdfrHz0eN7sajYo
LsYDJt8yvvHloiOO4Qq8hmQTlGFo+RVTujTTPRLJmpwLs+zXTP28sLp8RVC2hUJe
uNeEGiPLVHt4029iGGNhijqMr+F2woe0LHpWrzeMmubOGM4QLpwijDp28bnECadG
Gaq1wzym/3L6DvZle6nZjnT2k6nmOG0d/0KezXT6/lw2l0xlS8MVxPdTdEvrpwKt
BNwkpgc7SzsibkxRrdIWgLee5mXL2Z4p0bv8s2VUPZmAc/VHyxLNBJBosyh9/hqn
q8wqrGsjRdrUIu3OaqqkrVhD9psqWEkPl64QtArpVT90iKNhpgc4GsopP0DcfCXG
ZSpiLQBKnuu1AUSTkcXl8w5Hby1PYamfKgzsRkzgtClCrif2CZ8=
=1YkI
-----END PGP SIGNATURE-----

--8nsIa27JVQLqB7/C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
