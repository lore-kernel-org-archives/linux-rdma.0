From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Add missing ioctx->buf + ->dma
 alloc_session_cb init
Date: Mon, 04 Apr 2016 15:58:28 -0700
Message-ID: <1459810708.10124.25.camel@haakon3.risingtidesystems.com>
References: <1459794233-19187-1-git-send-email-nab@linux-iscsi.org>
	 <5702B503.1060006@sandisk.com>
	 <1459809672.10124.18.camel@haakon3.risingtidesystems.com>
	 <5702EE56.10503@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5702EE56.10503-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2016-04-04 at 15:44 -0700, Bart Van Assche wrote:
> On 04/04/2016 03:41 PM, Nicholas A. Bellinger wrote:
> > On Mon, 2016-04-04 at 11:40 -0700, Bart Van Assche wrote:
> >> On 04/04/2016 11:28 AM, Nicholas A. Bellinger wrote:
> >>> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> >>> index 0bd3cb2..c4e0a0a 100644
> >>> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> >>> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> >>> @@ -1266,7 +1266,9 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
> >>>    {
> >>>    	struct se_session *se_sess;
> >>>    	struct srpt_send_ioctx *ioctx;
> >>> -	int tag;
> >>> +	void *buf;
> >>> +	dma_addr_t dma;
> >>> +	int tag, index;
> >>>
> >>>    	BUG_ON(!ch);
> >>>    	se_sess = ch->sess;
> >>> @@ -1277,12 +1279,19 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
> >>>    		return NULL;
> >>>    	}
> >>>    	ioctx = &((struct srpt_send_ioctx *)se_sess->sess_cmd_map)[tag];
> >>> +	buf = ioctx->ioctx.buf;
> >>> +	dma = ioctx->ioctx.dma;
> >>> +	index = ioctx->ioctx.index;
> >>> +
> >>>    	memset(ioctx, 0, sizeof(struct srpt_send_ioctx));
> >>>    	ioctx->ch = ch;
> >>>    	spin_lock_init(&ioctx->spinlock);
> >>>    	ioctx->state = SRPT_STATE_NEW;
> >>>    	init_completion(&ioctx->tx_done);
> >>>
> >>> +	ioctx->ioctx.buf = buf;
> >>> +	ioctx->ioctx.dma = dma;
> >>> +	ioctx->ioctx.index = index;
> >>>    	ioctx->cmd.map_tag = tag;
> >>>
> >>>    	return ioctx;
> >>> @@ -1961,6 +1970,24 @@ static void srpt_free_ch(struct kref *kref)
> >>>    	kfree(ch);
> >>>    }
> >>
> >> These assignments should happen once, namely just after I/O context
> >> allocation, instead of performing these assignments during every
> >> srpt_get_send_ioctx() call.
> >
> > No, the entire structure is being cleared each time, just like what
> > every other driver is doing here.
> >
> > Don't try to micro-optimize to avoid doing memset.
> 
> But why to keep that memset(ioctx, ...) call? That memset() call is new. 
> It was added during the 4.6-rc1 merge window.
> 

I like memset over explicit zero assignments after reuse so future
additions to srp_send_ioctx don't need extra code.

Either way, I don't really care about micro-optimizations right now.

Are you going to verify this patch..?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
