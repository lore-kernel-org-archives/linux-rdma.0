From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/5] IB/hfi1: Adjust another size determination in
 hfi1_user_sdma_alloc_queues()
Date: Mon, 13 Feb 2017 10:10:37 +0100
Message-ID: <fc714096-8534-2231-17fd-8e3ca3f7a87b@suse.de>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
 <0fdf4d81-58d7-c6fc-b37f-41d47675dd83@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0fdf4d81-58d7-c6fc-b37f-41d47675dd83@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 02/10/2017 10:03 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 10 Feb 2017 08:50:45 +0100
> 
> * Pass a product for a call of the function "vmalloc_user" without storing
>   it in an intermediate variable.
> 
> * Delete the local variable "memsize" which became unnecessary with
>   this refactoring.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/hfi1/user_sdma.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
> index 15194554a92b..991e7f3d8e18 100644
> --- a/drivers/infiniband/hw/hfi1/user_sdma.c
> +++ b/drivers/infiniband/hw/hfi1/user_sdma.c
> @@ -375,7 +375,6 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
>  {
>  	struct hfi1_filedata *fd;
>  	int ret = 0;
> -	unsigned memsize;
>  	char buf[64];
>  	struct hfi1_devdata *dd;
>  	struct hfi1_user_sdma_comp_q *cq;
> @@ -443,8 +442,8 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
>  	if (!cq)
>  		goto cq_nomem;
>  
> -	memsize = PAGE_ALIGN(sizeof(*cq->comps) * hfi1_sdma_comp_ring_size);
> -	cq->comps = vmalloc_user(memsize);
> +	cq->comps = vmalloc_user(PAGE_ALIGN(sizeof(*cq->comps)
> +				 * hfi1_sdma_comp_ring_size));
>  	if (!cq->comps)
>  		goto cq_comps_nomem;
>  
> 

IMHO this makes readability worse. What's the intention behind this
patch? Is there any difference in binary size or something in the likes?
I doubt so as the compiler should take care of this anyways.

I'm just a casual reader of the RDMA list not an active reviewer, but if
you did this in e.g. SCSI I'd NACK it. Code has to be readable for
humans and that means the less that's done in one line of code the
better. Let the compiler do the optimizations and get rid of local
variables.

Just my 2c.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
