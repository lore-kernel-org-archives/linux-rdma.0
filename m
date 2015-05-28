From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/14] IB/mad: Add support for OPA MAD processing.
Date: Thu, 28 May 2015 10:03:54 +0300
Message-ID: <5566BDDA.5010608@mellanox.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/20/2015 11:13 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> Ira Weiny (14):
>    IB/mad: Clean up ib_find_send_mad
>    IB/mad: Create an RMPP Base header
>    IB/mad: Create handle_ib_smi
>    IB/mad: Add helper function for smi_handle_dr_smp_send
>    IB/mad: Add helper function for smi_handle_dr_smp_recv
>    IB/mad: Add helper function for smi_check_forward_dr_smp
>    IB/mad: Add base version to ib_create_send_mad
>    IB/core: Add rdma_max_mad_size helper
>    IB/mad: Convert allocations from kmem_cache to kmalloc
>    IB/mad: Add MAD size parameters to process_mad
>    IB/core: Add rdma_cap_opa_mad helper
>    IB/mad: Add partial Intel OPA MAD support
>    IB/mad: Add partial Intel OPA MAD support
>    IB/mad: Add final OPA MAD processing

Ira,

so again... patch title can be much better that

"Add helper function name_of_function_x" isn't some
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
