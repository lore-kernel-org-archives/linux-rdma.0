From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] IB/core: Add support for enhanced atomic operations
Date: Wed, 10 Feb 2010 16:51:56 -0800
Message-ID: <96930957548D41E0B47FA465CAAD05E6@amr.corp.intel.com>
References: <20100201155959.GA17341@vlad-laptop>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100201155959.GA17341@vlad-laptop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> enum ib_atomic_cap {
>@@ -472,7 +473,9 @@ enum ib_wc_opcode {
>  * receive by testing (opcode & IB_WC_RECV).
>  */
> 	IB_WC_RECV			= 1 << 7,
>-	IB_WC_RECV_RDMA_WITH_IMM
>+	IB_WC_RECV_RDMA_WITH_IMM,
>+	IB_WC_MASKED_COMP_SWAP,
>+	IB_WC_MASKED_FETCH_ADD
> };

This breaks the ability to check for a receive by testing opcode & IB_WC_RECV.
Is it even necessary to define new work completion opcodes?

> enum ib_wc_flags {
>@@ -689,6 +692,8 @@ enum ib_wr_opcode {
> 	IB_WR_RDMA_READ_WITH_INV,
> 	IB_WR_LOCAL_INV,
> 	IB_WR_FAST_REG_MR,
>+	IB_WR_ATOMIC_MASKED_CMP_AND_SWP,
>+	IB_WR_ATOMIC_MASKED_FETCH_AND_ADD,
> };

Just tossing this out as a possibility -- the mask itself could be used to
indicate the type of operation.  Kernel clients would always set the mask for
all atomic operations.

Also, is there a kernel user for this functionality?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
