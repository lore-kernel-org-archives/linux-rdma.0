From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problems using krping
Date: Sun, 24 Jan 2010 15:44:55 -0600
Message-ID: <4B5CBF57.40505@opengridcomputing.com>
References: <201001211807011710722@inspur.com>, <201001221533186875550@inspur.com> <201001242242553436345@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201001242242553436345-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

lihaidong wrote:
> Mr.Wise
> I'm actually rewritting your program in order to get familiar with 
> Verbs+CMA API. In order to make the procedure more clearly, I put 
> nearly all the stuff into two long functions, one for server, the 
> other for client, the cq/cma event handler are the only exception.
> I get the program run step by step.I use DMA mode firstly. As mlx4 
> driver don't support MR/MW mode, I turned to FMR.
> Before adding FMR codes, I want  make local_dma_lkey option work.ie. 
> mem_mode=dma,local_dma_lkey
> I run into a strange problem here.
> I changed the sgl's lkey into local_dma_lkey when preparing recv send 
> , rdma write wrs.
> The problem is : After server post RDMA Read wr, get completion, and 
> print the data read from client.These are all normal. But after post a 
> send wr to indicate client to go ahead, instead of receving a 
> IB_WC_SEND wc ,the cq event handler get an event whose status is not 
> 0, so it print something as follows:
> cq completion failed with wr_id 0 opcode 2 status 4 vendor_err 52<3>
>  
> the opcode is 2, so it is an event of RDMA read, isn't weird? Why it 
> comes again and in wrong status?
> the status 4 means IB_WC_LOC_PROT_ERR, is it a base/bounds violation? 
> How could this happen? The remote_len told by client is equal to cb->size.


Maybe the opcode is not valid for error CQEs with mlx4?  I seem to 
remember that was the case for mthca.  You could make the wr_id's in the 
WRs unique, then correlate the wr_id in the CQE to verify this.   
LOC_PROT_ERR usually means the MR doesn't have the appropriate access 
rights.


>  
>  
> ps: Why recv_sgl send_sgl uses dma_mr->lkey while rdma_sgl use 
> dma_mr->rkey?
>      Could recv_sgl uses dma_mr->rkey or rdma_sgl use dma_mr_lkey? Why?


For iWARP, the targer or sink of a read must have remote write.  So you 
must use the rkey if you want the code to run on both IB and iWARP...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
