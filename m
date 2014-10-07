From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] IB/core: Introduce Fast Indirect Memory Registration
 verbs API
Date: Tue, 07 Oct 2014 13:12:28 -0500
Message-ID: <54342D0C.6050103@opengridcomputing.com>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <1412693281-6161-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412693281-6161-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bvanassche-HInyCGIudOg@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/7/2014 9:48 AM, Sagi Grimberg wrote:
> In order to support that we provide the user with an interface
> to pass a scattered list of buffers to the IB core layer called
> ib_indir_reg_list and provide the a new send work request opcode
> called IB_WR_REG_INDIR_MR. We extend wr union with a new type of
> memory registration called indir_reg where the user can place the
> relevant information to perform such a memory registration.
>
> The verbs user is expected to perform these steps:
> 0. Make sure that the device supports Indirect memory registration via
>     ib_device_cap_flag IB_DEVICE_INDIR_REGISTRATION and make sure
>     that ib_device_attr max_indir_reg_mr_list_len suffice for the
>     expected scatterlist length
>
> 1. Allocate a memory region with IB_MR_INDIRECT_REG creation flag
>     This is done via ib_create_mr() with mr_init_attr.flags = IB_MR_INDIRECT_REG
>
> 2. Allocate an ib_indir_reg_list structure to hold the scattered buffers
>     pointers. This is done via new ib_alloc_indir_reg_list() verb
>
> 3. Populate the scattered buffers in ib_indir_reg_list.sg_list
>
> 4. Post a work request with a new opcode IB_WR_REG_INDIR_MR and
>     provide the populated ib_indir_reg_list
>
> 5. Perform data transfer
>
> 6. Get completion of kind IB_WC_REG_INDIR_MR (if requested)
>
> 7. Free indirect MR and ib_indir_reg_list via
>     ib_destroy_mr() and ib_free_indir_reg_list()
>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/verbs.c |   29 ++++++++++++++++++++
>   include/rdma/ib_verbs.h         |   55 +++++++++++++++++++++++++++++++++++++-
>   2 files changed, 82 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index c2b89cc..0364551 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1445,3 +1445,32 @@ int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
>   		mr->device->check_mr_status(mr, check_mask, mr_status) : -ENOSYS;
>   }
>   EXPORT_SYMBOL(ib_check_mr_status);
> +
> +struct ib_indir_reg_list *
> +ib_alloc_indir_reg_list(struct ib_device *device,
> +			unsigned int max_indir_list_len)
> +{
> +	struct ib_indir_reg_list *indir_list;
> +
> +	if (!device->alloc_indir_reg_list)
> +		return ERR_PTR(-ENOSYS);
> +
> +	indir_list = device->alloc_indir_reg_list(device,
> +						  max_indir_list_len);
> +	if (!IS_ERR(indir_list)) {
> +		indir_list->device = device;
> +		indir_list->max_indir_list_len = max_indir_list_len;
> +	}
> +
> +	return indir_list;
> +}
> +EXPORT_SYMBOL(ib_alloc_indir_reg_list);
> +
> +void
> +ib_free_indir_reg_list(struct ib_device *device,
> +		       struct ib_indir_reg_list *indir_list)
> +{
> +	if (device->free_indir_reg_list)
> +		device->free_indir_reg_list(device, indir_list);
> +}
> +EXPORT_SYMBOL(ib_free_indir_reg_list);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 470a011..f5fe53c 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -123,7 +123,8 @@ enum ib_device_cap_flags {
>   	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
>   	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
>   	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
> -	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30)
> +	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
> +	IB_DEVICE_INDIR_REGISTRATION	= (1<<31)
>   };
>   
>   enum ib_signature_prot_cap {
> @@ -182,6 +183,7 @@ struct ib_device_attr {
>   	int			max_srq_wr;
>   	int			max_srq_sge;
>   	unsigned int		max_fast_reg_page_list_len;
> +	unsigned int		max_indir_reg_mr_list_len;
>   	u16			max_pkeys;
>   	u8			local_ca_ack_delay;
>   	int			sig_prot_cap;
> @@ -476,7 +478,8 @@ __attribute_const__ int ib_rate_to_mult(enum ib_rate rate);
>   __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate);
>   
>   enum ib_mr_create_flags {
> -	IB_MR_SIGNATURE_EN = 1,
> +	IB_MR_SIGNATURE_EN = 1 << 0,
> +	IB_MR_INDIRECT_REG = 1 << 1
>   };
>   
>   /**
> @@ -651,6 +654,7 @@ enum ib_wc_opcode {
>   	IB_WC_FAST_REG_MR,
>   	IB_WC_MASKED_COMP_SWAP,
>   	IB_WC_MASKED_FETCH_ADD,
> +	IB_WC_REG_INDIR_MR,
>   /*
>    * Set value of IB_WC_RECV so consumers can test if a completion is a
>    * receive by testing (opcode & IB_WC_RECV).
> @@ -945,6 +949,7 @@ enum ib_wr_opcode {
>   	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
>   	IB_WR_BIND_MW,
>   	IB_WR_REG_SIG_MR,
> +	IB_WR_REG_INDIR_MR,
>   	/* reserve values for low level drivers' internal use.
>   	 * These values will not be used at all in the ib core layer.
>   	 */
> @@ -984,6 +989,12 @@ struct ib_fast_reg_page_list {
>   	unsigned int		max_page_list_len;
>   };
>   
> +struct ib_indir_reg_list {
> +	struct ib_device       *device;
> +	struct ib_sge          *sg_list;
> +	unsigned int		max_indir_list_len;
> +};
> +
>   /**
>    * struct ib_mw_bind_info - Parameters for a memory window bind operation.
>    * @mr: A memory region to bind the memory window to.
> @@ -1056,6 +1067,14 @@ struct ib_send_wr {
>   			int			access_flags;
>   			struct ib_sge	       *prot;
>   		} sig_handover;
> +		struct {
> +			u64				iova_start;
> +			struct ib_indir_reg_list       *indir_list;
> +			unsigned int			indir_list_len;
> +			u64				length;
> +			unsigned int			access_flags;
> +			u32				mkey;
> +		} indir_reg;

What is mkey?  Shouldn't this be an rkey?

>   	} wr;
>   	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */
>   };
> @@ -1562,6 +1581,10 @@ struct ib_device {
>   	struct ib_fast_reg_page_list * (*alloc_fast_reg_page_list)(struct ib_device *device,
>   								   int page_list_len);
>   	void			   (*free_fast_reg_page_list)(struct ib_fast_reg_page_list *page_list);
> +	struct ib_indir_reg_list * (*alloc_indir_reg_list)(struct ib_device *device,
> +							   unsigned int indir_list_len);
> +	void			   (*free_indir_reg_list)(struct ib_device *device,
> +							  struct ib_indir_reg_list *indir_list);
>   	int                        (*rereg_phys_mr)(struct ib_mr *mr,
>   						    int mr_rereg_mask,
>   						    struct ib_pd *pd,
> @@ -2460,6 +2483,34 @@ struct ib_fast_reg_page_list *ib_alloc_fast_reg_page_list(
>   void ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
>   
>   /**
> + * ib_alloc_indir_reg_list() - Allocates an indirect list array
> + * @device: ib device pointer
> + * @indir_list_len: size of the list array to be allocated
> + *
> + * Allocate a struct ib_indir_reg_list and a sg_list array
> + * that is at least indir_list_len in size. The actual size is
> + * returned in max_indir_list_len. The caller is responsible for
> + * initializing the contents of the sg_list array before posting
> + * a send work request with the IB_WC_INDIR_REG_MR opcode.
> + *
> + * The sg_list array entries should be set exactly the same way
> + * the ib_send_wr sg_list {lkey, addr, length}.
> + */
> +struct ib_indir_reg_list *
> +ib_alloc_indir_reg_list(struct ib_device *device,
> +			unsigned int indir_list_len);
> +
> +/**
> + * ib_free_indir_reg_list() - Deallocates a previously allocated
> + *     indirect list array
> + * @device: ib device pointer
> + * @indir_list: pointer to be deallocated
> + */
> +void
> +ib_free_indir_reg_list(struct ib_device *device,
> +		       struct ib_indir_reg_list *indir_list);
> +
> +/**
>    * ib_update_fast_reg_key - updates the key portion of the fast_reg MR
>    *   R_Key and L_Key.
>    * @mr - struct ib_mr pointer to be updated.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
