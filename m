From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 3/5] mlx5: Avoid that sparse complains about dubious !x &
 y expressions
Date: Thu, 8 Dec 2016 09:52:20 -0800
Message-ID: <eb8fd218-eefb-d836-ac61-e394fd113240@sandisk.com>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <572c702f-589f-2d5a-9e13-45223191db85@sandisk.com>
 <CAJ3xEMjPZYgLhDi_6Jxkx_dg_RaehD=3SchMt_noLzQEChPrxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjPZYgLhDi_6Jxkx_dg_RaehD=3SchMt_noLzQEChPrxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/08/2016 01:26 AM, Or Gerlitz wrote:
> Matan came up with a fix (below) which solves all these sparse
> complaints in both drivers (mlx5 IB and core)
> while basically not touching the code, we will be going with that fix
> to 4.11, thanks, I will add reported
> by pointing to you.

Hello Or,

Please consider to keep the following change:

-	MLX5_SET(mkc, mkc, en_rinval, !!((type == IB_MW_TYPE_2)));
+	MLX5_SET(mkc, mkc, en_rinval, type == IB_MW_TYPE_2);

I don't think that specifying two boolean not (!) operators in front of 
a boolean expression is useful :-)

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
