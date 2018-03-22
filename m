From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING: ODEBUG bug in process_one_req
Date: Thu, 22 Mar 2018 14:10:21 +0100
Message-ID: <CACT4Y+Ya8iMgV=7YGgsO2XnusF9tnGcHHPF5U5oNjQz_eJ+vMw@mail.gmail.com>
References: <94eb2c0bc3aa8b2432056623c735@google.com> <20180322124823.GB19440@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322124823.GB19440@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: syzbot <syzbot+3b4acab09b6463472d0a@syzkaller.appspotmail.com>, danielj@mellanox.com, dledford@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>, Johannes Berg <johannes.berg@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, monis@mellanox.com, Paolo Abeni <pabeni@redhat.com>, parav@mellanox.com, roland@purestorage.com, syzkaller-bugs@googlegroups.com, yuval.shaia@oracle.com
List-Id: linux-rdma@vger.kernel.org

This bug is actively happening several times per day, if such bug is
closed syzbot will open another bug on the next crash.
This bug has a reproducer, why do you think it is invalid?
