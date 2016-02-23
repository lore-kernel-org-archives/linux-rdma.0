From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/5] IB/isert: Convert to new CQ API
Date: Tue, 23 Feb 2016 13:15:05 +0200
Message-ID: <56CC3F39.1030002@dev.mellanox.co.il>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
 <1456148958-27973-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456148958-27973-4-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> Use the workqueue based CQ type similar to what isert was using previously,
> and properly split up the completion handlers.

Ideally, we'd have a separate done handler for each time of response
(text, logout, tmr, normal task etc..) but it requires more work so that
would be possible, we can do it incrementally.

This patch had a minor conflict on top of a fix patch from Jenny, I
fixed the fuzz, would you mind if I resend a combined set once the
code passes our regression tests?

> Note that this also takes special care to handle the magic login WRs
> separately, and also renames the submission functions so that it's clear
> that they are only to be used for the login buffers.

That's very helpful.

>   static void
> +isert_beacon_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct isert_conn *isert_conn = wc->qp->qp_context;
> +
> +	isert_print_wc(wc);
> +
> +	isert_info("conn %p completing wait_comp_err\n", isert_conn);
> +	complete(&isert_conn->wait_comp_err);
> +}
> +

I have a patch that replaces this with the new ib_drain_qp() from
Steve, I'll add it to the set.

Looks good,

Acked-by: Sagi Grimberg <sagig@mellanox.com>
