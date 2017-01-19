From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/7] IB/mlx5: Return error for unsupported
 signature type
Date: Thu, 19 Jan 2017 09:58:10 +0200
Message-ID: <2a7d9d17-4657-1ab1-0b17-8358da046e99@grimberg.me>
References: <20170118121036.32642-1-leon@kernel.org>
 <20170118121036.32642-3-leon@kernel.org> <20170118203708.GE17688@yuval-lap>
 <20170119064107.GK32481@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119064107.GK32481-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> What's the reason for the empty warnings i see in callers of this function?
>> ("mlx5_ib_warn(dev, "\n");".
>
> mlx5_ib_warn prints line and function name and in this format it mimics tracepoint.
>
>>
>> Can we remove these while we are here?
>
> mlx5 prints deserve complete series, there are a lot of them need to be
> revised. I prefer to do it all it once.

I have to agree with Leon, that would help a lot.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
