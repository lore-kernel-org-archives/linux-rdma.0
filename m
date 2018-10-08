From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: WARNING in __put_task_struct (2)
Date: Mon, 8 Oct 2018 13:45:13 -0600
Message-ID: <20181008194513.GC27639@ziepe.ca>
References: <000000000000b3d5610577b9e12c@google.com>
 <CACT4Y+bfqk8Fczw4dJHhVzM63YhYNSovEE-KygZ1XmgUQVGCWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+bfqk8Fczw4dJHhVzM63YhYNSovEE-KygZ1XmgUQVGCWQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com>, dledford@redhat.com, Leon Romanovsky <leon@kernel.org>, swise@opengridcomputing.com, markb@mellanox.com, linux-rdma@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, guro@fb.com, Kees Cook <keescook@chromium.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, marcos.souza.org@gmail.com, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Will Drewry <wad@chromium.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 08, 2018 at 06:15:22PM +0200, Dmitry Vyukov wrote:
> On Mon, Oct 8, 2018 at 6:12 PM, syzbot
> <syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com> wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    ae16eea39a86 Add linux-next specific files for 20181008
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12e7c6a1400000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=42525ce985d1a955
> > dashboard link: https://syzkaller.appspot.com/bug?extid=1ed9dfaa984c88cf0ef8
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+1ed9dfaa984c88cf0ef8@syzkaller.appspotmail.com
> 
> 
> This was triggered by the following program, all is rdma-related, so
> +rdma maintainers.
> 
> 10:27:26 executing program 5:
> r0 = openat$rdma_cm(0xffffffffffffff9c,
> &(0x7f0000000380)='/dev/infiniband/rdma_cm\x00', 0x2, 0x0)
> write$RDMA_USER_CM_CMD_CREATE_ID(r0, &(0x7f0000000080)={0x0, 0x18,
> 0xfa00, {0x0, &(0x7f0000000040)={<r1=>0xffffffffffffffff}, 0x13f}},
> 0x12d)
> write$RDMA_USER_CM_CMD_RESOLVE_IP(r0, &(0x7f0000000200)={0x3, 0x40,
> 0xfa00, {{0xa, 0x4e21}, {0xa, 0x0, 0x0, @mcast1}, r1}}, 0x48)
> write$RDMA_USER_CM_CMD_CREATE_ID(r0, &(0x7f0000000340)={0x0, 0x18,
> 0xfa00, {0x0, &(0x7f0000000300)={<r2=>0xffffffffffffffff}, 0x13f}},
> 0x20)
> write$RDMA_USER_CM_CMD_SET_OPTION(r0, &(0x7f00000002c0)={0xe, 0x18,
> 0xfa00, @id_afonly={&(0x7f0000000000)=0x1, r1, 0x0, 0x2, 0x4}}, 0x20)
> write$RDMA_USER_CM_CMD_RESOLVE_IP(r0, &(0x7f0000000100)={0x3, 0x40,
> 0xfa00, {{0x2, 0x4e21}, {0xa, 0x0, 0x0, @local}, r2}}, 0x1ff)
> write$RDMA_USER_CM_CMD_DESTROY_ID(r0, &(0x7f0000000180)={0x1, 0x10,
> 0xfa00, {&(0x7f00000000c0), r2}}, 0x18)

This might be fixed in Linux-next now by this commit:

Author: Leon Romanovsky <leonro@mellanox.com>
Date:   Tue Oct 2 11:48:03 2018 +0300

    RDMA/restrack: Release task struct which was hold by CM_ID object
   

Jason
