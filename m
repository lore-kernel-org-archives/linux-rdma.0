From: Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH V3] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Mon, 5 Jun 2017 11:30:14 +0300
Message-ID: <CAG9sBKNKTT8ceHrXRhLRns53ejH0kwaLMy-qAzdmo=Hy5h02Yw@mail.gmail.com>
References: <1496648342-906-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496648342-906-1-git-send-email-baijiaju1990@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: yuval.shaia@oracle.com, Sean Hefty <sean.hefty@intel.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> -                       if (qp->is_user && copy_from_user(p, (__user void *)
> -                                           (uintptr_t)sge->addr, sge->length))
> +                       spin_unlock_irqrestore(&qp->sq.sq_lock, *flags);
> +                       err = copy_from_user(p, (__user void *)
> +                                       (uintptr_t)sge->addr, sge->length);
> +                       spin_lock_irqsave(&qp->sq.sq_lock, *flags);
> +                       if (qp->is_user && err)
>                                 return -EFAULT;
qp-_is_user is always false in this function (flow starts from
rxe_post_send_kernel) so this line is a dead code
In fact, this patch seems to add a serious bug when it uses
copy_from_user() from a non user pointer.
Do you agree?
