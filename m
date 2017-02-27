From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibv_rc_pingpong, rping, and other tools hang with Linux 4.10.0
 and rdma-core 13
Date: Mon, 27 Feb 2017 10:15:49 -0700
Message-ID: <20170227171549.GG5891@obsidianresearch.com>
References: <CAE=AiOMqGzMC6sD-cXB_sGRH_L15annm_4WottmY17oCSNZveA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE=AiOMqGzMC6sD-cXB_sGRH_L15annm_4WottmY17oCSNZveA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, GAFBlizzard <gtschemer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Youngjae Lee <dhrkaeh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 27, 2017 at 12:02:07PM -0500, Josh Beavers wrote:

> I just confirmed that reverting the C11 atomics commit (6b26a9e24739)
> fixes ibv_rc_pingpong on my two at91 ARM boards.  For some reason the
> first few packets seem to send slowly, but once it gets going the rest
> send quickly.

How are you able to get it to compile? Without that commit ARM32
should blow up?

> Jason, was it intentional that rmb() was removed with no replacement
> in rxe_post_one_recv()?   See
> https://github.com/linux-rdma/rdma-core/commit/6b26a9e24739576ac3f4ae308485389a5b285497?diff=split#diff-f6b2d2321c2b3273e3453d055a62fa98
> for details.

Yes, the rmb should have been a wmb and the atomic_thread_fence added
to in advance_producer correctly replaces it.

> Unfortunately, even after reverting the C11 atomics commit, I still
> seem to observe "Couldn't post send" failures which kill the ping
> occasionally.  Is this a known issue?

Sounds like this is unrelated to 6b26..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
