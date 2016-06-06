From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 1/2] IB/core: Fix bit curruption in
 ib_device_cap_flags structure
Date: Mon, 6 Jun 2016 10:03:50 -0700
Message-ID: <20160606170350.GA28622@infradead.org>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
 <1465230880-25953-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465230880-25953-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 06, 2016 at 07:34:39PM +0300, Max Gurtovoy wrote:
> ib_device_cap_flags 64-bit expansion caused caps overlapping
> and made consumers read wrong device capabilities. For example
> IB_DEVICE_SG_GAPS_REG was falsely read by the iser driver causing
> it to use a non-existing capability. This happened because signed
> int becomes sign extended when converted it to u64. Fix this by
> casting IB_DEVICE_ON_DEMAND_PAGING enumeration to ULL.

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
