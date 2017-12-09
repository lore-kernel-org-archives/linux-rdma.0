From: Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>
Subject: Re: [PATCH V2 net-next 2/8] net: hns3: Add mailbox support to VF driver
Date: Sat, 9 Dec 2017 01:16:44 +0100
Message-ID: <CAOFm3uH0G7hA0kpiH+SivdLQ6hH_Prq7_gHg6O-hoaO94dPoTQ@mail.gmail.com>
References: <20171208211702.20104-1-salil.mehta@huawei.com> <20171208211702.20104-3-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171208211702.20104-3-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sali,

On Fri, Dec 8, 2017 at 10:16 PM, Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> This patch adds the support of the mailbox to the VF driver. The
> mailbox shall be used as an interface to communicate with the
> PF driver for various purposes like {set|get} MAC related
> operations, reset, link status etc. The mailbox supports both
> synchronous and asynchronous command send to PF driver.
>
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: lipeng <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
[...]
> --- /dev/null
> +++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
> @@ -0,0 +1,94 @@
> +/*
> + * Copyright (c) 2016-2017 Hisilicon Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */

Why not use the new SPDX ids?
e.g.
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/* Copyright (c) 2016-2017 Hisilicon Limited. */

See Linus posts and Thomas doc patches for details.

-- 
Cordially
Philippe Ombredanne
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
