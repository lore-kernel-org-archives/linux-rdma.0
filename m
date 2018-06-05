From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH V4] mlx4_core: allocate ICM memory in page size chunks
Date: Tue, 5 Jun 2018 11:51:18 -0700
Message-ID: <b98a1c85-242c-d9da-3d51-d4c8829e257b@oracle.com>
References: <7a353b65-6b7f-1aee-1c48-e83c8e02f693@gmail.com>
 <0e11e0fc-6ccf-aa93-9c4f-b9eae1b90643@gmail.com>
 <cdf0d1a9-378a-8b09-544e-a4918acb57fe@gmail.com>
 <20180531065405.GH15278@dhcp22.suse.cz>
 <ae114f01-4b09-bb1c-fb92-6152486a896f@gmail.com>
 <20180531085532.GK15278@dhcp22.suse.cz>
 <20180531091022.GL15278@dhcp22.suse.cz>
 <7d8f52e1-aa16-d20c-a9a8-35ad88c0b1ab@oracle.com>
 <20180601073137.GV15278@dhcp22.suse.cz>
 <f0bfa913-1837-6c5d-6e77-2a188fd094e1@oracle.com>
 <20180604062737.GA19202@dhcp22.suse.cz>
 <c67934a5-8858-0de7-a7b5-532d14b5c881@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c67934a5-8858-0de7-a7b5-532d14b5c881@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>, tariqt@mellanox.com, haakon.bugge@oracle.com, yanjun.zhu@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com, "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>, rama nichanamatlu <rama.nichanamatlu@oracle.com>
List-Id: linux-rdma@vger.kernel.org



On 6/4/2018 5:40 AM, Vlastimil Babka wrote:
> On 06/04/2018 08:27 AM, Michal Hocko wrote:
>> On Fri 01-06-18 15:05:26, Qing Huang wrote:
>>>
>>> On 6/1/2018 12:31 AM, Michal Hocko wrote:
>>>> On Thu 31-05-18 19:04:46, Qing Huang wrote:
>>>>> On 5/31/2018 2:10 AM, Michal Hocko wrote:
>>>>>> On Thu 31-05-18 10:55:32, Michal Hocko wrote:
>>>>>>> On Thu 31-05-18 04:35:31, Eric Dumazet wrote:
>>>>>> [...]
>>>>>>>> I merely copied/pasted from alloc_skb_with_frags() :/
>>>>>>> I will have a look at it. Thanks!
>>>>>> OK, so this is an example of an incremental development ;).
>>>>>>
>>>>>> __GFP_NORETRY was added by ed98df3361f0 ("net: use __GFP_NORETRY for
>>>>>> high order allocations") to prevent from OOM killer. Yet this was
>>>>>> not enough because fb05e7a89f50 ("net: don't wait for order-3 page
>>>>>> allocation") didn't want an excessive reclaim for non-costly orders
>>>>>> so it made it completely NOWAIT while it preserved __GFP_NORETRY in
>>>>>> place which is now redundant. Should I send a patch?
>>>>>>
>>>>> Just curious, how about GFP_ATOMIC flag? Would it work in a similar fashion?
>>>>> We experimented
>>>>> with it a bit in the past but it seemed to cause other issue in our tests.
>>>>> :-)
>>>> GFP_ATOMIC is a non-sleeping (aka no reclaim) context with an access to
>>>> memory reserves. So the risk is that you deplete those reserves and
>>>> cause issues to other subsystems which need them as well.
>>>>
>>>>> By the way, we didn't encounter any OOM killer events. It seemed that the
>>>>> mlx4_alloc_icm() triggered slowpath.
>>>>> We still had about 2GB free memory while it was highly fragmented.
>>>> The compaction was able to make a reasonable forward progress for you.
>>>> But considering mlx4_alloc_icm is called with GFP_KERNEL resp. GFP_HIGHUSER
>>>> then the OOM killer is clearly possible as long as the order is lower
>>>> than 4.
>>> The allocation was 256KB so the order was much higher than 4. The compaction
>>> seemed to be the root
>>> cause for our problem. It took too long to finish its work while putting
>>> mlx4_alloc_icm to sleep in a heavily
>>> fragmented memory situation . Will NORETRY flag avoid the compaction ops and
>>> fail the 256KB allocation
>>> immediately so mlx4_alloc_icm can enter adjustable lower order allocation
>>> code path quickly?
>> Costly orders should only perform a light compaction attempt unless
>> __GFP_RETRY_MAY_FAIL is used IIRC. CCing Vlastimil. So __GFP_NORETRY
>> shouldn't make any difference.
> It's a bit more complicated. Costly allocations will try the light
> compaction attempt first, even before reclaim. This is followed by
> reclaim and a more costly compaction attempt. With __GFP_NORETRY, the
> second compaction attempt is also only the light one, so the flag does
> make a difference here.

Thanks for the clarification!

Looks like our production kernel is kinda old, neither 
__GFP_DIRECT_RECLAIM nor __GFP_NORETRY
has been used in __alloc_pages_slowpath() in our kernel.
