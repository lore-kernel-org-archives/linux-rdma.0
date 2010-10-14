From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 03/12] ib_core: IBoE UD packet packing support
Date: Thu, 14 Oct 2010 23:26:58 +0200
Message-ID: <20101014212658.GC13969@mtldesk30>
References: <20100826141756.GD8795@mtldesk30>
 <adazkugildn.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adazkugildn.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 14, 2010 at 01:12:52PM -0700, Roland Dreier wrote:
>  > +	if (lrh_present) {
>  > +		header->lrh.link_version     = 0;
>  > +		header->lrh.link_next_header =
>  > +			grh_present ? IB_LNH_IBA_GLOBAL : IB_LNH_IBA_LOCAL;
>  > +		packet_length = IB_LRH_BYTES;
>  > +	}
>  > +
>  > +	if (eth_present)
>  > +		packet_length += IB_ETH_BYTES;
> 
> How does this code in ib_ud_header_init() work if lrh_present == 0 and
> eth_present == 1?  It seems packet_length is never initialized in that
> case, or am I missing something?
It's a bug but harmless. packet_length is not used in the case of
Ethernet link layer so the fact that it is not initialized doesn't
cause any harm. Im the case of IB link layer it is initialized.
> 
> Anyway I changed the patch in my tree to do
> 
> 	packet_length = IB_ETH_BYTES
> 
> if eth_present is set.
> 
Maybe just we should just remove any calculations on packet_length for
the Ethernet case and simplify the function farther.

> I'm assuming lrh_present and eth_present are exclusive; in fact it might
> be a better interface to ib_ud_header_init() if we passed in a link
> layer type instead of requiring the caller to do it... that would save
> from everyone having to do
> 
> +	ib_ud_header_init(send_size, !is_eth, is_eth, is_grh, 0, &sqp->ud_header);
> 
> as ends up later in the patch series.
> 
> This could be a future cleanup if we care.
> 
Yes, they are mutual exclusive - I agree we can pass in a link layer
parameter instead.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
