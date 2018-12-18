From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH rds linux-next v4 0/2] WARNING in rds_message_alloc_sgs
Date: Tue, 18 Dec 2018 15:02:24 -0800
Message-ID: <6f6a4be5-99e8-de34-595d-f5b30c61c7ec@oracle.com>
References: <20181216070109.6758-1-shamir.rabinovitch@oracle.com>
 <20181218.145753.1550590342570044648.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181218.145753.1550590342570044648.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, shamir.rabinovitch@oracle.com
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, netdev@vger.kernel.org, gerd.rausch@oracle.com, haakon.bugge@oracle.com
List-Id: linux-rdma@vger.kernel.org

On 12/18/2018 2:57 PM, David Miller wrote:
> From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
> Date: Sun, 16 Dec 2018 09:01:07 +0200
> 
>> From: shamir rabinovitch <shamir.rabinovitch@oracle.com>
>>
>> This patch set fix google syzbot rds bug found in linux-next.
>> The first patch solve the syzbot issue.
>> The second patch fix issue mentioned by Leon Romanovsky that
>> drivers should not call WARN_ON as result from user input.
>>
>> syzbot bug report can be foud here: https://lkml.org/lkml/2018/10/31/28
>>
>> v1->v2:
>> - patch 1: make rds_iov_vector fields name more descriptive (Hakon)
>> - patch 1: fix potential mem leak in rds_rm_size if krealloc fail
>>    (Hakon)
>> v2->v3:
>> - patch 2: harden rds_sendmsg for invalid number of sgs (Gerd)
>> v3->v4
>> - Santosh a.b. on both patches + repost to net-dev
> 
> Does this bug exist in 'net' too?  It really should target the 'net'
> tree if so, and then we can queue these fixes up for -stable too.
> 
yes, the bug exist in net too.

Shamir, please check if these apply cleanly to Dave's 'net' tree.

Regards,
Santosh
