From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 7/8] IB/core: Advertise supported vector
 CALC capabilities
Date: Tue, 23 Feb 2016 11:44:00 -0700
Message-ID: <20160223184400.GA27769@obsidianresearch.com>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
 <1456215928-9305-8-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456215928-9305-8-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 23, 2016 at 10:25:27AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This vector CALC feature allows different offloaded arithmetic
> calculations of several vectors of equal length.
> 
> In order to properly use this feature, the user space applications
> need to know the supported properties, like operations, size and
> maximal number of vectors.
> 
> The properties exposed are:
> * calc_matrix - If set, vector CALC matrix is supported.
> * max_vector_count - Maximum number of vectors supported.
> * max_chunk_size - Maximum chunk size supported.

This kind of stuff should be in a kdoc not lost in a commit message.

> * op_cap - Bit mask indicates which vector CALC operations are supported:
> 	Bit 1: ADD operation
> 	Bit 2: MAX operation
> 	Bit 3: AND operation
> 	Bit 4: OR operation
> 	Bit 5: XOR operation
> 	Bit 6: MIN operation
> 	Bit 7: SWAP_ENDIANNESS operation

This should be constants in the uAPI header.

A commit message is not documentation.

Can you defend why this proprietary extension is being shoved into the
common uapi and not dumped in the vendor area? Is an IBTA
standardization forthcoming? Have you collaborated with other vendors
to agree on this API?

I really agree with Christoph Hellwig, this continuous churn on the
common api for non-standard features is really bad. We need to have a
higher bar for acceptance, which is something stronger than one vendor
implementing something in their hardware.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
