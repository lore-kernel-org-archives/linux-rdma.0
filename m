From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Sun, 28 Apr 2019 23:49:40 +0000
Message-ID: <20190428234935.GA15233@mellanox.com>
References: <20190428115207.GA11924@ziepe.ca>
 <CAHk-=wj4ay=jy6wuN4d9p9v+O32i0aH9SMfu39VKP-Ai7hKp=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wj4ay=jy6wuN4d9p9v+O32i0aH9SMfu39VKP-Ai7hKp=g@mail.gmail.com>
Content-Language: en-US
Content-ID: <964490D7667EE94E9117C4919E79FD6C@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 28, 2019 at 09:59:56AM -0700, Linus Torvalds wrote:
> On Sun, Apr 28, 2019 at 4:52 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > Nothing particularly special here. There is a small merge conflict
> > with Adrea's mm_still_valid patches which is resolved as below:
>=20
> I still don't understand *why* you play the crazy VM games to begin with.
>=20
> What's wrong with just returning SIGBUS? Why does that
> rdma_umap_fault() not just look like this one-liner:
>=20
>         return VM_FAULT_SIGBUS;
>=20
> without the crazy parts? Nobody ever explained why you'd want to have
> that silly "let's turn it into a bogus anonymous mapping".

There was a big thread where I went over the use case with Andrea, but
I guess that was private..

It is for high availability - we have situations where the hardware
can fault and needs some kind of destructive recovery. For instance a
firmware reboot, or a VM migration.

In these designs there may be multiple cards in the system and the
userspace application could be using both. Just because one card
crashed we can't send SIGBUS and kill the application, that breaks the
HA design.

So.. the kernel makes the BAR VMA into a 'dummy' and sends an async
notification to the application. The use of the BAR memory by
userspace is all 'write only' so it doesn't really care. When it sees
the async notification it safely cleans up the userspace side of
things.

An more modern VM example of where this gets used is on VM systems
using SRIO-V pass through of a raw RDMA device. When it is time to
migrate the VM then the hypervisor causes the SRIO-V instance to fault
and be removed from the guest kernel, then migrates and attaches a new
RDMA SRIO-V instance. The user space is expected to see the failure,
maintain state, then recover onto the new device.

The only alternative that has come up would be to delay the kernel
side until the application cleans up and deletes the VMA, but people
generally don't like this as it degrades the recovery time and has the
usual problems with blocking the kernel on userspace.

When this was created I'm not sure people explored more creative ideas
like trying to handle/ignore the SIGBUS in userspace - unfortunately
it has been so long now that we are probably stuck doing this as part
of the UAPI.

I've been trying to make it less crufty over the last year based on
remarks from yourself and Andrea, but I'm still stuck with this basic
requirement that the VMA shouldn't fault or touch the BAR after the
hardware is released by the kernel.

Thanks,
Jason
