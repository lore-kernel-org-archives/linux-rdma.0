From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] IB/srpt: Convert to percpu_ida tag allocation
Date: Thu, 7 Apr 2016 15:43:38 +0200
Message-ID: <20160407134338.GC17477@lst.de>
References: <57055BC6.7070402@sandisk.com> <57055C25.4060304@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57055C25.4060304@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> +static struct srpt_send_ioctx *srpt_tag_to_ioctx(struct srpt_rdma_ch *ch,
> +						 int tag)
> +{
> +	return &((struct srpt_send_ioctx *)ch->sess->sess_cmd_map)[tag];
> +}
> +
> +static int srpt_ioctx_to_tag(struct srpt_rdma_ch *ch,
> +			     struct srpt_send_ioctx *ioctx)
> +{
> +	return ioctx - (struct srpt_send_ioctx *)ch->sess->sess_cmd_map;
> +}

This is really something the core code should be doing..

I have to admit I really don't understand why the target core is trying
to force everyone to use the ida allocator - the 'tag' concept here
isn't really useful to most drivers.

> +	for (i = 0; i < ch->rq_size; i++) {
> +		struct srpt_send_ioctx *ioctx = srpt_tag_to_ioctx(ch, i);
> +
> +		if (srpt_init_ioctx(sdev, &ioctx->ioctx, ch->rsp_size,
> +				    DMA_TO_DEVICE) < 0) {
> +			pr_err("Initialization of I/O context %d/%d failed\n",
> +			       i, ch->rq_size);
> +			goto deregister_session;
> +		}
> +		ioctx->ch = ch;
> +	}

E.g. here it would be really nice if the the driver had to just provide
init_cmd and cleanup_cmd methods, and the core would iterate over
the map, and call them on each cmds without the need for the
casts and pointer arithmetics in each driver.

But I guess for now this will do it:

Reviewed-by: Christoph Hellwig <hch@lst.de>
