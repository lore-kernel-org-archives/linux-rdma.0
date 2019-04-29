From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Build regressions/improvements in v5.1-rc7
Date: Mon, 29 Apr 2019 10:30:06 +0200
Message-ID: <CAMuHMdUuPPf8T2_WK2V_zW8kxb1ZfzvyKJck9D3MEHMRvYrmdA@mail.gmail.com>
References: <20190429082645.9394-1-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429082645.9394-1-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 10:28 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v5.1-rc7[1] to v5.1-rc6[3], the summaries are:
>   - build errors: +1/-0

  + /kisskb/src/drivers/infiniband/core/uverbs_main.c: error: 'struct
vm_fault' has no member named 'vm_start':  => 898:15, 898:28

mips-allmodconfig
mips-allmodconfig
s390-allmodconfig
s390-allyesconfig

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/37624b58542fb9f2d9a70e6ea006ef8a5f66c30b/ (all 236 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/085b7755808aa11f78ab9377257e1dad2e6fa4bb/ (all 236 configs)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
