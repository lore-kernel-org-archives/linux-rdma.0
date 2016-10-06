From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Thu, 6 Oct 2016 07:53:37 +0300
Message-ID: <20161006045337.GK9282@leon.nu>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161005115132.GE9282@leon.nu>
 <20161005163250.GB18636@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RVlUGXxwBj5SDcM9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005163250.GB18636-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--RVlUGXxwBj5SDcM9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 05, 2016 at 10:32:50AM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 05, 2016 at 02:51:32PM +0300, Leon Romanovsky wrote:
>
> > I'm using 16.04 and it has gcc 5.4.0 as a default. Don't you think that
> > 6.2 is too "new" for us and other distributions?
>
> I don't understand how a compiler can be too new? The next round of
> rolling release distros are likely to use this compiler, and those are
> the distros that will first pick to up rdma-core.

I have an issue in front of my eyes where kernel fails to build with old
gcc version, while new gcc version works.

I don't want the same situation here.

>
> > gcc (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609
>
> This is exactly why the automatic builds should run the latest
> compiler, because people are not going to install it on their desktop.
>
> People will test with older compilers on their own. If we want to run
> automatic tests from travis with old compilers we can, but my results
> basically show that older compilers are just buggy and produce
> incorrect warnings.

My experience shows the same, however I want to minimize the test burden
on the users.

>
> Jason

--RVlUGXxwBj5SDcM9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9djRAAoJEORje4g2clinYlQP/0sKwot6re6X4+RxwSa3P1E2
rcdM8dbJ2Gz7lpeCcitsgP7C3FSP7OVtGBhPhhvg8GA5c40wU95JMhTsyLv2vGWE
8cXrx2DEUv+4pZfAgTDuO0HxImpYuWPC6PLCixMu5G6EiAIG8RJR829kW+Cly5Th
q6wU7/zCbpyjkn85jT5jlE5Fhzbf4u852aGedt6oF8dvjh6zOVx5nTAhDJbZsitO
Ea8w4q+BjCoI2hWMKYxinIhkPeZO9VxNyEbXXd+H7ElgKtx1d9R4/kjR5yVJL8+D
lJwtBNSLuaKXSMoqwsW4bV80f8MIlWLJTYvDx7JWx+A2pz5dUh+oBYcIpMAmADCH
CXatW6KSlyy9f8NUZnmdhyysTwi6hNwsajQow9cxIferM2VFGkbQPrk0ZsSTo2z7
yJtdh/icp6vyztdvOAyIIjueJRlRp0Ou40yP47vfdys+i6jgMdWWH0BObhhszp19
YZj9UJM0YohcbLjk2znm9ALEJ/LTNHfKgeiD7NYfxz1thQR/FXd569WI73FRH0aG
vYPWe4gjTW8NfHhB7bX1LeyX1qkGY3x/CRwQPQ05WJQFg9qefQMwxKuKq/4uGwCo
w4M8c+AnNkTs9OFAZHHigtMzRoGpSfWJxn1KE6JV8SvCV4cHVDw463LfFdVkyGn5
x6ayLRFFeT6j0DlQH+el
=SEo1
-----END PGP SIGNATURE-----

--RVlUGXxwBj5SDcM9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
