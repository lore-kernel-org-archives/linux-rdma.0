From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/13] iWARP wire packet format definition
Date: Thu, 12 Oct 2017 10:16:18 -0400
Message-ID: <0ba0b9f7-d9de-fdb7-e12b-997fed3ea650@intel.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-2-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-2-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/6/2017 8:28 AM, Bernard Metzler wrote:
> +
> +#include <rdma/rdma_user_cm.h>	/* RDMA_MAX_PRIVATE_DATA */
> +#include <linux/types.h>
> +#include <asm/byteorder.h>
> +
> +
> +#define RDMAP_VERSION		1

Please don't use multiple blank lines. I see this in a few places.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
