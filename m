From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Fri, 31 Jul 2015 15:20:40 -0700
Message-ID: <55BBF4B8.2050700@sandisk.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On 07/30/2015 04:22 PM, Jason Gunthorpe wrote:
> All patches are compile tested. I've done basic testing up to and including
> the IPoIB patch, the rest required specialized setups I don't have access to,
> but are fairly straightforward.

Hello Jason,

SRP login fails with this patch series applied on top of Linux kernel 
v4.2-rc4. At the target side the following message appears every time 
the SRP initiator tries to log in: "ib_srpt: RDMA t 5 for idx 0 failed 
with status 10" (10=remote access error). That causes the initiator to 
receive a flush error (5).

Bart.
