From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/8] verbs: Annoate ibv_wc helpers with endian
Date: Thu, 13 Jul 2017 11:48:31 -0600
Message-ID: <20170713174831.GC11069@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170713065057.GH1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713065057.GH1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 09:50:57AM +0300, Leon Romanovsky wrote:
 
> The functions which use this function call are still uint32_t:
> ➜  rdma-core git:(master) ✗ grep mlx4_cq_read_wc_imm_data * -rI
> providers/mlx4/cq.c:static uint32_t mlx4_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
> providers/mlx4/cq.c:		cq->ibv_cq.read_imm_data = mlx4_cq_read_wc_imm_data;
> ➜  rdma-core git:(master) ✗ grep mlx5_cq_read_wc_imm_data * -rI
> providers/mlx5/cq.c:static inline uint32_t mlx5_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
> providers/mlx5/cq.c:		cq->ibv_cq.read_imm_data = mlx5_cq_read_wc_imm_data;

Yes, at this point in the series that is fine, they are converted with
each driver's patch. Without sparse be32 and utin32_t are identical.

> > -static inline uint32_t ibv_wc_read_imm_data(struct ibv_cq_ex *cq)
> > +static inline __be32 ibv_wc_read_imm_data(struct ibv_cq_ex *cq)
> 
> Doesn't this change break user applications?

No, they are identical types.

> > +static inline uint32_t ibv_wc_read_invalidated_rkey(struct ibv_cq_ex *cq)
> > +{
> > +#ifdef __CHECKER__
> > +	return (__attribute__((force)) uint32_t)cq->read_imm_data(cq);
> > +#else
> > +	return cq->read_imm_data(cq);
> > +#endif
> > +}
> 
> I don't think that those __CHECKER__ ifdefs should be part of the code.
> They are part of infrastructure to support development of library, but
> are not required for the user of that library.

I do not see a viable alternative.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
