From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/8] mlx4: Add sparse annotations
Date: Thu, 13 Jul 2017 01:07:52 -0700
Message-ID: <20170713080752.GA25727@infradead.org>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170713072343.GI1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713072343.GI1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >  	case MLX4_RECV_OPCODE_SEND_INVAL:
> > -		return be32toh(cq->cqe->immed_rss_invalid);
> > +		/* This is returning invalidate_rkey which is in host order, see
> > +		 * ibv_wc_read_invalidated_rkey */
> > +		return (__force __be32)be32toh(cq->cqe->immed_rss_invalid);
> 
> Jason,
> It is insane construction, convert to host-> force to be32 -> use as uint32_t.

Yes, this doesn't make sense to me - we are swapping it but pretending
it's native?  There's certainly something very odd going on here.

It seems like the ->read_imm_data needs to be split and/or have a
prototype change.  The sad part is that it is an exported ABI, although
one that is almost undocumented.

> >  }
> >
> > -uint32_t *mlx4_alloc_db(struct mlx4_context *context, enum mlx4_db_type type)
> > +__be32 *mlx4_alloc_db(struct mlx4_context *context, enum mlx4_db_type type)
> >  {
> >  	struct mlx4_db_page *page;
> >  	uint32_t *db = NULL;
> > @@ -113,10 +113,10 @@ found:
> >  out:
> >  	pthread_mutex_unlock(&context->db_list_mutex);
> >
> > -	return db;
> > +	return (__force __be32 *)db;
> >  }
> 
> I see that librdmacm/rsocket.c full of these __force annotations.
> I would be very happy to see it fixed rather suppressed, but don't know
> if it is realistic goal or not.

The db local variable in mlx4_alloc_db should be easily changed to a
__be32 pointer - it is derived from a void pointer using pointer
arithmetics.

In general a __foce for endian annotations is a GIANT WARNING sign.
Don't ever add one without a long discussion first, and even then only
in a well documented helper and not randomly all over code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
