From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: memory region limit at 32 GB?
Date: Mon, 06 Aug 2012 18:51:05 +0300
Message-ID: <501FE7E9.20606@dev.mellanox.co.il>
References: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A@mail.gmail.com> <CAL1RGDV8R1S3L-RH-fWH=LfFegJzwNZPhdNyoQG0ZBEtQQwPjQ@mail.gmail.com> <CALfB72B_Ge0+Tyb9zs+M8K7-8EvKJDQH0ErTxod+UnG6+-KxaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72B_Ge0+Tyb9zs+M8K7-8EvKJDQH0ErTxod+UnG6+-KxaA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Albert,
I have sent yesterday a patch that may enable working with 1TB of registered memory.
Its subject is: [PATCH] net/mlx4_core: Fix num mtt issues.

Can you test it and let us know whether your issue was solved ?
In the meanwhile I have found the root cause of the limit of log_num_mtt of 28.
Plan to send in coming days an extra patch that enables value of 31 which match to 8TB.
Yishai


On 8/2/2012 5:31 PM, Albert Strasheim wrote:
> Hello
>
> On Fri, Jan 20, 2012 at 8:00 PM, Roland Dreier<roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>  wrote:
>> On Fri, Jan 20, 2012 at 9:39 AM, Albert Strasheim<fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
>>> Is there some kind of limit that would prevent me from registering
>>> more than 32 GiB worth of memory regions with ibv_reg_mr in
>>> libibverbs?
>> Yes, by default mlx4 allocates a limited amount of adapter resources
>> for tracking memory regions.  I forget the exact limits but 32GB looks
>> reasonable...
> I think we've run into this in a "real" application (i.e., not a test).
>
> Is this limit per-process or per-HCA or per-machine? It seems it might
> not be per-process.
>
> Any chance to get this limit increased upstream?
>
> Regards
>
> Albert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
