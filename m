From: Roland Dreier <roland@kernel.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Mon, 21 May 2012 09:03:08 -0700
Message-ID: <CAG4TOxNUzGgS_pkGcxBx1FZdPSVB=7E-bC40+8VPMhgZeWjYeg@mail.gmail.com>
References: <20120521120512.15f1e9dfc961b05dfee72f79@canb.auug.org.au> <4FBA4B84.9030302@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FBA4B84.9030302@chelsio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vipul Pandya <vipul@chelsio.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/hw/cxgb4/device.c
> b/drivers/infiniband/hw/cxgb4/device.c
> index c8fd1d8..cb4ecd7 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -32,6 +32,7 @@
> =A0#include <linux/module.h>
> =A0#include <linux/moduleparam.h>
> =A0#include <linux/debugfs.h>
> +#include <linux/vmalloc.h>
>
> =A0#include <rdma/ib_verbs.h>

Thanks, I folded this into my pull request.
