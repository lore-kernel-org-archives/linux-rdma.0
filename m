From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: IBV Test Program
Date: Tue, 29 Mar 2011 10:07:18 -0700
Message-ID: <AANLkTim431UGAWFNWp3c1wjvdddwp5JfdmhT5V3RoCde@mail.gmail.com>
References: <201103291248.42710.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103291248.42710.kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 29, 2011 at 9:48 AM, Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org> wrote:
> I want to modify rc_pingpong.c to loop and basically send data between the two
> nodes multiple times, instead of just once. The first time through, it
> successfuly completes the transmission. On the next iteration the call to
> ibv_post_recv fails.

Not sure I follow... the pingpong code already sends multiple times in a loop?

Instead of a link to a pastebin, can you send a diff to show what you changed?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
