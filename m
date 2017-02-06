From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Mon, 6 Feb 2017 12:26:42 -0700
Message-ID: <20170206192642.GA22482@obsidianresearch.com>
References: <148640852878.13713.11121939459524566022.stgit@tstruk-mobl1.ra.intel.com>
 <148640853387.13713.5705865367460168894.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <148640853387.13713.5705865367460168894.stgit-mEAvsCHCuLl9qtVHHdszJa2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 06, 2017 at 11:15:33AM -0800, Tadeusz Struk wrote:
> Some hardware has multiple HFIs within the same ASIC, each one on a
> sepatate bus number. In some devices the numbers labeled on the
> faceplate of the device don't match the PCI bus order, and the result
> is that the devices (ports) are probed in the opposite order of their
> port numbers. The result is IB device unit numbers are in reverse order
> from the faceplate numbering. This leads to confusion, and errors.
> Use EPROBE_DEFER error code to enforce correct port order.
> 
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  drivers/infiniband/hw/hfi1/chip.c |   95 ++++++++++++++++++++++++++++++++++++-
>  drivers/infiniband/hw/hfi1/chip.h |    2 -
>  drivers/infiniband/hw/hfi1/init.c |    1 
>  3 files changed, 94 insertions(+), 4 deletions(-)

Still no on this from me, this is a horrible abuse of the device core.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
