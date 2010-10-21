From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address resolution
Date: Thu, 21 Oct 2010 14:14:11 -0700
Message-ID: <adad3r38d0c.fsf@cisco.com>
References: <20100826141851.GI8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826141851.GI8795@mtldesk30> (Eli Cohen's message of "Thu,
	26 Aug 2010 17:18:51 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 >  enum {
 >  	/*
 >  	 * Largest possible UD header: send with GRH and immediate data.
 > +	 * 4 bytes added to accommodate for eth header instead of lrh
 >  	 */
 > -	MLX4_IB_UD_HEADER_SIZE		= 72,
 > +	MLX4_IB_UD_HEADER_SIZE		= 76,

I don't understand this change either.  As far as I can tell, a 14-byte
Ethernet header is 6 bytes longer than an 8-byte LRH, and with .1q the
18-byte header will require 10 bytes more than the LRH.  So shouldn't
this value be 78 in this patch and updated to 82 in the VLAN patch?

(It probably works in practice because the allocation of sqp structs
gets rounded up enough)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
