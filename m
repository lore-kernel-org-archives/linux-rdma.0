From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2] mlx4: remove limitation on LSO header size
Date: Mon, 12 Oct 2009 10:04:18 -0700
Message-ID: <adaeip8h7cd.fsf@cisco.com>
References: <20091011132013.GA24725@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091011132013.GA24725@mtls03> (Eli Cohen's message of "Sun, 11
	Oct 2009 15:20:13 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > @@ -1523,6 +1521,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 >  	__be32 *lso_wqe;
 >  	__be32 uninitialized_var(lso_hdr_sz);
 >  	int i;
 > +	__be32 blh = 0;

So isn't this a bug if multiple work requests are passed in?  Shouldn't
the blh initialization be inside the loop over work requests?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
