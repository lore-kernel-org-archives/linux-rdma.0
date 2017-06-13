From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V5] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Tue, 13 Jun 2017 17:01:52 -0400
Message-ID: <1497387712.7171.245.camel@redhat.com>
References: <1496665420-8100-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496665420-8100-1-git-send-email-baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-05 at 20:23 +0800, Jia-Ju Bai wrote:
> The driver may sleep under a spin lock, and the function call path
> is:
> post_one_send (acquire the lock by spin_lock_irqsave)
>   init_send_wqe
>     copy_from_user --> may sleep
> 
> There is no flow that makes "qp->is_user" true, and copy_from_user
> may
> cause bug when a non-user pointer is used. So the lines of
> copy_from_user
> and check of "qp->is_user" are removed.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
