From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-rc v1 0/4] RDMA fixes for-4.13
Date: Fri, 04 Aug 2017 14:30:58 -0400
Message-ID: <1501871458.79618.8.camel@redhat.com>
References: <20170801064137.8360-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801064137.8360-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-01 at 09:41 +0300, Leon Romanovsky wrote:
> Changelog:
>  v0 -> v1:
>   * Added Reviewed-by tags
>   * Moved 10 patches to -next
> 
> Thanks
> ----------------------------------------------------------------
> 
> The following changes since commit
> 5dc78ad1904db597bdb4427f3ead437aae86f54c:
> 
>   IB/ipoib: Notify on modify QP failure only when relevant (2017-07-
> 23 10:52:00 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> tags/rdma-rc-2017-08-01
> 
> for you to fetch changes up to
> 0626c5a5dec2e601f06a2c03b295fb7d7288e29c:
> 
>   RDMA/mlx5: Fix existence check for extended address vector (2017-
> 07-31 20:43:06 +0300)
> 
> ----------------------------------------------------------------
> RDMA fixes for 4.13
> 
> This patchset contains four patches:
>  * Two kernel panic fixes from Yishai and Parav.
>  * The bugfix to mlx5 wrong usage of big-endian variable.
>  * Preventing leak of reserved field.
> 
> ----------------------------------------------------------------
> Leon Romanovsky (2):
>       RDMA/uverbs: Prevent leak of reserved field
>       RDMA/mlx5: Fix existence check for extended address vector
> 
> Parav Pandit (1):
>       IB/core: Fix race condition in resolving IP to MAC

This patch, in particular, was very similar in description to another
patch I already took for this -rc cycle.  Both of these patches ended
up using ordered workqueues to resolve the problem.  Finding two
different workqueues that needed to be made ordered in the same -rc
cycle makes me wonder if we might not have some other issues lurking in
the subsystem in regards to workqueues...

> 
> Yishai Hadas (1):
>       IB/uverbs: Fix device cleanup
> 
>  drivers/infiniband/core/addr.c        | 62
> +++++++++++++++++++++++++++--------
>  drivers/infiniband/core/uverbs_cmd.c  |  2 +-
>  drivers/infiniband/core/uverbs_main.c |  3 +-
>  drivers/infiniband/hw/mlx5/odp.c      |  2 +-
>  include/linux/mlx5/qp.h               |  1 -
>  5 files changed, 51 insertions(+), 19 deletions(-)

I didn't use a pull (mainly because I was going through patchworks and
saw the patches and took them from there before I saw the cover letter
here with the pull tag...that and I'm not used to the pull request
model so hunting through patchworks for the relevant patches is second
nature and pull requests aren't).  I'll try to keep the pull option in
mind next time.  In any case, thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
