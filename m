From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Date: Mon, 10 Jun 2019 15:55:53 +0200
Message-ID: <20190610135553.GH30967@dhcp22.suse.cz>
References: <1560199937-23476-1-git-send-email-akaher@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1560199937-23476-1-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
To: Ajay Kaher <akaher@vmware.com>
Cc: aarcange@redhat.com, jannh@google.com, oleg@redhat.com, peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com, yishaih@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, matanb@mellanox.com, leonro@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, srivatsab@vmware.com, amakhalov@vmware.com
List-Id: linux-rdma@vger.kernel.org

On Tue 11-06-19 02:22:17, Ajay Kaher wrote:
> This patch is the extension of following upstream commit to fix
> the race condition between get_task_mm() and core dumping
> for IB->mlx4 and IB->mlx5 drivers:
> 
> commit 04f5866e41fb ("coredump: fix race condition between
> mmget_not_zero()/get_task_mm() and core dumping")'
> 
> Thanks to Jason for pointing this.
> 
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 4 +++-
>  drivers/infiniband/hw/mlx5/main.c | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index e2beb18..0299c06 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -1197,6 +1197,8 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>  	 * mlx4_ib_vma_close().
>  	 */
>  	down_write(&owning_mm->mmap_sem);
> +	if (!mmget_still_valid(owning_mm))
> +		goto skip_mm;
>  	for (i = 0; i < HW_BAR_COUNT; i++) {
>  		vma = context->hw_bar_info[i].vma;
>  		if (!vma)

I have missed this part in 4.4 stable backport. Thanks for catching it.
I have updated my backport.

> @@ -1215,7 +1217,7 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>  		/* context going to be destroyed, should not access ops any more */
>  		context->hw_bar_info[i].vma->vm_ops = NULL;
>  	}
> -
> +skip_mm:
>  	up_write(&owning_mm->mmap_sem);
>  	mmput(owning_mm);
>  	put_task_struct(owning_process);
-- 
Michal Hocko
SUSE Labs
