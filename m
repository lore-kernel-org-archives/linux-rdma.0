From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: MLX4 driver problem with mlx4_ib_arm_cq
Date: Thu, 7 Jun 2012 08:26:36 -0700
Message-ID: <CAL1RGDVt1OVzJFejiDVBoyOXnOZ_77RUrjn1ok5BTR0LGMif6g@mail.gmail.com>
References: <CAHsgog=X-Yy1a25kX8Q4MzOiku=mZyRkQP4E3kfdNVzacOqhiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHsgog=X-Yy1a25kX8Q4MzOiku=mZyRkQP4E3kfdNVzacOqhiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hector Abrach <habrach-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 5, 2012 at 8:57 AM, Hector Abrach <habrach-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I continue to have a problem with an MLX4 driver where it fails to go
> to the ARMED -> ACTIVE state. However, this failure is a consequence
> of a previous failure in mlx4_ib_arm_cq.
>
> Within functions, I get:
> mlx4_ib_poll_one -> next_cqe_sw failing with -EAGAIN. Basically next_cqe_sw = 0
>
> That is because function get_cqe is returning NULL. Would you happen
> to know why this is happening? Any pointers or any help at all would
> be greatly appreciated.
> What could be failing to initialize for get_cqe to return NULL?
> What is get_cqe trying to do?

I think you're a bit confused about how CQs work.  If the CQ is empty when
you poll it, then it is perfectly correct for no entry to be returned.

The sequence you describe of mlx4_ib_poll_one() is exactly what I would
expect if the CQ is empty.

And I don't know what any of that has to do with mlx4_ib_arm_cq -- that
requests the hardware to generate an event queue entry if an entry is
added to the CQ.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
