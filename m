From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/5] IB/core: Introduce Fast Indirect Memory
 Registration verbs API
Date: Mon, 8 Jun 2015 20:49:20 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE5C7C@ORSMSX109.amr.corp.intel.com>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <1433769339-949-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433769339-949-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In order to support that we provide the user with an interface
> to pass a scattered list of buffers to the IB core layer called
> ib_indir_reg_list and provide a new send work request opcode
> called IB_WR_REG_INDIR_MR. We extend wr union with a new type of
> memory registration called indir_reg where the user can place the
> relevant information to perform such a memory registration.
> 
> The verbs user is expected to perform these steps:
> 0. Make sure that the device supports Indirect memory registration via
>    ib_device_cap_flag IB_DEVICE_INDIR_REGISTRATION and make sure
>    that ib_device_attr max_indir_reg_mr_list_len suffice for the
>    expected scatterlist length
> 
> 1. Allocate a memory region with IB_MR_INDIRECT_REG creation flag
>    This is done via ib_create_mr() with:
>    mr_init_attr.flags = IB_MR_INDIRECT_REG
> 
> 2. Allocate an ib_indir_reg_list structure to hold the scattered buffers
>    pointers. This is done via new ib_alloc_indir_reg_list() verb
> 
> 3. Fill the scattered buffers in ib_indir_reg_list.sg_list
> 
> 4. Post a work request with a new opcode IB_WR_REG_INDIR_MR and
>    provide the filled ib_indir_reg_list
> 
> 5. Perform data transfer
> 
> 6. Get completion of kind IB_WC_REG_INDIR_MR (if requested)
> 
> 7. Free indirect MR and ib_indir_reg_list via
>    ib_dereg_mr() and ib_free_indir_reg_list()

IMO, we need to introduce vendor specific header files and interfaces.  It is unmaintainable to drive an API from the bottom up and expose the 'bare metal' implementation of a bunch of disjoint pieces of hardware.  (Yeah, because we need yet another way of registering memory... just reading the process for a yet another set of hoops that an app must jump through in order to register memory makes my head hurt.)  Everything about this continual approach needs to end.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
