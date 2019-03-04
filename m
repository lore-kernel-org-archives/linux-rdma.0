From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3] RDMA/umem: minor bug fix in error handling path
Date: Mon, 4 Mar 2019 21:53:51 +0200
Message-ID: <20190304195351.GK15253@mtr-leonro.mtl.com>
References: <20190304194645.10422-1-jhubbard@nvidia.com>
 <20190304194645.10422-2-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SzQ167Kp6Zo0TWVn"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190304194645.10422-2-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--SzQ167Kp6Zo0TWVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 04, 2019 at 11:46:45AM -0800, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
>
> 1. Bug fix: fix an off by one error in the code that
> cleans up if it fails to dma-map a page, after having
> done a get_user_pages_remote() on a range of pages.
>
> 2. Refinement: for that same cleanup code, release_pages()
> is better than put_page() in a loop.
>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-mm@kvack.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--SzQ167Kp6Zo0TWVn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcfYJPAAoJEORje4g2clinTO4P/0fRa+62AVNr9diB7JwN2q00
R/xwy4BeamgibjxK4ajFxNiuOe8kWL4M0xidWvIUIjhsljdVwNtyKUfH6SYi3YdM
chSj9iQeluos07CWbM9VPyGGBHZfQ13aTCy9P4tx/3JD+D03lZDBoP3tm93Mms4L
mxQwjxdBnBaquIpD98cIPZm31XXFUcRR/K7kMnPOBcXp+f2yx6DfJprm3tffb2Ke
9NgfVcIV03ZlfeC/NI2bj/MC17PZgZZBK2XqVTi7Wu0iYcy9J8nRlD2kVjNq/0rG
kxPMZ/O2K65gwnNSWtWPxsL074ekD4P5Mcn9D6Qa0MeFGotoGdDrEH9gJ4hmGFxG
1vgWYZRJ26JCoGASInbPKmPQBjC1bfHyUG83E8qfHHyTDzHj8ytcXXFtW2JMCSOi
nbqqX7ww8sXyAbCW2546yxCQ3AIL93g42gkwgGoxtQioovSkQ0eJoYSOT4cDxYEY
nsECMJGMhey3kqDDQGGvzZ31RZ7byaMQY/p6mc5hewRf8HOKHJEslsA1uTh5DkHq
j4duANKV3tZyw3sWQ+bf4s2NE0/EzH4wqIQWN2x7J6u+GDGM+JM9uLalXA+2tN+e
ks9z1cS4AXflaeIpV4q7p/bdqJf3JfrSsNY9WLFiryjF5q9c/4ejwYIRcsN1wq7D
v4WszJR2m5vaYxbOgMxo
=wIFY
-----END PGP SIGNATURE-----

--SzQ167Kp6Zo0TWVn--
