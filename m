From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 14/14] IB/mlx5: Remove old field for create mkey
 mailbox
Date: Wed, 15 Jan 2014 09:38:41 +0200
Message-ID: <20140115073841.GC31664@mtldesk30>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
 <1389714323-20130-15-git-send-email-eli@mellanox.com>
 <1389717437.1585.68.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389717437.1585.68.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 14, 2014 at 05:37:17PM +0100, Yann Droneaud wrote:
> 
> Is it subject to change between various firmware revision ?
> 
> If yes, it could of user interest to specify the base/current
> version of the applicable firmware.

The sizes never changed and this field was never used so I just
redefined it as reserved.
> 
> > @@ -849,8 +849,8 @@ struct mlx5_create_mkey_mbox_in {
> >  	struct mlx5_mkey_seg	seg;
> >  	u8			rsvd1[16];
> >  	__be32			xlat_oct_act_size;
> > -	__be32			bsf_coto_act_size;
> > -	u8			rsvd2[168];
> > +	__be32			rsvd2;
> 
> For a reserved field, I think we don't care of it being be or le.
> 
Right, so be is just as good as le. The "be" is a sort of reminder
that driver/firmware interface is always big endian.

> > +	u8			rsvd3[168];
> >  	__be64			pas[0];
> >  };
> > 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
