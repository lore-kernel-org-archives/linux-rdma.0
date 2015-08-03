From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 09/12] IB/srp: Do not create an all physical insecure
 rkey by default
Date: Mon, 3 Aug 2015 10:18:34 -0700
Message-ID: <55BFA26A.6010007@sandisk.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1438298547-21404-10-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438298547-21404-10-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On 07/30/2015 04:22 PM, Jason Gunthorpe wrote:
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 19a1356f8b2a..a8003079c232 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -69,7 +69,7 @@ static unsigned int cmd_sg_entries;
>   static unsigned int indirect_sg_entries;
>   static bool allow_ext_sg;
>   static bool prefer_fr;
> -static bool register_always;
> +static bool register_always = true;
>   static int topspin_workarounds = 1;

Hello Jason,

Can you modify this patch such that the default value of prefer_fr is 
changed from false into true ? The only reason I had not made fast 
registration the default myself when I introduced FR support in the SRP 
initiator driver is because at that time the FR code in the SRP 
initiator was brand new. However, since the introduction of FR support 
in the SRP initiator that code has been tested extensively (at least 
inside SanDisk).

Thanks,

Bart.
