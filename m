From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING: ODEBUG bug in process_one_req
Date: Thu, 22 Mar 2018 15:47:41 +0100
Message-ID: <CACT4Y+ZEGHp9vg68O7dDfRWj+_bKZQCGQX2AcFckm8GBYaREug@mail.gmail.com>
References: <94eb2c0bc3aa8b2432056623c735@google.com> <20180322124823.GB19440@mtr-leonro.local>
 <CACT4Y+Ya8iMgV=7YGgsO2XnusF9tnGcHHPF5U5oNjQz_eJ+vMw@mail.gmail.com>
 <20180322132031.GC19440@mtr-leonro.local> <CACT4Y+a2KB6vvgFcqkq7cMCiCZQEFNxsCTgP+_gtgju8H2q9hQ@mail.gmail.com>
 <20180322142900.GD19440@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322142900.GD19440@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: syzbot <syzbot+3b4acab09b6463472d0a@syzkaller.appspotmail.com>, danielj@mellanox.com, dledford@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>, Johannes Berg <johannes.berg@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, monis@mellanox.com, Paolo Abeni <pabeni@redhat.com>, parav@mellanox.com, Roland Dreier <roland@purestorage.com>, syzkaller-bugs@googlegroups.com, yuval.shaia@oracle.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 22, 2018 at 3:29 PM, Leon Romanovsky <leonro@mellanox.com> wrote:
> On Thu, Mar 22, 2018 at 02:36:55PM +0100, Dmitry Vyukov wrote:
>> On Thu, Mar 22, 2018 at 2:20 PM, Leon Romanovsky <leonro@mellanox.com> wrote:
>> > On Thu, Mar 22, 2018 at 02:10:21PM +0100, Dmitry Vyukov wrote:
>> >> This bug is actively happening several times per day, if such bug is
>> >> closed syzbot will open another bug on the next crash.
>> >> This bug has a reproducer, why do you think it is invalid?
>> >
>> > I tried to reproduce it on latest rdma-next and failed, so wanted to
>> > start from clean page and see if it is still relevant.
>>
>> Ah,  I see.
>> You can now see the current status on dashboard:
>> https://syzkaller.appspot.com/bug?id=d4ac7bfeafac8a3d6d06123e078462ac765415e7
>> Yes, it still happens.
>>
>> syzbot has already reported another incarnation of this bug, you can
>> see the link to dashboard in the email:
>> https://syzkaller.appspot.com/bug?extid=b8d5eb964e412cfd2678
>> and it contains a link to the first version with reproducer.
>>
>> > Does it still reproduce on latest rdma-next?
>>
>> syzbot does not test rdma-next.
>>
>> But can you reproduce it on upstream tree where syzbot hits it? Just
>> to make sure, you have ODEBUG enabled, right?
>
> Thanks for the tip, I added more debug options and returned to try the
> repro on clean v4.16-rc1, it looks like I still don't have all needed
> config options (SELinux).
>
>   mount(selinuxfs) failed (errno 2)


It seems that you have old syzkaller sources, it now explicitly does
not fail on ENOENT:

    // selinux mount used to be at /selinux, but then moved to /sys/fs/selinux.
    const char* selinux_path = "./syz-tmp/newroot/selinux";
    if (mount("/selinux", selinux_path, NULL, mount_flags, NULL)) {
        if (errno != ENOENT)
            fail("mount(/selinux) failed");
        if (mount("/sys/fs/selinux", selinux_path, NULL, mount_flags,
NULL) && errno != ENOENT)
            fail("mount(/sys/fs/selinux) failed");
    }


> Can you please cancel my email that closes this bug?

There is no such option. The new bug is already created:
https://syzkaller.appspot.com/bug?id=6ecd3fdba0501c8843300056375abea0880816d2
now if we open the old one, we now have 2 for the same root cause. It
will lead to mess.
