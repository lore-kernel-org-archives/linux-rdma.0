From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 17/20] IB/hfi1: Add transmit fault injection feature
Date: Wed, 05 Apr 2017 14:34:15 -0400
Message-ID: <1491417255.2923.5.camel@redhat.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
         <20170321002619.28538.31428.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321002619.28538.31428.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-03-20 at 17:26 -0700, Dennis Dalessandro wrote:
> 
>  #ifdef CONFIG_FAULT_INJECTION
> +	debugfs_create_bool("fault_suppress_err", 0600,
> +			    ibd->hfi1_ibdev_dbg,
> +			    &ibd->fault_suppress_err);
>  	fault_init_debugfs(ibd);
>  #endif

...

> +static u64 hfi1_fault_tx(struct rvt_qp *qp, u8 opcode, u64 pbc)
> +{
> +#ifdef CONFIG_HFI1_FAULT_INJECTION
                 ^Looks like you failed to fix this spot up

> +	if ((opcode & IB_OPCODE_MSP) == IB_OPCODE_MSP)
> +		/*
> +		 * In order to drop non-IB traffic we
> +		 * set PbcInsertHrc to NONE (0x2).
> +		 * The packet will still be delivered
> +		 * to the receiving node but a
> +		 * KHdrHCRCErr (KDETH packet with a bad
> +		 * HCRC) will be triggered and the
> +		 * packet will not be delivered to the
> +		 * correct context.
> +		 */
> +		pbc |= (u64)PBC_IHCRC_NONE << PBC_INSERT_HCRC_SHIFT;
> +	else
> +		/*
> +		 * In order to drop regular verbs
> +		 * traffic we set the PbcTestEbp
> +		 * flag. The packet will still be
> +		 * delivered to the receiving node but
> +		 * a 'late ebp error' will be
> +		 * triggered and will be dropped.
> +		 */
> +		pbc |= PBC_TEST_EBP;
> +#endif
> +	return pbc;
> +}
> +

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
