From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 6 Aug 2015 02:47:12 -0700
Message-ID: <20150806094712.GA21574@infradead.org>
References: <20150804143447.GA22172@infradead.org>
 <20150806044008.GB14153@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150806044008.GB14153-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 05, 2015 at 10:40:08PM -0600, Jason Gunthorpe wrote:
> Any numbers on the struct size reduction?

sizeof(struct ib_send_wr) (old): 96

sizeof(struct ib_send_wr): 48
sizeof(struct ib_rdma_wr): 64
sizeof(struct ib_atomic_wr): 96
sizeof(struct ib_ud_wr): 88
sizeof(struct ib_fast_reg_wr): 88
sizeof(struct ib_bind_mw_wr): 96
sizeof(struct ib_sig_handover_wr): 80

sizeof(struct ib_fastreg_wr) (Sagi): 64

So the commonly used send and rdma WRs are drastically redueces.  FR
currently doesn't look much better, but the replacement WR for it in
Sagi's series will be in a simila ballpark.

Note that we can remove an additional 4 bytes from each of them by
removing the unused xrc_remote_srq_num value from struct ib_send_wr.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
