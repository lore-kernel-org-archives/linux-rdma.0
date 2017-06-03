From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4] add the option of fortified string.h functions
Date: Fri, 2 Jun 2017 22:07:12 -0700
Message-ID: <CAGXu5jLGU_HzjKGOCqc5qnCW9Zta6YNcoz2QeNBpvViyUS0GVg@mail.gmail.com>
References: <20170526095404.20439-1-danielmicay@gmail.com> <20170602140743.274b9babba6118bfd12c7a26@linux-foundation.org>
 <1496439121.13303.1.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496439121.13303.1.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Daniel Axtens <dja-Yfaxwxk/+vWsTnJN9+BGXg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 2, 2017 at 2:32 PM, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, 2017-06-02 at 14:07 -0700, Andrew Morton wrote:
>> On Fri, 26 May 2017 05:54:04 -0400 Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
>> > wrote:
>>
>> > This adds support for compiling with a rough equivalent to the glibc
>> > _FORTIFY_SOURCE=1 feature, providing compile-time and runtime buffer
>> > overflow checks for string.h functions when the compiler determines
>> > the
>> > size of the source or destination buffer at compile-time. Unlike
>> > glibc,
>> > it covers buffer reads in addition to writes.
>>
>> Did we find a bug in drivers/infiniband/sw/rxe/rxe_resp.c?
>>
>> i386 allmodconfig:
>>
>> In file included from ./include/linux/bitmap.h:8:0,
>>                  from ./include/linux/cpumask.h:11,
>>                  from ./include/linux/mm_types_task.h:13,
>>                  from ./include/linux/mm_types.h:4,
>>                  from ./include/linux/kmemcheck.h:4,
>>                  from ./include/linux/skbuff.h:18,
>>                  from drivers/infiniband/sw/rxe/rxe_resp.c:34:
>> In function 'memcpy',
>>     inlined from 'send_atomic_ack.constprop' at
>> drivers/infiniband/sw/rxe/rxe_resp.c:998:2,
>>     inlined from 'acknowledge' at
>> drivers/infiniband/sw/rxe/rxe_resp.c:1026:3,
>>     inlined from 'rxe_responder' at
>> drivers/infiniband/sw/rxe/rxe_resp.c:1286:10:
>> ./include/linux/string.h:309:4: error: call to '__read_overflow2'
>> declared with attribute error: detected read beyond size of object
>> passed as 2nd parameter
>>     __read_overflow2();
>>
>>
>> If so, can you please interpret this for the infiniband developers?
>
> It copies sizeof(skb->cb) bytes with memcpy which is 48 bytes since cb
> is a 48 byte char array in `struct sk_buff`. The source buffer is a
> `struct rxe_pkt_info`:
>
> struct rxe_pkt_info {
>         struct rxe_dev          *rxe;           /* device that owns packet */
>         struct rxe_qp           *qp;            /* qp that owns packet */
>         struct rxe_send_wqe     *wqe;           /* send wqe */
>         u8                      *hdr;           /* points to bth */
>         u32                     mask;           /* useful info about pkt */
>         u32                     psn;            /* bth psn of packet */
>         u16                     pkey_index;     /* partition of pkt */
>         u16                     paylen;         /* length of bth - icrc */
>         u8                      port_num;       /* port pkt received on */
>         u8                      opcode;         /* bth opcode of packet */
>         u8                      offset;         /* bth offset from pkt->hdr */
> };
>
> That looks like 32 bytes (1 byte of padding) on 32-bit and 48 bytes on
> 64-bit (1 byte of padding), so on 32-bit there's a read overflow of 16
> bytes from the stack here.

This should work (untested):

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c
b/drivers/infiniband/sw/rxe/rxe_resp.c
index 23039768f541..7b226deb83bb 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -995,7 +995,9 @@ static int send_atomic_ack(struct rxe_qp *qp,
struct rxe_pkt_info *pkt,
        free_rd_atomic_resource(qp, res);
        rxe_advance_resp_resource(qp);

-       memcpy(SKB_TO_PKT(skb), &ack_pkt, sizeof(skb->cb));
+       memcpy(SKB_TO_PKT(skb), &ack_pkt, sizeof(ack_ptr));
+       memset(SKB_TO_PKT(skb) + sizeof(ack_ptr), 0,
+              sizeof(skb->cb) - sizeof(ack_ptr));

        res->type = RXE_ATOMIC_MASK;
        res->atomic.skb = skb;

Andrew, there are other fortify fixes too:

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/fortify&id=af6b0151896240457ef0fdc18ace533c3d3fbb75
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/fortify&id=186eaf81b43bf90d6b533732fb11ad31ca27df9d
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/fortify&id=95d589f21b3aef757f0eb3d0224b78648a4b22d2
https://github.com/thestinger/linux-hardened/commit/576e64469b0c4634c007445c5f16bfde610b3600

Do you want me to resend these for you to carry, or reping
maintainers? Other fixes have already landed in -next.

(And there are two arm64 fixes, too.)

-Kees

-- 
Kees Cook
Pixel Security
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
