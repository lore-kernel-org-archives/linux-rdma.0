From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC rdma-next 2/3] IB/core: Export mlx5 vendor specific
 strucutres
Date: Thu, 15 Sep 2016 09:25:12 +0300
Message-ID: <20160915062512.GL26069@leon.nu>
References: <1473841649-8923-1-git-send-email-leon@kernel.org>
 <1473841649-8923-3-git-send-email-leon@kernel.org>
 <20160915061336.GA4869@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tv2SIFopg1r47n4a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915061336.GA4869-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tv2SIFopg1r47n4a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 14, 2016 at 11:13:36PM -0700, Christoph Hellwig wrote:
> > index 4edb0f2..e804cc3 100644
> > --- a/include/uapi/rdma/Kbuild
> > +++ b/include/uapi/rdma/Kbuild
> > @@ -7,3 +7,4 @@ header-y += rdma_netlink.h
> >  header-y += rdma_user_cm.h
> >  header-y += hfi/
> >  header-y += rdma_user_rxe.h
> > +header-y += providers/
>
> Can we avoid the horrible providers name?  The directories for drivers
> in the source tree so far are called hw/ and sw/ so we should stick to
> that here as well.

I don't like providers name too, but I don't want to stick to
drivers/.../{hw|sw} either. Any redesign there will lead to
disconnection between UAPI directory and internal structure.

--tv2SIFopg1r47n4a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2j7IAAoJEORje4g2clinHPoP+QFyNWaucD24UTOUy5DfA1Ob
cE3XfiOESIXMUDnGbQpZwbvkbQAVoqw2XBcQffKiP6IaAnW2gYxgihBqAg8yAK23
Nrfcwb7Gmroi3gDQhMueaxtErb9CUm62/xMJB6afZLEyP0MtXG5M8e06ZUJVXK6N
Qf70sL7fU9vTwCQPeidxzRn2JEx1mpw0ABeMLjcUsO9hMSE7k3V6vrA8/Ja30UGn
9lbAnpUEcVX+ihM0e/w+qLMIBC73HnalvVdm0NFr1HDHNVJBiZAUOutgeM/Di14i
+Y1Dta3bhKbXT/3BwZP7rgJGoWQ0fXWaRI3/TreonIfRpIjdjR2BtIqrXqOdgL+R
srCbK10MGFZNov1HXH3om167OntaC2YpRlTF3pKCsPbfPpCxaysE1/i2bIKtsuxp
c4iGLVYXC9tKYzY642Of9GSb9nvVjMm7Vgg4OmrTuH3HtdRpsFuVB9TvpSS9pIDw
Cbb4+hjnPqwpxpV/zUgOrjDHFUcsZLozioz8YTbBnB561AABz8HpQOuVyFR0dFjT
XErZOLJ5059QFxzjANqsLQNydA1ehv7L3PFOg9JIzJun8k8T+J38Y/mK1OF9RzV/
L+Wv/YPs4wwZXYR4OLTBZsyjOUIw3OAEbmnDLZ4A9OxNhK+Ux5i8dd9JiLbzSQ7+
6/WFW8NgNTQOEtaPzHUJ
=ZX3O
-----END PGP SIGNATURE-----

--tv2SIFopg1r47n4a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
