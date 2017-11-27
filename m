From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: general protection fault in __rds_rdma_map
Date: Mon, 27 Nov 2017 12:39:51 -0800
Message-ID: <b33496ee-b34b-3529-4d2f-1d7f13d09b20@oracle.com>
References: <001a113f98d6216a60055efb17da@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a113f98d6216a60055efb17da@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 11/27/2017 10:30 AM, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on 
> e1d1ea549b57790a3d8cf6300e6ef86118d692a3
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See 
> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_kgGztJ&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=hWpFvp_cTkkwMMULcvbV65orOO9Gv3OUaY0ATWhQwak&m=0pw38xYdDB2QuLTkc6b0N3240iyzMU13jwFZvLaxDSo&s=0kx55ufXFnBORomS71r4MtXomSqMRKhkHI1tGM3oPic&e= 
> 
> for information about syzkaller reproducers
> 
> 
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> RDS: rds_bind could not find a transport for 224.0.0.2, load rds_tcp or 
> rds_rdma?

Seems like the RDMA operation got triggered on the non RDMA transport
lead to non populated rs->rs_transport->get_mr(). Also seems like the
tests was running in the namespace and the RDMA transport doesn't
yet support it. Thanks for reporting. Will look into fix internally.

Regards,
Santosh
