From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/2] IB/core: Set speed string to SDR for invalid active
 rates
Date: Mon, 19 Mar 2018 11:53:12 -0600
Message-ID: <20180319175312.GE1225@ziepe.ca>
References: <20180315090214.21706-1-honli@redhat.com>
 <20180315090214.21706-2-honli@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180315090214.21706-2-honli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Honggang LI <honli@redhat.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, noaos@mellanox.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 15, 2018 at 05:02:13PM +0800, Honggang LI wrote:
> From: Honggang Li <honli@redhat.com>
> 
> commit f1b65df5a232 ("IB/mlx5: Add support for active_width and
> active_speed in RoCE"). Before this patch applied, the mlx5_ib
> driver set default active_width and active_speed to IB_WIDTH_4X
> and IB_SPEED_QDR.
> 
> Now, the active_width and active_speed are zeros if the RoCE port
> is in DOWN state. The speed string should be set to " SDR" instead of
> a blank string when active_speed is zero.
> 
> Signed-off-by: Honggang Li <honli@redhat.com>
>  drivers/infiniband/core/sysfs.c | 1 +
>  1 file changed, 1 insertion(+)

Applied to for-next, thanks

Jason
