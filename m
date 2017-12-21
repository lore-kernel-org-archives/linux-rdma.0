From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: KASAN: stack-out-of-bounds Read in rds_sendmsg
Date: Thu, 21 Dec 2017 08:44:32 -0800
Message-ID: <9deaf3c4-227f-f6f0-9ccb-3ad05fc32a0c@oracle.com>
References: <089e08263e589121d90560d610a5@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <089e08263e589121d90560d610a5@google.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: syzkaller-bugs@googlegroups.com, Avinash Repaka <avinash.repaka@oracle.com>
Cc: syzbot <bot+9461c9b9d340854a404b46c42cbfc91ded1232d8@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

+Avinash

On 12/21/2017 1:10 AM, syzbot wrote:
> syzkaller has found reproducer for the following crash on 

[..]

> 
> audit: type=1400 audit(1513847224.110:7): avc:  denied  { map } for  
> pid=3157 comm="syzkaller455006" path="/root/syzkaller455006870" 
> dev="sda1" ino=16481 
> scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023 
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in rds_rdma_bytes net/rds/send.c:1013 
> [inline]

Could you please post the discussed fix if you are ready with it ?
This new report is same as last one and cmesg length check should
address it.

Regards,
Santosh
