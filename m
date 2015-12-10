From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 26/37] IB/rdmavt: Move memory registration into rdmavt
Date: Thu, 10 Dec 2015 10:14:56 -0500
Message-ID: <20151210151455.GD11526@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <20151207204451.8144.52356.stgit@phlsvslse11.ph.intel.com> <56698B2C.2010806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56698B2C.2010806-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 04:24:44PM +0200, Sagi Grimberg wrote:
>
>
>>   /**
>>@@ -83,7 +357,31 @@ struct ib_mr *rvt_reg_phys_mr(struct ib_pd *pd,
>>   			      int num_phys_buf, int acc, u64 *iova_start)
>>   {
>
>Why do we even bother with reg_phys_mr? Let's drop it entirely.

Why? Because, it exists in qib and hfi1.

However, it seems no one is actually using this in the kernel these days and 
the core support was removed in commit 1241d7bf. Yet the function pointer 
still exists in struct ib_device. Are there plans to remove this?

For this patch series I'll go ahead and remove rvt_reg_phys_mr.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
