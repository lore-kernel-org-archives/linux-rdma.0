From: Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH] ib umem: bug: put pid back before return from error path
Date: Thu, 22 Dec 2016 10:00:57 +0200
Message-ID: <e470fbab-a330-b9c4-f2b3-65fb45f24e0a@mellanox.com>
References: <1482390692-147946-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482390692-147946-1-git-send-email-liguozhu@hisilicon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kenneth Lee <liguozhu@hisilicon.com>, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no, vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com, krzk@kernel.org, sebott@linux.vnet.ibm.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

You have two bugs here:
1) When using ODP, ib_umem_release() checks for umem->odp_data != NULL 
   calls ib_umem_odp_release() and returns immediately without calling put_pid().
   This one isn't in the error path so the title doesn't fit.

2) In case the allocation failed, we return in -ENOMEM without calling put_pid().

Can you please resend this with proper fixes line and a better description of what is going on.

On 22/12/2016 09:11, Kenneth Lee wrote:
> I catched this bug when reading the code. I'm sorry I have no hardware to test
> it. But it is abviously a bug.
> 
> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> ---
>  drivers/infiniband/core/umem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 1e62a5f..4609b92 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -134,6 +134,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
>  
>  	if (access & IB_ACCESS_ON_DEMAND) {
> +		put_pid(umem->pid);
>  		ret = ib_umem_odp_get(context, umem);
>  		if (ret) {
>  			kfree(umem);
> @@ -149,6 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  
>  	page_list = (struct page **) __get_free_page(GFP_KERNEL);
>  	if (!page_list) {
> +		put_pid(umem->pid);
>  		kfree(umem);
>  		return ERR_PTR(-ENOMEM);
>  	}
> 

Mark.
