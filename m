From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 03/12] ib_core: IBoE UD packet packing support
Date: Thu, 14 Oct 2010 23:57:58 +0200
Message-ID: <20101014215758.GA15089@mtldesk30>
References: <20100826141756.GD8795@mtldesk30>
 <adazkugildn.fsf@cisco.com>
 <20101014212658.GC13969@mtldesk30>
 <adapqvcih6l.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adapqvcih6l.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 14, 2010 at 02:43:30PM -0700, Roland Dreier wrote:
> 
> void ib_ud_header_init(int     		    payload_bytes,
> 		       int		    lrh_present,
> 		       int		    eth_present,
> 		       int    		    grh_present,
> 		       int		    immediate_present,
> 		       struct ib_ud_header *header)
> {
> 	memset(header, 0, sizeof *header);
> 
> 	if (lrh_present) {
> 		u16 packet_length;
> 
> 		header->lrh.link_version     = 0;
> 		header->lrh.link_next_header =
> 			grh_present ? IB_LNH_IBA_GLOBAL : IB_LNH_IBA_LOCAL;
> 		packet_length = (IB_LRH_BYTES	+
> 				 IB_BTH_BYTES	+
> 				 IB_DETH_BYTES	+
> 				 grh_present ? IB_GRH_BYTES : 0 +
> 				 payload_bytes	+
> 				 4		+ /* ICRC     */
> 				 3) / 4;	  /* round up */
> 		header->lrh.packet_length = cpu_to_be16(packet_length);
> 	}
> 
> 	if (grh_present) {
> 		header->grh.ip_version      = 6;
> 		header->grh.payload_length  =
> 			cpu_to_be16((IB_BTH_BYTES     +
> 				     IB_DETH_BYTES    +
> 				     payload_bytes    +
> 				     4                + /* ICRC     */
> 				     3) & ~3);          /* round up */
> 		header->grh.next_header     = 0x1b;
> 	}
> 
> 	if (header->immediate_present)
> 		header->bth.opcode           = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
> 	else
> 		header->bth.opcode           = IB_OPCODE_UD_SEND_ONLY;
> 	header->bth.pad_count                = (4 - payload_bytes) & 3;
> 	header->bth.transport_header_version = 0;
> 
> 	header->lrh_present = lrh_present;
> 	header->eth_present = eth_present;
> 	header->grh_present = grh_present;
> 	header->immediate_present = immediate_present;
> }
> 
> which I think is reasonably clean for now.

Looks good.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
