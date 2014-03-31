From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] librdmacm: lazy initialization for ib devices]
Date: Mon, 31 Mar 2014 07:55:03 +0300
Message-ID: <CAJZOPZLd4mbpX1Vnqib-YOTE8fsBfTwJ45b5m+ChrKmS-EZ7Xg@mail.gmail.com>
References: <20140327082325.GA5006@shamir-pc>
	<5333E37B.5080202@mellanox.com>
	<20140330102731.GA4433@shamir-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140330102731.GA4433@shamir-pc>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovith <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 30, 2014 at 1:27 PM, Shamir Rabinovith
<shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Mar 27, 2014 at 10:38:19AM +0200, Or Gerlitz wrote:
>> sorry, but you didn't provide an answer to my question - why is
>> ibv_open_device failing if called from N > M (what's
>> N and what's M) processes/threads.
>>
>> Or.
>
> The limit is due to firmware UAR BAR size. The issue happen here:
> ib_uverbs_get_context -> ibdev->alloc_ucontext -> mlx4_ib_alloc_ucontext
> -> mlx4_uar_alloc -> mlx4_bitmap_alloc .
[...]

So what **exact** operation in librdmacm fails after N processes
loaded the library on a node with M HCAs and what are N and M?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
