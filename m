From: Eric Dumazet <edumazet@google.com>
Subject: Re: [mainline][bisected 55469b][ppc] build error at drivers/net/ethernet/mellanox/mlx4/en_rx.c
Date: Tue, 30 Oct 2018 00:05:49 -0700
Message-ID: <CANn89iJGgCMYRp7h=h+g=o+P9VA+8U+NxFhXP70B_PSG_mp7OQ@mail.gmail.com>
References: <1540881776.20660.9.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1540881776.20660.9.camel@abdul.in.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: abdhalee@linux.vnet.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, sachinp@linux.vnet.ibm.com, manvanth@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, netdev <netdev@vger.kernel.org>, Tariq Toukan <tariqt@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 29, 2018 at 11:43 PM Abdul Haleem
<abdhalee@linux.vnet.ibm.com> wrote:
>
> Greeting's
>
> mainline build fails on my powerpc with commit 55469b : drivers: net:
> remove <net/busy_poll.h> inclusion when not needed
>
> Machine type: PowerPC power 8 bare-metal
> kernel : 4.19.0
> gcc :  4.8.5
> config attached
>

Thanks for the report, but this patch is not in 4.19 kernel ? It is
scheduled for 4.20 only.

Anyway, mlx4 needs to include  <net/ip.h> directly, instead of
assuming it is indirectly included by another file.
