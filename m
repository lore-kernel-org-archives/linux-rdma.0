From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/3] infiniband: i40iw: Replace GFP_ATOMIC with
 GFP_KERNEL in i40iw_add_mqh_4
Date: Tue, 17 Apr 2018 19:58:09 -0600
Message-ID: <20180418015809.GA21056@ziepe.ca>
References: <1523431945-3508-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523431945-3508-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: faisal.latif@intel.com, shiraz.saleem@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 11, 2018 at 03:32:25PM +0800, Jia-Ju Bai wrote:
> i40iw_add_mqh_4() is never called in atomic context, because it 
> calls rtnl_lock() that can sleep.
> 
> Despite never getting called from atomic context,
> i40iw_add_mqh_4() calls kzalloc() with GFP_ATOMIC,
> which does not sleep for allocation.
> GFP_ATOMIC is not necessary and can be replaced with GFP_KERNEL,
> which can sleep and improve the possibility of sucessful allocation.
> 
> This is found by a static analysis tool named DCNS written by myself.
> And I also manually check it.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied all three patches in this series to for-next, thanks

Jason
