From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
Date: Mon, 21 Nov 2016 12:48:35 +0100
Message-ID: <CACT4Y+Y1sL-8K7HhZ5M5ABVPG0kM=dKZh+6gvuNRvzXFtiA5aQ@mail.gmail.com>
References: <1479723531-17940-1-git-send-email-dvyukov@google.com>
 <alpine.LNX.2.00.1611211123450.22752@pobox.suse.cz> <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g@mail.gmail.com>
 <20161121114417.GA4158@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161121114417.GA4158@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: syzkaller <syzkaller@googlegroups.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Valdis.Kletnieks@vt.edu, dledford@redhat.com, sean.hefty@intel.com, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 21, 2016 at 12:44 PM, Leon Romanovsky <leon@kernel.org> wrote:
> On Mon, Nov 21, 2016 at 11:30:21AM +0100, Dmitry Vyukov wrote:
>> On Mon, Nov 21, 2016 at 11:25 AM, Miroslav Benes <mbenes@suse.cz> wrote:
>> > On Mon, 21 Nov 2016, Dmitry Vyukov wrote:
>> >
>> >> WARNINGs mean kernel bugs.
>> >> The one in ucma_write() points to user programming error
>> >> or a malicious attempt. This is not a kernel bug, remove it.
>> >>
>> >> BUG/WARNs that are not kernel bugs hinder automated testing effots.
>> >>
>> >> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
>> >> Cc: Doug Ledford <dledford@redhat.com>
>> >> Cc: Sean Hefty <sean.hefty@intel.com>
>> >> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
>> >> Cc: Leon Romanovsky <leon@kernel.org>
>> >> Cc: linux-rdma@vger.kernel.org
>> >> Cc: linux-kernel@vger.kernel.org
>> >> Cc: syzkaller@googlegroups.com
>> >>
>> >> ---
>> >> Changes since v1:
>> >>  - added printk_once
>> >> ---
>> >>  drivers/infiniband/core/ucma.c | 5 ++++-
>> >>  1 file changed, 4 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
>> >> index 9520154..405d0ce 100644
>> >> --- a/drivers/infiniband/core/ucma.c
>> >> +++ b/drivers/infiniband/core/ucma.c
>> >> @@ -1584,8 +1584,11 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
>> >>       struct rdma_ucm_cmd_hdr hdr;
>> >>       ssize_t ret;
>> >>
>> >> -     if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
>> >> +     if (!ib_safe_file_access(filp)) {
>> >> +             printk_once("ucma_write: process %d (%s) tried to do something hinky\n",
>> >> +                     task_tgid_vnr(current), current->comm);
>> >>               return -EACCES;
>> >> +     }
>> >>
>> >>       if (len < sizeof(hdr))
>> >>               return -EINVAL;
>> >
>> > FWIW, WARN_ON_ONCE came with commit e6bd18f57aad ("IB/security: Restrict
>> > use of the write() interface"). Would it make sense to change the other
>> > places as well?
>>
>>
>> I guess so.
>> Can I ask somebody of infiniband maintainers to take care of this?
>
> Please see below,
> Hope it helps.

In ib_ucm_write function there is a wrong prefix:

+ pr_err_once("ucm_write: process %d (%s) tried to do something hinky\n",

Otherwise looks good. Thanks.
