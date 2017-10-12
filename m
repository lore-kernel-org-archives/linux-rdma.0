From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and RDMA
 subsystem
Date: Thu, 12 Oct 2017 10:33:17 -0400
Message-ID: <1c8604f8-7c31-4030-4a2e-574cd5049dbb@intel.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-4-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/6/2017 8:28 AM, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> +static bool loopback_enabled = 1;
> +module_param(loopback_enabled, bool, 0644);
> +MODULE_PARM_DESC(loopback_enabled, "enable_loopback");
> +
> +LIST_HEAD(siw_devlist);

Pretty much everyone here hates module parameters and you will get push 
back on principal, but this is an example of why they are bad. The 
siw_devlist shows you expect to have multiple devices, which is fine and 
of course makes sense. However, the module parameter is driver wide. 
This means you can not have one device in loopback mode while the other 
isn't.

> +
> +	strcpy(ofa_dev->name, SIW_IBDEV_PREFIX);
> +	strlcpy(ofa_dev->name + strlen(SIW_IBDEV_PREFIX), netdev->name,
> +		IB_DEVICE_NAME_MAX - strlen(SIW_IBDEV_PREFIX));

I'd encourage you to use the likes of strncpy and friends.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
