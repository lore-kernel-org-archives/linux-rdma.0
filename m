From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Allow creation of a Multi-Packet RQ
 using direct verbs
Date: Tue, 21 Nov 2017 14:01:33 +0200
Message-ID: <f164e1c4-e3b2-8778-448e-1fb0da6e6dc1@dev.mellanox.co.il>
References: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
 <1511119268-5934-3-git-send-email-yishaih@mellanox.com>
 <20171120190434.GG29075@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120190434.GG29075-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/20/2017 9:04 PM, Jason Gunthorpe wrote:
> On Sun, Nov 19, 2017 at 09:21:08PM +0200, Yishai Hadas wrote:
>> +	if (mlx5wq_attr) {
>> +		if (mlx5wq_attr->comp_mask & ~(MLX5DV_WQ_INIT_ATTR_MASK_RESERVED - 1))
>> +			return -EINVAL;
> 
> Please no. Check that only the bits this function actually supports
> are set and get rid of _RESERVED.
> 

OK, PR was updated accordingly:
https://github.com/linux-rdma/rdma-core/pull/257

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
