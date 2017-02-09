From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 04/10] Do not use kernel byteswap macros
Date: Thu, 9 Feb 2017 16:23:28 -0600
Message-ID: <049801d28323$2381f860$6a85e920$@opengridcomputing.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com> <1486677212-3188-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> These days the version in glibc's endian.h is just as good, since
> gcc 4.3 (we support no earlier compiler) this just boils down to
> __builtin_bswap which is a constant expression if the input is constant.
> 
> Done via
> 
> $ git ls-files | xargs sed -i -e 's/__constant_cpu_to_be64/htobe64/g'
> $ git ls-files | xargs sed -i -e 's/__cpu_to_be64/htobe64/g'
> $ git ls-files | xargs sed -i -e 's/__be64_to_cpu/be64toh/g'
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  iwpmd/iwarp_pm_common.c   | 5 +++--
>  libibcm/cm.h              | 6 +++---
>  libibcm/examples/cmpost.c | 7 +++----
>  3 files changed, 9 insertions(+), 9 deletions(-)

iwpmd parts look fine.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
