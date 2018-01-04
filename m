From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in rds_cmsg_rdma_args
Date: Thu, 4 Jan 2018 13:12:29 +0100
Message-ID: <CACT4Y+YT6neaeABo7caFq98VSX+maMpRypY9nYR9jRYAshfX1Q@mail.gmail.com>
References: <001a1144d1c8a6b0cd0561db6999@google.com> <54adea8b-d173-20b2-43cb-fc75d51d74c3@oracle.com>
 <CAP8jf_ApOkxWXDsh6SZtSryqCRiN84bpEMqXUVCFuzYjtZMakQ@mail.gmail.com> <6e5126ea-7a0c-b340-a7aa-aaf73d7953d2@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6e5126ea-7a0c-b340-a7aa-aaf73d7953d2@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Mohamed Ghannam <simo.ghannam@gmail.com>, syzbot <syzbot+ef175b5825285531eabf@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 3, 2018 at 7:55 PM, Santosh Shilimkar
<santosh.shilimkar@oracle.com> wrote:
>
> On 1/3/2018 10:51 AM, Mohamed Ghannam wrote:
>>
>> The fix  : https://patchwork.ozlabs.org/patch/854723/
>
>
> Cool. Thanks Mohamed for following it up.


Since this was submitted without the Reported-by tag, we need to tell
syzbot about the fix separately:

#syz fix: RDS: Heap OOB write in rds_message_alloc_sgs()
