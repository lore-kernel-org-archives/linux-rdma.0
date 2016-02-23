From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/isert: Convert to new CQ API
Date: Tue, 23 Feb 2016 14:31:24 +0100
Message-ID: <20160223133124.GA17071@lst.de>
References: <1456148958-27973-1-git-send-email-hch@lst.de> <1456148958-27973-4-git-send-email-hch@lst.de> <56CC3F39.1030002@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56CC3F39.1030002-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 23, 2016 at 01:15:05PM +0200, Sagi Grimberg wrote:
>
>> Use the workqueue based CQ type similar to what isert was using previously,
>> and properly split up the completion handlers.
>
> Ideally, we'd have a separate done handler for each time of response
> (text, logout, tmr, normal task etc..) but it requires more work so that
> would be possible, we can do it incrementally.

Except for TMR and logout they are treated very similar in isert,
so I'm not sure such a fine grained split is worth it.  But there's
some opportunity for cleaning up the completions hanlders for sure.

> This patch had a minor conflict on top of a fix patch from Jenny, I
> fixed the fuzz, would you mind if I resend a combined set once the
> code passes our regression tests?

Sure, please go ahead!

>>   static void
>> +isert_beacon_done(struct ib_cq *cq, struct ib_wc *wc)
>> +{
>> +	struct isert_conn *isert_conn = wc->qp->qp_context;
>> +
>> +	isert_print_wc(wc);
>> +
>> +	isert_info("conn %p completing wait_comp_err\n", isert_conn);
>> +	complete(&isert_conn->wait_comp_err);
>> +}
>> +
>
> I have a patch that replaces this with the new ib_drain_qp() from
> Steve, I'll add it to the set.

Great!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
