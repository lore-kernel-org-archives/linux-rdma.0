From: Hans Wippel <hwippel@linux.ibm.com>
Subject: Re: [PATCH] RDMA/smc: Replace ib_query_gid with rdma_get_gid_attr
Date: Wed, 22 Aug 2018 16:19:37 +0200
Message-ID: <6612bff3-63cb-6353-a8fa-a7c8a1995e2b@linux.ibm.com>
References: <20180818021707.GA25026@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180818021707.GA25026@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>, Ursula Braun <ubraun@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org, Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 08/18/2018 04:17 AM, Jason Gunthorpe wrote:
> All RDMA ULPs should be using rdma_get_gid_attr instead of
> ib_query_gid. Convert SMC to use the new API.
> 
> In the process correct some confusion with gid_type - if attr->ndev is
> !NULL then gid_type can never be IB_GID_TYPE_IB by
> definition. IB_GID_TYPE_ROCE shares the same enum value and is probably
> what was intended here.
> 
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

I ran a few SMC tests and the changes look good. So, no objections from 
our side and thank you for the patch.

Hans
