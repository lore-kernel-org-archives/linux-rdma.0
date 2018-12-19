From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH rds linux-next v4 0/2] WARNING in rds_message_alloc_sgs
Date: Wed, 19 Dec 2018 10:22:04 -0800 (PST)
Message-ID: <20181219.102204.419537206783531284.davem@davemloft.net>
References: <6f6a4be5-99e8-de34-595d-f5b30c61c7ec@oracle.com>
        <20181219105438.GA9593@srabinov-laptop>
        <b31851d2-46e2-b797-e3eb-823bce4d657e@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <b31851d2-46e2-b797-e3eb-823bce4d657e@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com
Cc: shamir.rabinovitch@oracle.com, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, netdev@vger.kernel.org, gerd.rausch@oracle.com, haakon.bugge@oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Date: Wed, 19 Dec 2018 10:00:20 -0800

> On 12/19/2018 2:54 AM, Shamir Rabinovitch wrote:
>> On Tue, Dec 18, 2018 at 03:02:24PM -0800, Santosh Shilimkar wrote:
> [...]
> 
>>>
>>> Shamir, please check if these apply cleanly to Dave's 'net' tree.
>>>
> 
>> Santosh,
>> The patches apply cleanly on the master branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git .
>> See below the snippet of the log with the patches applied.
>>
>> 8472aa4edfcb (HEAD -> net/master#rds-syzbot-bug) net/rds: remove user
>> triggered WARN_ON in rds_sendmsg
>> 3f8d6b898c5e net/rds: fix warn in rds_message_alloc_sgs
>> 3061169a47ee (net/master) Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
>> 78abe3d0dfad net/smc: fix TCP fallback socket release
>> f7db2beb4c2c vxge: ensure data0 is initialized in when fetching
>> firmware version information
>> 
> Great. On patchwork I see the patches marked under review by Dave so
> lets wait for his instruction(s).

Since they apply cleanly to 'net' I'll apply them directly and queue up
for -stable.

Thanks for checking.
