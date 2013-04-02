From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 0/3] Least attached vector support
Date: Tue, 2 Apr 2013 10:07:16 -0700
Message-ID: <CAL1RGDXJNkMViMfbnbGHGxWfUUWQBs8sCFZq3sTt_ugbYUuunw@mail.gmail.com>
References: <4BEBC56C.3090605@mellanox.co.il> <loom.20130402T161828-251@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20130402T161828-251-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 2, 2013 at 7:20 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> Can anyone tell me what happened with this patch series ? To me this looks like
> a useful patch series to make the mlx4_en driver faster. However, I haven't seen
> anyone posting any review comments to this series and apparently this
> functionality isn't upstream either.

It was never clear to me that "number of CQs attached" is a
particularly good way to choose an interrupt vector.  It would seem to
me that we would want something that takes into account CPU affinity,
possibly NUMA effects, etc.  Also I don't think there were any
performance numbers posted for these changes, were there?

(BTW It would be interesting to know how much improvement one could
get on modern 2/4 socket systems by allocating EQ, CQ, QP, etc. memory
on the "right" NUMA node -- where I don't know if "right" means on the
node closest to the adapter or the node where the CPU will access the
queue)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
