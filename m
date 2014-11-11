From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: FMR Support in multi-function environment
Date: Tue, 11 Nov 2014 08:25:59 +0200
Message-ID: <5461ABF7.7050609@mellanox.com>
References: <CANwwZzU+QzHqjo2wc-_E36E7PQMJhuuBsVW_Ux+JVfM_a+Ydqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANwwZzU+QzHqjo2wc-_E36E7PQMJhuuBsVW_Ux+JVfM_a+Ydqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/10/2014 4:28 PM, Bob Biloxi wrote:
> Suppose a VF driver wants to register large amount of memory using
> FMR, will it be able to do so using the mlx4 code.

no, the proprietary FMRs are not supported for mlx4 VFs, nor for mlx5 
both PF/VFs

>
> Or FMR is supported only in dedicated mode?

use the fast reg API, see for example this commit 5587856 "IB/iser: 
Introduce fast memory registration model (FRWR)" how this is done. The 
API was introduced in commit  00f7ec3 "RDMA/core: Add memory management 
extensions support"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
