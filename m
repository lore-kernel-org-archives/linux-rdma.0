From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Thu, 24 Sep 2015 18:46:41 +0800
Message-ID: <5603D491.8050702@oracle.com>
References: <1443077547-12246-1-git-send-email-wen.gang.wang@oracle.com> <5603AF26.9040403@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5603AF26.9040403-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


=E5=9C=A8 2015=E5=B9=B409=E6=9C=8824=E6=97=A5 16:07, Or Gerlitz =E5=86=99=
=E9=81=93:
> On 9/24/2015 9:52 AM, Wengang Wang wrote:
>>       } else {
>> -        kfree(qp->sq.wrid);
>> -        kfree(qp->rq.wrid);
>> +        if (is_vmalloc_addr(qp->sq.wrid))
>> +            vfree(qp->sq.wrid);
>> +        else
>> +            kfree(qp->sq.wrid);
>> +
>> +        if (is_vmalloc_addr(qp->rq.wrid))
>> +            vfree(qp->rq.wrid);
>> +        else
>> +            kfree(qp->rq.wrid);
>>       }
>
> NO
>
> just call kvfree, see commit 914efb0 "mlx4: don't duplicate kvfree()"

Yeap, will re-post.

thanks,
wengang
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
