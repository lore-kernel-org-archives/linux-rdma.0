From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: IBV_SEND_INLINE Behavior Differing from Spec
Date: Sun, 5 Jul 2015 09:28:01 -0700
Message-ID: <CAL1RGDUHLBAj6dd8gEy=Ro5zMxckF8b3_7KhzZNZayHr7tWOqQ@mail.gmail.com>
References: <CAPb9-SECy6OJ5S8SCv_3y18MC4NVGJprtNFmimq5MkxK4xg6jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPb9-SECy6OJ5S8SCv_3y18MC4NVGJprtNFmimq5MkxK4xg6jw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 3, 2015 at 2:50 PM, Christopher Mitchell
<christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org> wrote:
> The manpage for ibv_post_send indicates that if you specify the
> IBV_SEND_INLINE flag, that you can immediately re-use the buffer after
> ibv_post_send() returns. However, I have found that if I modify the
> buffer immediately after ibv_post_send(), the changes are rarely
> reflected in the presumably already-posted message. I'm using
> ConnectX-3 cards and RC connections, if that's relevant. Is this a
> known issue, and/or is it possible I'm missing something obvious?

I can't see any way to get the behavior you're seeing.  What version
of libmlx4 are you using?

The reason I say I don't see how that can happen is that in
mlx4_post_send() in libmlx4, if IBV_SEND_INLINE is set, the code
memcpys the data into the descriptor and does not keep any reference
to the pointers passed in through the sg ilst.  So I don't see how the
hardware could even detect that you change the data after
ibv_post_send().

Or what do you mean about "after ibv_post_send()"?  Are you possibly
changing the data from another thread and racing with the memcpy
before ibv_post_send() returns?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
