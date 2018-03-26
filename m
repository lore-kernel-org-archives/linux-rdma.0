From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH iproute2-next] rdma: Move RDMA UAPI header file to be
 under RDMA responsibility
Date: Mon, 26 Mar 2018 09:23:46 -0500
Message-ID: <6a187694-654d-02f8-49fe-98704839de1f@opengridcomputing.com>
References: <20180325063856.31709-1-leon@kernel.org>
 <c1cd4d27-dce6-84d0-344d-86ff7223add8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c1cd4d27-dce6-84d0-344d-86ff7223add8@gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org



On 3/26/2018 9:03 AM, David Ahern wrote:
> On 3/25/18 12:38 AM, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@mellanox.com>
>>
>> In iproute2 package, the updates of UAPIs files are performed
>> after the needed feature lands in kernel's net-next tree.
>>
>> Such development flow created delays to the rdma tool developers,
>> who uses rdma-next tree as a basis for their work.
>>
>> Move RDMA UAPI file to be under rdma/ folder, so whole responsibility
>> of syncing this file will be on them.
>>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>> ---
>>  rdma/Makefile                                      | 1 +
>>  {include => rdma/include}/uapi/rdma/rdma_netlink.h | 0
>>  2 files changed, 1 insertion(+)
>>  rename {include => rdma/include}/uapi/rdma/rdma_netlink.h (100%)
> applied to iproute2-next
>

Hey Leon, so how do I change rdma/include/uapi/rdma_netlink.h now for my
series [1]?  Do I just make the changes?  Or is there some other process?

[1] https://www.spinics.net/lists/linux-rdma/msg61419.html

Steve.
