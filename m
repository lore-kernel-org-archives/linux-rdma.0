From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: KASAN: use-after-free Read in rds_find_bound
Date: Sat, 30 Dec 2017 11:41:48 -0800
Message-ID: <d91da249-5a0f-7a1f-cfd5-68f10f0a2fc1@oracle.com>
References: <089e08231920353a4805618b365c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <089e08231920353a4805618b365c@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+93a5839deb355537440f@syzkaller.appspotmail.com>, linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 12/30/17 1:17 AM, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on 
> fba961ab29e5ffb055592442808bb0f7962e05da
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+93a5839deb355537440f@syzkaller.appspotmail.com

Posted a fix[1] for above issue. Didn't test it but looks straight
forward.

Regards,
Santosh
