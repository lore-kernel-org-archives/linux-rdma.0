From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Supported uverbs opcodes?
Date: Wed, 19 Aug 2015 06:21:08 -0700
Message-ID: <20150819132108.GA31558@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

What opcodes are supposed to be submitted by users?

Currently we do not define opcodes in the UAPI and kinda rely that
userspace uses the same ones as the kernel.

For thos defines by libibverbs (RDMA_WRITE, RDMA_WRITE_WITH_IMM,
SEND, SEND_WITH_IMM, RDMA_READ, ATOMIC_CMP_AND_SWP and
ATOMIC_FETCH_AND_ADD) this happens to work fine.

Additionally uvers takes care of SEND_WITH_INV (but not READ_WITH_INV)
and copies the right fields into the kernel WR, but it also allows
all other opcodes without taking care of their fields.

My send_wr split that I'm going to repost soon will disallow all
those not handled explicitly as the current situration seems
dangerous.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
