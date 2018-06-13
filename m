From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: KASAN: use-after-free Read in rds_cong_queue_updates
Date: Wed, 13 Jun 2018 00:54:14 -0700
Message-ID: <c1078f20-b8ea-7efe-8b39-0c75fd598e1d@oracle.com>
References: <089e08e548431cd0f90565c9f4e5@google.com>
 <000000000000a643e4056e7d0db4@google.com>
 <CACT4Y+b+DFpa34E3UWzSYn6qy-BMmxN80ikdmU_xMe9x9JF2+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+b+DFpa34E3UWzSYn6qy-BMmxN80ikdmU_xMe9x9JF2+Q@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>, syzbot <syzbot+4c20b3866171ce8441d2@syzkaller.appspotmail.com>
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-rdma@vger.kernel.org



On 6/13/18 12:51 AM, Dmitry Vyukov wrote:
> On Wed, Jun 13, 2018 at 4:51 AM, syzbot
> <syzbot+4c20b3866171ce8441d2@syzkaller.appspotmail.com> wrote:
>> syzbot has found a reproducer for the following crash on:
> 
> Woohoo! Please take a look, this is a top crasher.
> 
Will have a look Dmitry !!
