From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 25/25] IB/mlx4: Workaround for mlx4_alloc_priv_pages()
 array allocator
Date: Wed, 22 Jun 2016 16:47:58 +0300
Message-ID: <CAJ3xEMiWTME0B6rKQKeCZfxK+s5p-mXcKCdThryRz+zU8V7g3g@mail.gmail.com>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
 <20160620161200.10809.45762.stgit@manet.1015granger.net> <CAJ3xEMiS+arM2pYkZKSPe8zHZX_OidngCjVmPXpSjhNNf5_q2A@mail.gmail.com>
 <576A92BA.3020703@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <576A92BA.3020703-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 22, 2016 at 4:29 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>>> Ensure the MR's PBL array never occupies the last 8 bytes of a page.
>>> This eliminates random "Local Protection Error" flushes when SLUB
>>> debugging is enabled.
>>>
>>> Fixes: 1b2cd0fc673c ('IB/mlx4: Support the new memory registration API')
>>
>>
>> Can't the driver advertize smaller quantity for what's occupies later
>> those last eight bytes (255 or 511 of
>> attr XX instead of 256 or 512)?

> Not sure I understand your question. Are you suggesting that the driver
> would expose that it's capable of 256 pages per MR?

I am asking if we can advertize something else what would cause not to
fall into the last
eight bytes on a page, e.g if we fall there since we advertize for
some attr N, lets advertize N-1

just asking
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
