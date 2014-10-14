From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] IB/core: Introduce Fast Indirect Memory Registration
 verbs API
Date: Tue, 14 Oct 2014 07:40:59 +0200
Message-ID: <543CB76B.7020208@acm.org>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <1412693281-6161-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412693281-6161-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/07/14 16:48, Sagi Grimberg wrote:
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

Hello Sagi,

Is there documentation available somewhere about the order in which an 
HCA must execute an indirect memory registration request relative to 
other work requests, similar to the "Work Request Operation Ordering" 
table in the InfiniBand specification ? I think such documentation is 
needed to ensure consistent behavior across HCA models.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
