From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Pull uninitialized_var into util/compiler.h
Date: Mon, 10 Oct 2016 07:09:30 +0300
Message-ID: <20161010040930.GF9282@leon.nu>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475879772-29458-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161009054601.GB9282@leon.nu>
 <20161009230150.GB12551@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gnQ/OOKD4CRsnGw/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161009230150.GB12551-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gnQ/OOKD4CRsnGw/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 09, 2016 at 05:01:51PM -0600, Jason Gunthorpe wrote:
> On Sun, Oct 09, 2016 at 08:46:01AM +0300, Leon Romanovsky wrote:
>
> > 1. Can we remove this uninitialized_var at all and simply replace by
> > default values?
>
> I think people would complain about the extra stores. gcc 6 will
> eliminate them, but older compilers will not.

This unintialized_var(x) adds extra store too (... x = x ...).

>
> But yes, we could do this.
>
> > 2. Do we really want additional folder to ccan with such common headers?
> > What about rename ccan to be util and put this new file there (in case
> > you proceed with it)?
>
> I see the ccan directory as stuf from ccan that we are not going to
> change, while util is for new stuff specific to this tree.

And I see this folder as a location of shared code with different utils
(ccan, custom, e.t.c), but it doesn't really matter now and I will be fine
with any directory structure layout.

Thanks

>
> Jason

--gnQ/OOKD4CRsnGw/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+xR6AAoJEORje4g2clin3fEP/1/heMSP26bv5y7kxdYcRSJV
aWj0xdZaUGYmrvzJHTamxDsFUe1ImDoSOIp8BBuSxqWy3+evvlIchzDw4XYzpTTZ
j1t4LSIQ0ht8/5CdvyhC8RJEhGSWEmuBw+8ukncfrBIMznEOH7NEgT5ygo9++zYe
ul1G/2jYI6twvvZ7ikXZ/uwYrF+wRXap12FQw4ddtomX2SwYd+l/caqYywHmpgFb
MljSAWwY5mVwx2dkIbFfKC/zJK3ia9Jck8IrY7ciJ2c4vrGox3Surof3Du75APSm
1y88jmsxE70t3EzmaeGhTegmIjlMwMuCLhOv7H7TtIIQGrlgJPCBscRO99VnSiFX
YSfQAapXTrHsF3+JK0eudBofRrfsBnhYacrUzMtESKsv1sGV6+dBfzTfWTpQniAG
8C31adNS/i+fDPtvOUh0s7W52kgL/LDozsoStb2bjdMX0MPvZ8cCdOIUZNO3kPi6
gtS0vOkgtX7RVRbtose3PuK/ooZJYXdCz1wl0Sz4+vpRJMSQd7eAjKlzju0GRTIS
m49781e9XRHNfb8O/5B0Yhywq3Zq0h6cR2TkoAiwOao7xJ6vChaADdXzkaMgB3v6
6scx+GxLCFXr+8cGRcwBNWdyVcqWWnQ6yidpXz2WZ+QlD4fHjosvXzbBgBO1A1C6
KZtKxc19kV52jL44c8rX
=eOA/
-----END PGP SIGNATURE-----

--gnQ/OOKD4CRsnGw/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
