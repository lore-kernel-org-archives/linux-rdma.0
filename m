From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/3] IB/core: Fix ib_resolve_eth_dmac for Raw
 Packet QP
Date: Mon, 4 Jul 2016 15:30:52 +0300
Message-ID: <CAJ3xEMg=vLGKAD9arxFoyP5mk0VYwKj3XqUiZE=q0-dL3L2kqQ@mail.gmail.com>
References: <1467549727-23479-1-git-send-email-leon@kernel.org>
 <1467549727-23479-3-git-send-email-leon@kernel.org> <CAJ3xEMg+kqmEQ7B_JAKGnu3ubwu5f-40jbeL4Wg9udUeoxEZJw@mail.gmail.com>
 <C8D4A0D8-4D97-4BAB-8FE4-DDEDDDAF9775@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C8D4A0D8-4D97-4BAB-8FE4-DDEDDDAF9775-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 4, 2016 at 9:10 AM, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> On 3 Jul 2016, at 3:52 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>> What "release address resolution" means?

> Oops sorry for the typo error, "real" not "release".

whatever, fix it for V2, unless you really (really?) want that to be
for ever in the kernel log in this confusing way
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
