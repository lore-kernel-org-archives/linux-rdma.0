From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address resolution
Date: Thu, 21 Oct 2010 21:15:35 -0700
Message-ID: <adazku6yiag.fsf@cisco.com>
References: <20100826141851.GI8795@mtldesk30> <adad3r38d0c.fsf@cisco.com>
	<ada8w1r8cxo.fsf@cisco.com> <20101021230307.GD6367@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101021230307.GD6367@mtldesk30> (Eli Cohen's message of "Fri,
	22 Oct 2010 01:03:07 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I don't get this. For IB, we have 72 without immediate - did you
 > forget to add the ICRC? I think we count it with the header...

We don't need ICRC in the header_buf, do we?  We're talking about
MLX4_IB_UD_HEADER_SIZE, which is used to hold the packet header we get
from ib_ud_header_pack().  The ICRC is accounted for in a different
segment of the WQE.

In any case, it shouldn't matter -- I don't see how it could be correct
to increase the buffer size by 4 bytes to account for the change from
LRH to Ethernet header; an LRH is 8 bytes and an Ethernet header
(without .1q etc) is 14 bytes.  So we should add 6 bytes, right?

The math I get is

IB:   LRH + GRH + BTH + DETH + IMM
       8    40    12     8      4   = 72

Eth:  MAC + GRH + BTH + DETH + IMM
      14    40    12     8      4   = 78

I don't see how your change

 > -	MLX4_IB_UD_HEADER_SIZE		= 72,
 > +	MLX4_IB_UD_HEADER_SIZE		= 76,

could possibly be correct, although as I said it probably works because
of padding and not hitting the worst case in practice anyway.

 - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
