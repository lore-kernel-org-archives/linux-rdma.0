From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 for-rc] RDMA/vmw_pvrdma: Return the correct opcode
 when creating WR
Date: Thu, 10 Jan 2019 17:04:41 -0700
Message-ID: <20190111000441.GA3653@ziepe.ca>
References: <1547075310-8751-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547075310-8751-1-git-send-email-aditr@vmware.com>
Sender: stable-owner@vger.kernel.org
To: Adit Ranadive <aditr@vmware.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Pv-drivers <Pv-drivers@vmware.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 09, 2019 at 11:08:49PM +0000, Adit Ranadive wrote:
> From: Adit Ranadive <aditr@vmware.com>
> 
> Since the IB_WR_REG_MR opcode value changed, let's set the PVRDMA
> device opcodes explicitly.
> 
> Reported-by: Ruishuang Wang <ruishuangw@vmware.com>
> Fixes: 9a59739bd01f ("IB/rxe: Revise the ib_wr_opcode enum")
> Cc: stable@vger.kernel.org
> Reviewed-by: Bryan Tan <bryantan@vmware.com>
> Reviewed-by: Ruishuang Wang <ruishuangw@vmware.com>
> Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
> Signed-off-by: Adit Ranadive <aditr@vmware.com>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    | 35 +++++++++++++++++++++++++++-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c |  6 +++++
>  include/uapi/rdma/vmw_pvrdma-abi.h           |  1 +
>  3 files changed, 41 insertions(+), 1 deletion(-)

Applied to for-rc, thanks

Jason
