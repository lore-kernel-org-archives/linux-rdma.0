From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv2] mlx4: remove limitation on LSO header size
Date: Mon, 12 Oct 2009 22:41:10 +0200
Message-ID: <20091012204110.GA15536@mtls03>
References: <20091011132013.GA24725@mtls03> <adaeip8h7cd.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaeip8h7cd.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2009 at 10:04:18AM -0700, Roland Dreier wrote:
> 
>  > @@ -1523,6 +1521,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  >  	__be32 *lso_wqe;
>  >  	__be32 uninitialized_var(lso_hdr_sz);
>  >  	int i;
>  > +	__be32 blh = 0;
> 
> So isn't this a bug if multiple work requests are passed in?  Shouldn't
> the blh initialization be inside the loop over work requests?

Yes, it's a bug. blh should be set to 0 at the start of the for loop.
I'll send another patch with a fix.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
