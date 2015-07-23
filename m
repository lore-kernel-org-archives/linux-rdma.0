From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 06/10] IB/iser: Use pd->local_dma_lkey
Date: Thu, 23 Jul 2015 13:49:12 +0300
Message-ID: <55B0C6A8.6020708@dev.mellanox.co.il>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1437608083-22898-7-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437608083-22898-7-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On 7/23/2015 2:34 AM, Jason Gunthorpe wrote:
> Replace all leys with  pd->local_dma_lkey. This driver does not support
> iWarp, so this is safe.
>
> The insecure use of ib_get_dma_mr is thus isolated to an rkey, and this
> looks trivially fixed by forcing the use of registration in a future
> patch.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
