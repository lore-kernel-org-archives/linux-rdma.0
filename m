From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 1/4] IB/core: Add inline function to get sg mr type
Date: Thu, 20 Apr 2017 14:24:15 +0300
Message-ID: <37f3dbe9-77af-181c-0c5d-c35be0f13fa0@grimberg.me>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
 <1492098977-5231-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492098977-5231-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +/**
> + * ib_get_sg_mr_type() - check if the device support arbitrary
> + *                       sg mapping and return a suitable mr type.
> + * @device: The device on which to check support.
> + *
> + * Return: IB_MR_TYPE_SG_GAPS if the device support.
> + *         Otherwise, return IB_MR_TYPE_MEM_REG.
> + */
> +static inline enum ib_mr_type ib_get_sg_mr_type(struct ib_device *device)
> +{
> +	if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> +		return IB_MR_TYPE_SG_GAPS;
> +	else
> +		return IB_MR_TYPE_MEM_REG;
> +
> +}
> +

It does eliminate some code duplication, but will everyone prefer
the GAPS type? I guess they can just not use it, maybe the naming
should reflect that GAPS is preferred? (it doesn't come for free
as the device might need more resources to support GAPS)

Not sure...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
