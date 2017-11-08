From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 2/9] IB/isert: use implicit CQ allocation
Date: Wed, 08 Nov 2017 02:27:14 -0800
Message-ID: <1510136834.29624.78.camel@haakon3.daterainc.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
         <20171108095742.25365-3-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20171108095742.25365-3-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, Max Gurtuvoy <maxg@mellanox.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-11-08 at 11:57 +0200, Sagi Grimberg wrote:
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> [hch: ported to the new API]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 165 ++++----------------------------
>  drivers/infiniband/ulp/isert/ib_isert.h |  16 ----
>  2 files changed, 20 insertions(+), 161 deletions(-)
> 

Likewise.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
