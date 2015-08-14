From: santosh shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH v2 12/12] rds/ib: Remove ib_get_dma_mr calls
Date: Thu, 13 Aug 2015 19:47:18 -0700
Message-ID: <55CD56B6.5070409@oracle.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1438298547-21404-13-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438298547-21404-13-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On 7/30/2015 4:22 PM, Jason Gunthorpe wrote:
> The pd now has a local_dma_lkey member which completely replaces
> ib_get_dma_mr, use it instead.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>   net/rds/ib.c      | 8 --------
>   net/rds/ib.h      | 2 --
>   net/rds/ib_cm.c   | 4 +---
>   net/rds/ib_recv.c | 6 +++---
>   net/rds/ib_send.c | 8 ++++----
>   5 files changed, 8 insertions(+), 20 deletions(-)
>
I wanted to try this series earlier but couldn't do it because of
broken RDS RDMA. Now I have that fixed with bunch of patches soon
to be posted, tried the series. It works as expected.

The rds change looks also straight forward since ib_get_dma_mr()
is being used for local write.

So feel free to add below tag if you need one.

Tested-Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
