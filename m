From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 25/25] IB/mlx4: Workaround for mlx4_alloc_priv_pages()
 array allocator
Date: Wed, 22 Jun 2016 17:02:57 +0300
Message-ID: <576A9A91.90608@grimberg.me>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
 <20160620161200.10809.45762.stgit@manet.1015granger.net>
 <CAJ3xEMiS+arM2pYkZKSPe8zHZX_OidngCjVmPXpSjhNNf5_q2A@mail.gmail.com>
 <576A92BA.3020703@grimberg.me>
 <CAJ3xEMiWTME0B6rKQKeCZfxK+s5p-mXcKCdThryRz+zU8V7g3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiWTME0B6rKQKeCZfxK+s5p-mXcKCdThryRz+zU8V7g3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> Can't the driver advertize smaller quantity for what's occupies later
>>> those last eight bytes (255 or 511 of
>>> attr XX instead of 256 or 512)?
>
>> Not sure I understand your question. Are you suggesting that the driver
>> would expose that it's capable of 256 pages per MR?
>
> I am asking if we can advertize something else what would cause not to
> fall into the last
> eight bytes on a page, e.g if we fall there since we advertize for
> some attr N, lets advertize N-1
>
> just asking

We do advertise 511 pages, but the code still needs an aligned
allocation to avoid the last 8 bytes.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
