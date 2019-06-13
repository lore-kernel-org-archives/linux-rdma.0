From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Thu, 13 Jun 2019 08:28:53 -0700
Message-ID: <2c114313-01fe-6d4d-5134-592d1a7b829b@acm.org>
References: <20190226075722.1692315-1-haakon.bugge@oracle.com>
 <174ccd37a9ffa05d0c7c03fe80ff7170a9270824.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <174ccd37a9ffa05d0c7c03fe80ff7170a9270824.camel@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 6/13/19 7:25 AM, Doug Ledford wrote:
> So, to revive this patch, what I'd like to see is some attempt to
> actually quantify a reasonable timeout for the default backlog depth,
> then the patch should actually change the default to that reasonable
> timeout, and then put in the ability to adjust the timeout with some
> sort of doc guidance on how to calculate a reasonable timeout based on
> configured backlog depth.

How about following the approach of the SRP initiator driver? It derives 
the CM timeout from the subnet manager timeout. The assumption behind 
this is that in large networks the subnet manager timeout has to be set 
higher than its default to make communication work. See also 
srp_get_subnet_timeout().

Bart.
