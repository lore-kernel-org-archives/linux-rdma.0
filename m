From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in __put_task_struct (2)
Date: Wed, 10 Oct 2018 15:01:11 +0200
Message-ID: <CACT4Y+ZH946wZ5UxZp=zmRF7eJxOtAB5z6aBSAOuowWhHh3Fgw@mail.gmail.com>
References: <000000000000b3d5610577b9e12c@google.com> <CACT4Y+bfqk8Fczw4dJHhVzM63YhYNSovEE-KygZ1XmgUQVGCWQ@mail.gmail.com>
 <20181008194513.GC27639@ziepe.ca> <20181009113000.GC4105@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009113000.GC4105@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, syzbot <syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com>, dledford@redhat.com, swise@opengridcomputing.com, markb@mellanox.com, linux-rdma@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, guro@fb.com, Kees Cook <keescook@chromium.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Marcos Souza <marcos.souza.org@gmail.com>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Will Drewry <wad@chromium.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 9, 2018 at 1:30 PM, Leon Romanovsky <leon@kernel.org> wrote:
> On Mon, Oct 08, 2018 at 01:45:13PM -0600, Jason Gunthorpe wrote:
>> On Mon, Oct 08, 2018 at 06:15:22PM +0200, Dmitry Vyukov wrote:
>> > On Mon, Oct 8, 2018 at 6:12 PM, syzbot
>> > <syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com> wrote:
>> > > Hello,
>> > >
>> > > syzbot found the following crash on:
>> > >
>> > > HEAD commit:    ae16eea39a86 Add linux-next specific files for 20181008
>> > > git tree:       linux-next
>> > > console output: https://syzkaller.appspot.com/x/log.txt?x=12e7c6a1400000
>> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=42525ce985d1a955
>> > > dashboard link: https://syzkaller.appspot.com/bug?extid=1ed9dfaa984c88cf0ef8
>> > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>> > >
>> > > Unfortunately, I don't have any reproducer for this crash yet.
>> > >
>> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> > > Reported-by: syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com
>> >
>> >
>> > This was triggered by the following program, all is rdma-related, so
>> > +rdma maintainers.
>> >
>> > 10:27:26 executing program 5:
>> > r0 = openat$rdma_cm(0xffffffffffffff9c,
>> > &(0x7f0000000380)='/dev/infiniband/rdma_cm\x00', 0x2, 0x0)
>> > write$RDMA_USER_CM_CMD_CREATE_ID(r0, &(0x7f0000000080)={0x0, 0x18,
>> > 0xfa00, {0x0, &(0x7f0000000040)={<r1=>0xffffffffffffffff}, 0x13f}},
>> > 0x12d)
>> > write$RDMA_USER_CM_CMD_RESOLVE_IP(r0, &(0x7f0000000200)={0x3, 0x40,
>> > 0xfa00, {{0xa, 0x4e21}, {0xa, 0x0, 0x0, @mcast1}, r1}}, 0x48)
>> > write$RDMA_USER_CM_CMD_CREATE_ID(r0, &(0x7f0000000340)={0x0, 0x18,
>> > 0xfa00, {0x0, &(0x7f0000000300)={<r2=>0xffffffffffffffff}, 0x13f}},
>> > 0x20)
>> > write$RDMA_USER_CM_CMD_SET_OPTION(r0, &(0x7f00000002c0)={0xe, 0x18,
>> > 0xfa00, @id_afonly={&(0x7f0000000000)=0x1, r1, 0x0, 0x2, 0x4}}, 0x20)
>> > write$RDMA_USER_CM_CMD_RESOLVE_IP(r0, &(0x7f0000000100)={0x3, 0x40,
>> > 0xfa00, {{0x2, 0x4e21}, {0xa, 0x0, 0x0, @local}, r2}}, 0x1ff)
>> > write$RDMA_USER_CM_CMD_DESTROY_ID(r0, &(0x7f0000000180)={0x1, 0x10,
>> > 0xfa00, {&(0x7f00000000c0), r2}}, 0x18)
>>
>> This might be fixed in Linux-next now by this commit:
>>
>> Author: Leon Romanovsky <leonro@mellanox.com>
>> Date:   Tue Oct 2 11:48:03 2018 +0300
>>
>>     RDMA/restrack: Release task struct which was hold by CM_ID object
>
> Jason,
>
> I afraid that the opposite it more accurate.
>
> This issue was introduced by that commit and According to linux-next
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next-history.git/tag/?h=next-20181008
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next-history.git/commit/?h=next-20181008&id=ae16eea39a86735f4ed0b5a6e9fe43c6cedb13b3
> The RDMA tree has commit ed7a01fd3fd77f40b4ef2562b966a5decd8928d2,
> which is exactly the one you cited above.
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=for-next&id=ed7a01fd3fd77f40b4ef2562b966a5decd8928d2
>
> Any ideas how?

I marked another bug as dup of this because it looks like the same root cause:
https://syzkaller.appspot.com/bug?id=e1854417677586ce3d00f498f19816cb4fd15676
And that dup bug has a C reproducer.
