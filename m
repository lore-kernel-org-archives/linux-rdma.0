From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma-core: Make room for source GIDs to be added
Date: Tue, 13 Jun 2017 13:20:17 -0600
Message-ID: <20170613192017.GC17727@obsidianresearch.com>
References: <20170613025451.31416-1-somnath.kotur@broadcom.com>
 <20170613060325.GF2576@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170613060325.GF2576-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 13, 2017 at 09:03:25AM +0300, Leon Romanovsky wrote:
> On Tue, Jun 13, 2017 at 08:24:51AM +0530, Somnath Kotur wrote:
> > Currently sgid_index is of type 'u8' so we can't really go beyond 128
> > unique GID entries(one for each type so total of 256 GID entries).
> > Change it to u16 so atleast 4k GID entries (as many VLANs that can be added)
> > can be accomodated.
> >
> > Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/core/verbs.c | 2 +-
> >  include/rdma/ib_verbs.h         | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> What type of testing did this change get?
> According to spec, "The maximum number (N) of unicast GIDs supported per endport is
> implementation specific".
> 
> mlx5 and mlx4 are limited to 128 GIDs and user will get errors if he try to set
> more than that.

At a minimum I think this patch will need to add overflow protection
on the uapi paths that cast this back to a u8, and Matan should
consider expanding sgid_index to u16 in the new uapi, whenever
possible..

.. and Somnath you should review Matan's uABI patches since you want
such a fundamental change :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
