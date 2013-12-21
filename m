From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] IB/usnic: Fix userspace/kernel ABI alignement discrepancy
Date: Fri, 20 Dec 2013 17:25:13 -0800
Message-ID: <CAG4TOxN3jctB=K3VavK6ea1QYkcW0H_KNAYfwB7LTxtiJjRdSQ@mail.gmail.com>
References: <ADC95B5F-C8B0-4360-B757-78DED5B86C9C@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ADC95B5F-C8B0-4360-B757-78DED5B86C9C-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 20, 2013 at 1:39 PM, Upinder Malhi (umalhi)
<umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> @@ -67,7 +67,7 @@ struct usnic_ib_create_qp_resp {
>         u32                             rq_idx[USNIC_QP_GRP_MAX_RQS];
>         u32                             cq_idx[USNIC_QP_GRP_MAX_CQS];
>         u32                             transport;
> -       u64                             reserved;
> +       u32                             reserved[8];
> };

Making your struct be an odd number of 4-byte words seems like a bad
idea.  It might be padded differently on different architectures.  for
example:

$ cat a.c
#include <stdio.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
    struct foo {
        uint64_t a;
        uint32_t b[3];
    };

    printf("%zd\n", sizeof (struct foo));
    return 0;
}
$ gcc -m32 -o a ~/a.c
$ ./a
20
$ gcc -o a ~/a.c
$ ./a
24


I would suggest writing a little test harness and making sure that
sizeof and offsetof give the same outputs for all your structs on both
32-bit and 64-bit x86 at the very least.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
