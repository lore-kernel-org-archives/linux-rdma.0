From: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibverbs] Expose QP block self multicast loopback
 creation flag
Date: Wed, 28 Oct 2015 09:38:59 +0200
Message-ID: <CAKHjkjkQ9vjPh0GXWdfebiuHyxCq_ikZFQ+be7wR4bGwWMrGRA@mail.gmail.com>
References: <1445950381-10723-1-git-send-email-eranbe@mellanox.com>
	<20151027190447.GA6860@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151027190447.GA6860-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2015 at 9:04 PM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Tue, Oct 27, 2015 at 02:53:01PM +0200, Eran Ben Elisha wrote:
> ...
>> +enum ibv_qp_create_flags {
>> +     IBV_QP_CREATE_BLOCK_SELF_MCAST_LB       = 1 << 1,
>>  };
>>
> I'm sure that I'm missing something important, but why did it start
> from shift 1 and not shift 0?
> ....

QP creation flags are available for kernel QP.
The purpose of this patch was to expose QP creation flag of  MC LB
prevention to user space.

from include/rdma/ib_verbs.h,
enum ib_qp_create_flags {
...
IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK   = 1 << 1,
...
}

It is better to keep the same values in user space flags.

Eran.

>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
