From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 1/4] nvme-rdma: don't suppress send completions
Date: Wed, 22 Nov 2017 17:37:57 +0200
Message-ID: <7ff1ea5a-111a-f914-afe2-3f341cbc8c58@mellanox.com>
References: <20171120113101.8292-1-sagi@grimberg.me>
 <20171120113101.8292-2-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120113101.8292-2-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 11/20/2017 1:30 PM, Sagi Grimberg wrote:
> The entire completions suppress mechanism is currently
> broken because the HCA might retry a send operation
> (due to dropped ack) after the nvme transaction has completed.
> 
> In order to handle this, we signal all send completions (besides
> async event which is not racing anything).
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>   drivers/nvme/host/rdma.c | 46 +++++++++-------------------------------------
>   1 file changed, 9 insertions(+), 37 deletions(-)
> 

Looks good,

Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
