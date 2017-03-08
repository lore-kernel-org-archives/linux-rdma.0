From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH 14/26] IB/ocrdma: Improve another size determination in
 ocrdma_add()
Date: Wed, 8 Mar 2017 16:27:55 +0200
Message-ID: <20170308142755.GL4828@yuval-lap>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <97417c29-a9d0-d30b-952a-3b3325a52bcf@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <97417c29-a9d0-d30b-952a-3b3325a52bcf@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 08, 2017 at 02:10:33PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 7 Mar 2017 22:12:36 +0100
> 
> Replace the specification of a data structure by a pointer dereference
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> index 9caa4c564e34..c49b4491d4e7 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -303,7 +303,7 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
>  	u8 lstate = 0;
>  	struct ocrdma_dev *dev;
>  
> -	dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(struct ocrdma_dev));
> +	dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(*dev));
>  	if (!dev) {
>  		pr_err("Unable to allocate ib device\n");
>  		return NULL;

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
