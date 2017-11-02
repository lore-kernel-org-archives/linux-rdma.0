From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Perform package tests in Travis CI
Date: Thu, 2 Nov 2017 15:18:51 -0600
Message-ID: <20171102211851.GV18874@ziepe.ca>
References: <20171102165556.22105-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102165556.22105-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 06:55:51PM +0200, Leon Romanovsky wrote:
> This patchset comes from Alaa and he adds to Travis CI ability
> to reuse our cbuild script to build various packages.
> 
> The PR is https://github.com/linux-rdma/rdma-core/pull/241

Not to say we shouldn't apply this PR, but if we go down this road
then we should also ultimately switch to circleci since it has actual
native support for docker and crucially support for docker image
caching.

With that each of the docker images could be run in parallel instead
of sequentially and it would resolve our general issues with having to
use the ancient trusty baseline that travis uses.

AFAIK the sticking point is that we need to have a public docker
container registry, preferably co-located with circle ci's build
workers..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
