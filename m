From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Thu, 8 Dec 2016 15:08:47 +0530
Message-ID: <CA+sbYW1P4MqsBF14d9ZK_VjV4edU2bh=sLNTVnGs9F3ojF6vWQ@mail.gmail.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com> <a909ae78-ed49-407a-29c7-b86729f356b8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a909ae78-ed49-407a-29c7-b86729f356b8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 8, 2016 at 5:03 AM, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> +#include <net/dcbnl.h>

in the kernel which i used for compilation and testing,
linux/netdevice.h is including net/dcbnl.h. bnxt_re_main.c is
including netdevice.h.  Anyway, i will add this explicitly in
bnxt_re_main.c in V2.

Doug,
 Since David Miller applied the bnxt_en changes to his net-next tree
(both pending patches and bnxt_re related changes), can you please
pull those changes to your bnxt_re branch?

Thanks,
Selvin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
