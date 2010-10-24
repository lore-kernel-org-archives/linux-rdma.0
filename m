From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 12/12] mlx4: Add vlan support to IBoE
Date: Sun, 24 Oct 2010 09:10:50 +0200
Message-ID: <20101024071050.GF6367@mtldesk30>
References: <20100826141922.GM8795@mtldesk30>
 <ada7hh9x6mg.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada7hh9x6mg.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 22, 2010 at 02:25:11PM -0700, Roland Dreier wrote:
>  > @@ -1801,6 +1831,11 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  >  		ctrl->owner_opcode = mlx4_ib_opcode[wr->opcode] |
>  >  			(ind & qp->sq.wqe_cnt ? cpu_to_be32(1 << 31) : 0) | blh;
>  >  
>  > +		if (vlan < 0x1000) {
>  > +			ctrl->ins_vlan = 1 << 6;
>  > +			ctrl->vlan_tag = vlan;
>  > +		}
> 
> Looks like a bug here -- vlan is __be16 and holds the vlan tag in
> network order.  So this should be a test of be16_to_cpu(vlan) < 0x1000, right?
> 

Sure, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
