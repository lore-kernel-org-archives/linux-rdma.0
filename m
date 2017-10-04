From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 rdma-next 17/18] IB/core: Define 'ib' and 'roce'
 rdma_ah_attr types
Date: Wed, 4 Oct 2017 15:15:20 -0700
Message-ID: <73561590-0d5e-54ba-a98a-d8c45f869955@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1493491290-31621-18-git-send-email-dasaratharaman.chandramouli@intel.com>
 <VI1PR0502MB30083D21E466C23698A93228D1730@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB30083D21E466C23698A93228D1730-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 10/4/2017 2:24 PM, Parav Pandit wrote:
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dasaratharaman Chandramouli
>> Sent: Saturday, April 29, 2017 1:41 PM
>> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Subject: [PATCH v4 rdma-next 17/18] IB/core: Define 'ib' and 'roce'
>> rdma_ah_attr types
>> +/*Get AH type */
>> +static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device
>> *dev,
>> +						       u32 port_num)
>> +{
>> +	if ((rdma_protocol_roce(dev, port_num)) ||
>> +	    (rdma_protocol_iwarp(dev, port_num)))
>> +		return RDMA_AH_ATTR_TYPE_ROCE;
> Check for iWarp to define AH attribute type as RoCE appears error to me.
> Taking quick look at i40iw and nes drivers appears to return -ENOSYS for i40iw_create_ah(), nes_create_ah.
> Will you please submit a fix that avoids above iWarp check?
>
>
i40iw_port_immutable sets the RDMA_CORE_PORT_IWARP immutable flag, hence 
the check. Are you having an issue?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
