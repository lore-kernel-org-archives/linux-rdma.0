From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH rds linux-next v4 0/2] WARNING in rds_message_alloc_sgs
Date: Wed, 19 Dec 2018 10:00:20 -0800
Message-ID: <b31851d2-46e2-b797-e3eb-823bce4d657e@oracle.com>
References: <20181216070109.6758-1-shamir.rabinovitch@oracle.com>
 <20181218.145753.1550590342570044648.davem@davemloft.net>
 <6f6a4be5-99e8-de34-595d-f5b30c61c7ec@oracle.com>
 <20181219105438.GA9593@srabinov-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181219105438.GA9593@srabinov-laptop>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
Cc: David Miller <davem@davemloft.net>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, netdev@vger.kernel.org, gerd.rausch@oracle.com, haakon.bugge@oracle.com
List-Id: linux-rdma@vger.kernel.org

On 12/19/2018 2:54 AM, Shamir Rabinovitch wrote:
> On Tue, Dec 18, 2018 at 03:02:24PM -0800, Santosh Shilimkar wrote:
[...]

>>
>> Shamir, please check if these apply cleanly to Dave's 'net' tree.
>>

> 
> Santosh,
> 
> The patches apply cleanly on the master branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git .
> 
> See below the snippet of the log with the patches applied.
>
> 8472aa4edfcb (HEAD -> net/master#rds-syzbot-bug) net/rds: remove user triggered WARN_ON in rds_sendmsg
> 3f8d6b898c5e net/rds: fix warn in rds_message_alloc_sgs
> 3061169a47ee (net/master) Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
> 78abe3d0dfad net/smc: fix TCP fallback socket release
> f7db2beb4c2c vxge: ensure data0 is initialized in when fetching firmware version information
> 
Great. On patchwork I see the patches marked under review by Dave so
lets wait for his instruction(s).

Regards,
Santosh
