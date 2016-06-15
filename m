From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 11/29] IB/rxe: Allocation pool for RDMA objects
Date: Wed, 15 Jun 2016 19:52:16 +0300
Message-ID: <CAG9sBKM_egsEDq6nbNVNxeB0aC=Ru+fGOKiLc1EPdQ4TKaX6nA@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <1464886657-14258-12-git-send-email-monis@mellanox.com> <011101d1c721$5c22d590$146880b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <011101d1c721$5c22d590$146880b0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Steve
Thanks for the review

>
> Perhaps the above slab names should be prefixed with "rxe-"?  EG: "rxe-cq",
> "rxe-qp", etc.  They look very non-descriptive when looking at them in slabinfo:
>
Agree. I'll change in next series

> [root@stevo2 linux-2.6]# head /proc/slabinfo
> slabinfo - version: 2.1
> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>
> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs>
> <num_slabs> <sharedavail>
> uc                     0      0    352   11    1 : tunables   54   27    8 :
> slabdata      0      0      0
> cq                     6     34    240   17    1 : tunables  120   60    8 :
> slabdata      2      2      0
> qp                     4      6   1920    2    1 : tunables   24   12    8 :
> slabdata      3      3      0
> pd                     4     36    112   36    1 : tunables  120   60    8 :
> slabdata      1      1      0
>
>
> Also when using rxe with nvmf (among other bugs I'm chasing down), when you
> unload ib_rxe, there are allocated cq objects left in the the slab cache:
>
Do you have a simple reproducing scenario?
I'm not sure I'll be able to fix until I submit the next series but
I'll try to investigage it right after

> kmem_cache_destroy cq: Slab cache still has objects
> CPU: 5 PID: 4147 Comm: rmmod Tainted: G            E   4.7.0-rc2-nvmf-all.3+rxe+
> #51
> Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
>  0000000000000000 ffff881007b33d98 ffffffff812d1359 ffff88103bd65098
>  ffffea00378983d0 ffff881007b33da8 ffff881078b32240 ffff881007b33df8
>  ffffffff8117619c ffff881007b33da8 ffff881007b33da8 ffff88103bec6960
> Call Trace:
>  [<ffffffff812d1359>] dump_stack+0x51/0x78
>  [<ffffffff8117619c>] kmem_cache_destroy+0x12c/0x150
>  [<ffffffffa04c62cc>] rxe_cache_exit+0x1c/0x40 [ib_rxe]
>  [<ffffffffa04ce4cf>] rxe_module_exit+0x13/0x23 [ib_rxe]
>  [<ffffffff810e1d15>] SyS_delete_module+0x185/0x1d0
>  [<ffffffff8100278e>] ? syscall_trace_enter_phase2+0x6e/0x190
>  [<ffffffff81002915>] ? syscall_trace_enter+0x65/0x70
>  [<ffffffff81002d4d>] do_syscall_64+0x6d/0x160
>  [<ffffffff8161857c>] entry_SYSCALL64_slow_path+0x25/0x25
> rxe: unloaded
>
> Steve.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
