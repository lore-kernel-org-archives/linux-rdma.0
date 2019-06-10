From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/mlx4: Spread completion vectors for proxy CQs
Date: Mon, 10 Jun 2019 14:53:36 -0300
Message-ID: <20190610175336.GA4890@ziepe.ca>
References: <20190218183302.1242676-1-haakon.bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190218183302.1242676-1-haakon.bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, jackm@dev.mellanox.co.il, majd@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 18, 2019 at 07:33:02PM +0100, Håkon Bugge wrote:
> MAD packet sending/receiving is not properly virtualized in
> CX-3. Hence, these are proxied through the PF driver. The proxying
> uses UD QPs. The associated CQs are created with completion vector
> zero.
> 
> This leads to great imbalance in CPU processing, in particular during
> heavy RDMA CM traffic.
> 
> Solved by selecting the completion vector on a round-robin base.
> 
> The imbalance can be demonstrated in a bare-metal environment, where
> two nodes have instantiated 8 VFs each. This using dual ported HCAs,
> so we have 16 vPorts per physical server.
> 
> 64 processes are associated with each vPort and creates and destroys
> one QP for each of the remote 64 processes. That is, 1024 QPs per
> vPort, all in all 16K QPs. The QPs are created/destroyed using the
> CM.
> 
> Before this commit, we have (excluding all completion IRQs with zero
> interrupts):
> 
> 396: mlx4-1@0000:94:00.0 199126
> 397: mlx4-2@0000:94:00.0 1
> 
> With this commit:
> 
> 396: mlx4-1@0000:94:00.0 12568
> 397: mlx4-2@0000:94:00.0 50772
> 398: mlx4-3@0000:94:00.0 10063
> 399: mlx4-4@0000:94:00.0 50753
> 400: mlx4-5@0000:94:00.0 6127
> 401: mlx4-6@0000:94:00.0 6114
> []
> 414: mlx4-19@0000:94:00.0 6122
> 415: mlx4-20@0000:94:00.0 6117
> 
> The added pr_info shows:
> 
> create_pv_resources: slave:0 port:1, vector:0, num_comp_vectors:62
> create_pv_resources: slave:0 port:1, vector:1, num_comp_vectors:62
> create_pv_resources: slave:0 port:2, vector:2, num_comp_vectors:62
> create_pv_resources: slave:0 port:2, vector:3, num_comp_vectors:62
> create_pv_resources: slave:1 port:1, vector:4, num_comp_vectors:62
> create_pv_resources: slave:1 port:2, vector:5, num_comp_vectors:62
> []
> create_pv_resources: slave:8 port:2, vector:18, num_comp_vectors:62
> create_pv_resources: slave:8 port:1, vector:19, num_comp_vectors:62
> 
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> ---
>  drivers/infiniband/hw/mlx4/mad.c | 4 ++++
>  1 file changed, 4 insertions(+)

This has been on patchworks for too long. Is it still relevant, or
were you going to respin this with Chuck's 'least loaded' idea?

Thanks,
Jason
