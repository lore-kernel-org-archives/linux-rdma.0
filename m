From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Allow creation of a Multi-Packet RQ
 using direct verbs
Date: Tue, 21 Nov 2017 10:21:47 +0200
Message-ID: <35930776-52d0-58a3-9b4a-e55b815d87b5@dev.mellanox.co.il>
References: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
 <1511119268-5934-3-git-send-email-yishaih@mellanox.com>
 <20171120190434.GG29075@ziepe.ca> <20171121060504.GO18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121060504.GO18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/21/2017 8:05 AM, Leon Romanovsky wrote:
> On Mon, Nov 20, 2017 at 12:04:34PM -0700, Jason Gunthorpe wrote:
>> On Sun, Nov 19, 2017 at 09:21:08PM +0200, Yishai Hadas wrote:
>>> +	if (mlx5wq_attr) {
>>> +		if (mlx5wq_attr->comp_mask & ~(MLX5DV_WQ_INIT_ATTR_MASK_RESERVED - 1))
>>> +			return -EINVAL;
>>
>> Please no. Check that only the bits this function actually supports
>> are set and get rid of _RESERVED.
> 
> It is classical API mistake do not properly check validity of input parameters [1].
> 

Each new bit that is added in the DV API is supported by the mlx5 driver 
that was compiled with, so there is no validity issue here when checking 
with the _RESERVED value. A case might be when a verb API exposes bits 
that might not be supported by a specific driver.

However, I'm fine with having some internal supported mask and drop the 
RESERVED_ as applications don't really need to see it, will have V1 with 
that change.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
