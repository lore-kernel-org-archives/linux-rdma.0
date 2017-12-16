From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v2 4/5] rds: Add runchecks.cfg for net/rds
Date: Sat, 16 Dec 2017 09:45:25 -0800
Message-ID: <20171216094525.5e9c985c@xeon-e3>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
        <4dc9b2fc0ddd1eb91d9b8785ae4886c6b08f3ee5.1513430008.git-series.knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4dc9b2fc0ddd1eb91d9b8785ae4886c6b08f3ee5.1513430008.git-series.knut.omang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Knut Omang <knut.omang@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

On Sat, 16 Dec 2017 15:42:29 +0100
Knut Omang <knut.omang@oracle.com> wrote:

> +
> +# Important to fix from a quality perspective:
> +#
> +except AVOID_BUG connection.c ib.c ib_cm.c ib_rdma.c ib_recv.c ib_ring.c ib_send.c info.c loop.c message.c
> +except AVOID_BUG rdma.c recv.c send.c stats.c tcp_recv.c transport.c
> +except MEMORY_BARRIER ib_recv.c send.c tcp_send.c
> +except WAITQUEUE_ACTIVE cong.c ib_rdma.c ib_ring.c ib_send.c
> +except UNNECESSARY_ELSE bind.c ib_cm.c
> +except MACRO_ARG_PRECEDENCE connection.c ib.h rds.h
> +except MACRO_ARG_REUSE rds.h
> +except ALLOC_SIZEOF_STRUCT cong.c ib.c ib_cm.c loop.c message.c rdma.c
> +except UNCOMMENTED_DEFINITION ib_cm.c
> +
> +# Code simplification:
> +#
> +except ALLOC_WITH_MULTIPLY ib.c
> +except PREFER_PR_LEVEL ib_cm.c ib_recv.c ib_send.c rdma_transport.c threads.c transport.c
> +except UNNECESSARY_ELSE ib_fmr.c
> +except UNNECESSARY_PARENTHESES ib_rdma.c rdma.c recv.c send.c
> +except PRINTK_RATELIMITED ib_frmr.c
> +except EMBEDDED_FUNCTION_NAME ib_rdma.c
> +
> +# Style and readability:
> +#
> +except BRACES ib_cm.c ib_rdma.c ib_recv.c send.c transport.c
> +except OOM_MESSAGE ib.c tcp.c
> +except LONG_LINE_STRING ib.c ib_recv.c ib_send.c
> +except FUNCTION_ARGUMENTS ib.h ib_mr.h rds.h tcp.h
> +except OPEN_ENDED_LINE recv.c ib_recv.c
> +
> +# Candidates to leave as exceptions (don't fix):
> +except MULTIPLE_ASSIGNMENTS ib_send.c
> +except LONG_LINE_STRING connection.c
> +except OPEN_BRACE connection.c
> +

Why start letting subsystems have a free-pass?
Also this would mean that new patches to IB would continue the bad habits.
