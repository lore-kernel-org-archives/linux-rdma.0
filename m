From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 2/2] rdma: Print net device name and index
 for RDMA device
Date: Mon, 26 Mar 2018 09:44:32 -0600
Message-ID: <5f7e480c-dfa5-f246-cb3a-0264128640cf@gmail.com>
References: <20180326082829.21214-1-leon@kernel.org>
 <20180326082829.21214-3-leon@kernel.org>
 <7b6f0370-4749-5327-5701-6567587d2044@gmail.com>
 <20180326150933.GI1877@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326150933.GI1877@mtr-leonro.local>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 3/26/18 9:09 AM, Leon Romanovsky wrote:
> On Mon, Mar 26, 2018 at 08:06:52AM -0600, David Ahern wrote:
>> On 3/26/18 2:28 AM, Leon Romanovsky wrote:
>>> diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
>>> index 9446a721..45474f13 100644
>>> --- a/rdma/include/uapi/rdma/rdma_netlink.h
>>> +++ b/rdma/include/uapi/rdma/rdma_netlink.h
>>> @@ -388,6 +388,10 @@ enum rdma_nldev_attr {
>>>  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
>>>  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
>>>
>>> +	/* Netdev information for relevant protocols, like RoCE and iWARP */
>>> +	RDMA_NLDEV_ATTR_NDEV_INDEX,		/* u32 */
>>> +	RDMA_NLDEV_ATTR_NDEV_NAME,		/* string */
>>> +
>>>  	RDMA_NLDEV_ATTR_MAX
>>>  };
>>>  #endif /* _RDMA_NETLINK_H */
>>
>> Why wasn't the above included in patch 1 as part of the header file update?
>>
>>
> 
> Kernel part is not accepted yet, this is why I separated them.
>
Please don't mix patches in a set like this. The entire set should be
consistent -- either all of them are in the kernel or all of them are
waiting to be committed.
