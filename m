From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: trivial sparse fixes for rdma-core
Date: Fri, 14 Oct 2016 07:37:05 +0300
Message-ID: <20161014043705.GF9282@leon.nu>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
 <20161013190326.GA19904@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Km2V3aJx5eFEhJmw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161013190326.GA19904-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Km2V3aJx5eFEhJmw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2016 at 01:03:26PM -0600, Jason Gunthorpe wrote:
> On Thu, Oct 13, 2016 at 07:51:03PM +0200, Christoph Hellwig wrote:
> > This is the low hanging fruit in terms of reducing sparse noise before
> > looking into endianess and iomem annotations.
>
> Looks fine to me. Since I gave them a good compile test I also
> prepared the pull request for the first 15 that made it to the list:
>
> https://github.com/linux-rdma/rdma-core/pull/19
>
> Here is the patch to turn on gcc -Wstrict-prototypes
>
> https://github.com/jgunthorpe/rdma-plumbing/commit/dd80c3b362ae90d0de36a6249409c20581bae864

I didn't look on it yet, but maybe someone already knows the answer.
Can we run static analyzer tools as part of our TravisCI runs?

--Km2V3aJx5eFEhJmw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYAGDxAAoJEORje4g2clinGosP/RahQ3MjLZSPkO/rBpjmbMGg
CrINWd+JksQv95eODotec0zjKvu5WcmuV89nAv+Oyg7kgTF8GLp69VVqhlk42+xe
cHNuxyTziFtP3LwERbsy+E6m5bZp2f4zwpHnq9AGc8eE1nzbWfWCnYfVblhzLCcq
9Xztor+QF7rU+MLglFyjfcSGhEu3ZhKlsV9NM7g/b63irB4j8q23LHe8kCUiFgBF
N9uzU9VoROSrA21fCkhQjXc+67K0ODUjEAcZ9uagyXXZ63u/2IFdsxFLW1Q6xp0U
LiJaybYTUTUYVmgwIfwHM6ALh9L4a6jG8xCIYY5DbwSPZtM7pu2yt6O+axaTIsGn
pb6utcw9HAtpkfYgDpeDq1lJAyqURTGlI5TOfjgJapAGObxAv0cBh7CELd8lBO+W
WxSEmfA78gWxvORts8f9lla/tRuCh6b1hAsX9WQN1oFccF+fswUtHHcH1whtBPYw
q9OIHAPEuunmt9KFi7wpvf6PPHjRtM1lSlPGb73w8XQHEIwFAVivn6BAsTxmjzqs
yLypiS3Layml957IFOkbUs1WFkiPf287vgEqoQ7Sd1cv1fZEZO8KjBcweGHBobSi
gWFC7BJRN0CNW+VcAnCzgybdmlA0d45a5GdKGbwRzFD+Gq5J9BFzcx5IEwTensIS
SLLMngp1wyECvKSfq/08
=yiFP
-----END PGP SIGNATURE-----

--Km2V3aJx5eFEhJmw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
