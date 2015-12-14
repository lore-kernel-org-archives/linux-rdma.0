From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 0/2] staging/rdma/hfi1: set Gen 3 half-swing for integrated devices.
Date: Mon, 14 Dec 2015 14:54:09 -0500
Message-ID: <20151214195409.GC24498@phlsvsds.ph.intel.com>
References: <1448999277-22972-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448999277-22972-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Any further feedback on this series?

Ira

On Tue, Dec 01, 2015 at 02:47:55PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This was a single patch before.  The change to dev_dbg required a precursor
> patch to add the dd_dev_dbg which is consistent with the other dev_* macros
> which automatically use struct hfi1_devdata.
> 
> Dean Luick (1):
>   staging/rdma/hfi1: set Gen3 half-swing for integrated devices
> 
> Ira Weiny (1):
>   staging/rdma/hf1: add dd_dev_dbg
> 
>  drivers/staging/rdma/hfi1/chip_registers.h | 11 ++++
>  drivers/staging/rdma/hfi1/hfi.h            |  4 ++
>  drivers/staging/rdma/hfi1/pcie.c           | 82 ++++++++++++++++++++++++++++--
>  3 files changed, 93 insertions(+), 4 deletions(-)
> 
> -- 
> 1.8.2
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
