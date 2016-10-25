From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] build: Fix build script to use correct cmake cmd
Date: Tue, 25 Oct 2016 13:12:00 +0300
Message-ID: <20161025101200.GP25013@leon.nu>
References: <20161021172728.27367.86783.stgit@scvm10.sc.intel.com>
 <20161021180523.GA554@obsidianresearch.com>
 <9745f6c7-8d09-8bed-d04c-78f610330ead@redhat.com>
 <20161021193034.GA616@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7UIJfHqpdi+oBJdT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161021193034.GA616-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--7UIJfHqpdi+oBJdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 21, 2016 at 01:30:34PM -0600, Jason Gunthorpe wrote:
> On Fri, Oct 21, 2016 at 03:03:23PM -0400, Doug Ledford wrote:
> > According to github, this change broke the travis CI build on your pull
> > request when the previous patches all worked.  However, travis is down
> > right now, so I suspect this didn't *actually* break it, that the travis
> > CI was down anyway and github logged a failure.
>
> Yes, travis does not use build.sh
>
> Maybe this is a good time to ask if anyone is interested in the docker
> stuff I have - eg should I make it pushable? It is easy to use, but
> you need to have docker installed.

I would be happy to get it and be more confident in my local tests.

>
> There are several other container/chroot/docker based toolkits out
> there for doing this sort of work, but I haven't studied that area in
> a while to see if there is something workable.
>
> The docker script is able to run almost-travis locally, as well as do
> clean package builds for all distros.

It looks like it goes beyond rdma-core definition. Do we want to put it
separately or anyway integrate into main library?

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7UIJfHqpdi+oBJdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYDy/vAAoJEORje4g2clinsewQALUTAy7e7g+GWkN5il3ltYgf
kImuMF5+r8vu1O2v/BwqPJFhuqcjWASV1GPSZybrH/y5lsNnl/R/aoLsYtE8F/vC
yBu3okNkSlrrrB+uVMbEVkRt8mLbv5mCKh74WgvJIymkkODkgttFJeZ0vU8iTsdF
dteaM5IodK60XcdJnN9k27EtrygcVaxhqWB/yGOcvOnsdS0MP8OKXaNrS7Zhw5t1
DkO/nk8Jymuq8CBCaicvr2rj7qEBnYdWqnoRxAPBYob2aJmwHNnAbiyIRN6Bmenm
hExFIghRYH7k+dusna5ahQ5Zo6cxrnjbkxbEfaOAQPn0As2q7ZynbVF1a1D/xNtM
HaVaysC0JI9gaIg1MbuIP5aMK2jLcB87xEvuagBkJM0+MBnpnx/8HKdgHncSeDMp
8ou6dzFGGUP8vs1ukXwvAlRPiSF/ZQ7cMHT3+AvIDHUjNpxddcRUvEfK06ZFhqgY
zounUNaLAieaLY7LJjRLTIhx0r6vGKZ+ZH2fpfX19X8cBNC1cCJjct33DUrJt7tF
aU8M0r8trstRQt4X94A96wbp5A0iraZCVJUuI14l9uEEvqh5BzvyScYkxsOJ9eUp
jLz4dx5zPtLLCT/4JDAzuU6QyRr3DckYYRMzVly7xv3RQkLieXlACl+KfaYKLTst
hCFa1VGJmeqqTDewOQks
=pKvW
-----END PGP SIGNATURE-----

--7UIJfHqpdi+oBJdT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
