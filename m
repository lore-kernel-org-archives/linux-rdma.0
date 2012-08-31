From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Fri, 31 Aug 2012 10:02:34 +0300
Message-ID: <CAJZOPZKNEcx1vp7WSwbFXMNAm2bqt0-JauwrLdNK4G0=F5PC2A@mail.gmail.com>
References: <1346323085-2665-1-git-send-email-ogerlitz@mellanox.com>
	<CAJZOPZJOWuoBQx49-O2WLk240GWGRsqfJpCXfhxRV6Cmdw7W0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJOWuoBQx49-O2WLk240GWGRsqfJpCXfhxRV6Cmdw7W0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Roland Dreier =E2=80=8E<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  wrote:
>> Can you be explicit about the race you're worried about?

Roland,

This patch was made after we got the below report from the field.

Dotan, can we get Roland access to the full vmcore image?

Here's the report I got:

"[...] box panic'ed when trying to find a completion queue. There is
no corruption but there is a possible race which could result in
mlx4_cq_completion getting wrong height of the radix tree and
following a bit too deep into the chains. In the other code which uses
this radix tree the access is protected by the lock but
mlx4_cq_completion is running win the interrupt context and cannot
take locks, so instead it run without any protection whatsoever."

The below is the stack trace, the kernel is an RHEL5
2.6.18-274.something, so in that respect, maybe your comment on the
radix tree RCU doesn't take effect there? you can see the problem was
somewhere into the radix tree code.

crash> bt
PID: 8178   TASK: ffff810b91a52400  CPU: 11  COMMAND: "universal_consu"
#0 [ffff81182fe3bc70] crash_kexec at ffffffff800ba60c
#1 [ffff81182fe3bd30] __die at ffffffff80069047
#2 [ffff81182fe3bd70] die at ffffffff8007075b
#3 [ffff81182fe3bda0] do_general_protection at ffffffff80069375
#4 [ffff81182fe3bde0] error_exit at ffffffff80060e9d

    [exception RIP: radix_tree_lookup+38]
    RIP: ffffffff8016405f  RSP: ffff81182fe3be90  RFLAGS: 00210002
    RAX: 6b6b6b6b6b6b6b8b  RBX: ffff810c2fb90000  RCX: 0000000000000006
    RDX: 0000000000000001  RSI: 00000000000000c0  RDI: 6b6b6b6b6b6b6b6b
    RBP: 00000000000000c0   R8: 0000000000010000   R9: 000000000920ea94
    R10: 00000000000000b3  R11: ffffffff800c7ea5  R12: 00000000000000b3
    R13: ffff810c2b15a280  R14: ffff810b7a98ff58  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000

#5 [ffff81182fe3be90] mlx4_cq_completion at ffffffff886f2367
#6 [ffff81182fe3beb0] mlx4_eq_int at ffffffff886f2bd3
#7 [ffff81182fe3bf10] mlx4_msi_x_interrupt at ffffffff886f3078
#8 [ffff81182fe3bf20] handle_IRQ_event at ffffffff8001167c
#9 [ffff81182fe3bf50] __do_IRQ at ffffffff800c7f40
#10 [ffff81182fe3bf90] do_IRQ at ffffffff80071659

--- <IRQ stack> ---

#11 [ffff810b7a98ff58] ret_from_intr at ffffffff80060652
    RIP: 00000000f5cd8859  RSP: 00000000f3eafa28  RFLAGS: 00200202
    RAX: 0000000000000000  RBX: 00000000f3eafaf8  RCX: 000000000b6d4f00
    RDX: 000000000000001c  RSI: 000000000000001c  RDI: 0000000000000000
    RBP: ffff810bf1a0a120   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000001
    R13: 0000000000000000  R14: ffff810b9e7d5bf0  R15: 0000000000000000
    ORIG_RAX: ffffffffffffff4c  CS: 0023  SS: 002b
crash>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
