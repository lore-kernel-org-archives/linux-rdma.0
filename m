From: Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>
Subject: Re: [PATCH V3 net-next 3/8] net: hns3: Add HNS3 VF HCL(Hardware
 Compatibility Layer) Support
Date: Tue, 12 Dec 2017 23:40:47 +0100
Message-ID: <CAOFm3uGs2yO4jfFZSVzZMbE6cbgzzkSBDPFAO_fbt-1XKx7FpQ@mail.gmail.com>
References: <20171212175205.236-1-salil.mehta@huawei.com> <20171212175205.236-4-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171212175205.236-4-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Salil Mehta <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dear Salil,

On Tue, Dec 12, 2017 at 6:52 PM, Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> This patch adds the support of hardware compatibiltiy layer to the
> HNS3 VF Driver. This layer implements various {set|get} operations
> over MAC address for a virtual port, RSS related configuration,
> fetches the link status info from PF, does various VLAN related
> configuration over the virtual port, queries the statistics from
> the hardware etc.
>
> This layer can directly interact with hardware through the
> IMP(Integrated Mangement Processor) interface or can use mailbox
> to interact with the PF driver.
>
> Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: lipeng <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> Patch V3: Addressed SPDX change requested by Philippe Ombredanne
>   Link: https://lkml.org/lkml/2017/12/8/874
> Patch V2: Addressed some internal comments
> Patch V1: Initial Submit
> ---
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 1490 ++++++++++++++++++++
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  164 +++
>  2 files changed, 1654 insertions(+)
>  create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>  create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
>
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> new file mode 100644
> index 0000000..ff55f4c
> --- /dev/null
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> @@ -0,0 +1,1490 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (c) 2016-2017 Hisilicon Limited.
> + */

This is just me nitpicking and this is entirely up to you.... but in
such a simple case you could go all the way too:

> +// SPDX-License-Identifier: GPL-2.0+
> +// Copyright (c) 2016-2017 Hisilicon Limited.

In this case this can make the thing look more consistent.
See also Linus commentaries about this [1][2][3][4]

[1] https://lkml.org/lkml/2017/11/25/133
[2] https://lkml.org/lkml/2017/11/25/125
[3] https://lkml.org/lkml/2017/11/2/715
[4] https://lkml.org/lkml/2017/11/2/805

-- 
Cordially
Philippe Ombredanne
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
