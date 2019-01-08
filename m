From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v1 for-rc] RDMA/vmw_pvrdma: Return the correct opcode
 when creating WR
Date: Mon, 7 Jan 2019 20:10:51 -0700
Message-ID: <20190108031051.GC5336@ziepe.ca>
References: <1546903346-15461-1-git-send-email-aditr@vmware.com>
 <20190107232815.GP27929@mellanox.com>
 <ccacbd86-8d35-06a4-fe04-0144405d4638@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ccacbd86-8d35-06a4-fe04-0144405d4638@vmware.com>
Sender: stable-owner@vger.kernel.org
To: Adit Ranadive <aditr@vmware.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Pv-drivers <Pv-drivers@vmware.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 08, 2019 at 12:02:42AM +0000, Adit Ranadive wrote:
> On 1/7/19 3:28 PM, Jason Gunthorpe wrote:
> > On Mon, Jan 07, 2019 at 11:23:05PM +0000, Adit Ranadive wrote:
> >> From: Adit Ranadive <aditr@vmware.com>
> >>
> >> Since the IB_WR_REG_MR opcode value changed, let's set the PVRDMA
> >> device opcodes explicitly.
> >>
> >> Reported-by: Ruishuang Wang <ruishuangw@vmware.com>
> >> Fixes: 9a59739bd01f ("IB/rxe: Revise the ib_wr_opcode enum")
> >> Cc: stable@vger.kernel.org
> >> Reviewed-by: Bryan Tan <bryantan@vmware.com>
> >> Reviewed-by: Ruishuang Wang <ruishuangw@vmware.com>
> >> Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
> >> Signed-off-by: Adit Ranadive <aditr@vmware.com>
> >>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h | 43 +++++++++++++++++++++++++++++++
> >>  1 file changed, 43 insertions(+)
> >>
> >> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> >> index 42b8685c997e..a85d7ba96d55 100644
> >> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> >> @@ -427,6 +427,49 @@ static inline enum ib_qp_state pvrdma_qp_state_to_ib(enum pvrdma_qp_state state)
> >>  
> >>  static inline enum pvrdma_wr_opcode ib_wr_opcode_to_pvrdma(enum ib_wr_opcode op)
> >>  {
> >> +	switch (op) {
> >> +	case IB_WR_RDMA_WRITE:
> >> +		return PVRDMA_WR_RDMA_WRITE;
> >> +	case IB_WR_RDMA_WRITE_WITH_IMM:
> >> +		return PVRDMA_WR_RDMA_WRITE_WITH_IMM;
> >> +	case IB_WR_SEND:
> >> +		return PVRDMA_WR_SEND;
> >> +	case IB_WR_SEND_WITH_IMM:
> >> +		return PVRDMA_WR_SEND_WITH_IMM;
> >> +	case IB_WR_RDMA_READ:
> >> +		return PVRDMA_WR_RDMA_READ;
> >> +	case IB_WR_ATOMIC_CMP_AND_SWP:
> >> +		return PVRDMA_WR_ATOMIC_CMP_AND_SWP;
> >> +	case IB_WR_ATOMIC_FETCH_AND_ADD:
> >> +		return PVRDMA_WR_ATOMIC_FETCH_AND_ADD;
> >> +	case IB_WR_LSO:
> >> +		return PVRDMA_WR_LSO;
> >> +	case IB_WR_SEND_WITH_INV:
> >> +		return PVRDMA_WR_SEND_WITH_INV;
> >> +	case IB_WR_RDMA_READ_WITH_INV:
> >> +		return PVRDMA_WR_RDMA_READ_WITH_INV;
> >> +	case IB_WR_LOCAL_INV:
> >> +		return PVRDMA_WR_LOCAL_INV;
> >> +	case IB_WR_REG_MR:
> >> +		return PVRDMA_WR_FAST_REG_MR;
> >> +	case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
> >> +		return PVRDMA_WR_MASKED_ATOMIC_CMP_AND_SWP;
> >> +	case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
> >> +		return PVRDMA_WR_MASKED_ATOMIC_FETCH_AND_ADD;
> >> +	case IB_WR_REG_SIG_MR:
> >> +		return PVRDMA_WR_REG_SIG_MR;
> >> +	case IB_WR_RESERVED1:
> >> +	case IB_WR_RESERVED2:
> >> +	case IB_WR_RESERVED3:
> >> +	case IB_WR_RESERVED4:
> >> +	case IB_WR_RESERVED5:
> >> +	case IB_WR_RESERVED6:
> >> +	case IB_WR_RESERVED7:
> >> +	case IB_WR_RESERVED8:
> >> +	case IB_WR_RESERVED9:
> >> +	case IB_WR_RESERVED10:
> >> +		return (enum pvrdma_wr_opcode)op;
> >> +	}
> >>  	return (enum pvrdma_wr_opcode)op;
> > 
> > I ment it should always translate, not cast like this - if no
> > translation is available then it should be a posting failure.
> > 
> > Jason
> > 
> 
> Not sure if I follow you. We can post a failure but that would be 
> in pvrdma_qp.c when it looks at the opcode returned from here. We 
> would have to handle all the IB enums here though if you don't want 
> a default case (you would get compiler warnings otherwise).  

You'd do something like

default:
   return PVRDMA_WR_ERROR;

And something, somewhere, should fail the posting.

Jason
