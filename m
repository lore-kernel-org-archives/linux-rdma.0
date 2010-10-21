From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address resolution
Date: Wed, 20 Oct 2010 22:22:56 -0700
Message-ID: <adazku85dcf.fsf@cisco.com>
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

Just curious -- what's up with this change here?  Is this connected to
IBoE support, or is this an independent fix?

 > diff --git a/drivers/net/mlx4/en_port.c b/drivers/net/mlx4/en_port.c
 > index a29abe8..a249887 100644
 > --- a/drivers/net/mlx4/en_port.c
 > +++ b/drivers/net/mlx4/en_port.c
 > @@ -127,8 +127,8 @@ int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
 >  	memset(context, 0, sizeof *context);
 >  
 >  	context->base_qpn = cpu_to_be32(base_qpn);
 > -	context->promisc = cpu_to_be32(promisc << SET_PORT_PROMISC_SHIFT | base_qpn);
 > -	context->mcast = cpu_to_be32(1 << SET_PORT_PROMISC_SHIFT | base_qpn);
 > +	context->promisc = cpu_to_be32(promisc << SET_PORT_PROMISC_EN_SHIFT | base_qpn);
 > +	context->mcast = cpu_to_be32(1 << SET_PORT_PROMISC_MODE_SHIFT | base_qpn);
 >  	context->intra_no_vlan = 0;
 >  	context->no_vlan = MLX4_NO_VLAN_IDX;
 >  	context->intra_vlan_miss = 0;
 > diff --git a/drivers/net/mlx4/en_port.h b/drivers/net/mlx4/en_port.h
 > index e6477f1..9354891 100644
 > --- a/drivers/net/mlx4/en_port.h
 > +++ b/drivers/net/mlx4/en_port.h
 > @@ -36,7 +36,8 @@
 >  
 >  
 >  #define SET_PORT_GEN_ALL_VALID	0x7
 > -#define SET_PORT_PROMISC_SHIFT	31
 > +#define SET_PORT_PROMISC_EN_SHIFT	31
 > +#define SET_PORT_PROMISC_MODE_SHIFT	30
 >  
 >  enum {
 >  	MLX4_CMD_SET_VLAN_FLTR  = 0x47,

Also as far as I can tell this variable sgid is write-only (ie you do
the ib_get_cached_gid() but then never do anything with the value that
that returns).  Am I missing something subtle?

 > @@ -1226,43 +1281,59 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 >  	int header_size;
 >  	int spc;
 >  	int i;
 > +	union ib_gid sgid;
 > +	int is_eth;
 > +	int is_grh;
 > +	int err;
 >  
 >  	send_size = 0;
 >  	for (i = 0; i < wr->num_sge; ++i)
 >  		send_size += wr->sg_list[i].length;
 >  
 > -	ib_ud_header_init(send_size, 1, 0, mlx4_ib_ah_grh_present(ah), 0, &sqp->ud_header);
 > +	is_eth = rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
 > +	is_grh = mlx4_ib_ah_grh_present(ah);
 > +	err = ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
 > +				ah->av.ib.gid_index, &sgid);
 > 

Finally this patch would have been easier to review without extraneous
whitespace noise like

 > @@ -1337,7 +1419,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 >  	}
 >  
 >  	*mlx_seg_len =
 > -		ALIGN(i * sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
 > +	ALIGN(i * sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
 >  	return 0;
 >  }

 > @@ -100,3 +194,4 @@ int mlx4_ib_destroy_ah(struct ib_ah *ah)
 >  	kfree(to_mah(ah));
 >  	return 0;
 >  }
 > +

etc.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
