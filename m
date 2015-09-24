From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mlx4: vmalloc for mlx4_ib_wq.wrid and mlx4_ib_srq.wrid
Date: Thu, 24 Sep 2015 14:15:34 +0800
Message-ID: <56039506.8060402@oracle.com>
References: <1443060654-10402-1-git-send-email-wen.gang.wang@oracle.com>
 <56038B25.1010901@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56038B25.1010901-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Or,

=E5=9C=A8 2015=E5=B9=B409=E6=9C=8824=E6=97=A5 13:33, Or Gerlitz =E5=86=99=
=E9=81=93:
> On 9/24/2015 5:10 AM, Wengang Wang wrote:
>> Use __vmalloc to allocate memory for mlx4_ib_wq.wrid and=20
>> mlx4_ib_srq.wrid.
>>
>> Several hits that the kmalloc for wrid failed with the following lik=
e
>> call back stack:
>
> Using vmalloc and friends should be done with care, specifically, we'=
d=20
> like
> to go there only when needed (namely when kmalloc fails), else we can=
=20
> get into
> another set of troubles.
>
> Please use the practice introduced in commit 89dd86d "mlx4_core: Allo=
w=20
> large mlx4_buddy bitmaps"
> to go the vmalloc way only when needed, note you can just call kvfree=
=20
> later, no need to branch
> when freeing things (as was fixed later in commit 914efb0 "mlx4: don'=
t=20
> duplicate kvfree()")
>
> And have the patch title to be
>
> IB/mlx4: Use vmalloc  for WR buffers when needed
>
> I don't think the OOM oops in the change log helps, skip it.
>

OK, will look at commit 89dd86d and try again.

thanks for so quick response.

thanks
wengang
> Or.
>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
