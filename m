From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 3/9] IB/iser: use implicit CQ allocation
Date: Wed, 08 Nov 2017 02:25:25 -0800
Message-ID: <1510136725.29624.77.camel@haakon3.daterainc.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
         <20171108095742.25365-4-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20171108095742.25365-4-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, Max Gurtuvoy <maxg@mellanox.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-11-08 at 11:57 +0200, Sagi Grimberg wrote:
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> [hch: ported to the new API]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.h | 19 --------
>  drivers/infiniband/ulp/iser/iser_verbs.c | 82 ++++----------------------------
>  2 files changed, 8 insertions(+), 93 deletions(-)
> 

A nice improvement to make IB_QP_CREATE_ASSIGN_CQS common across ULPs.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
