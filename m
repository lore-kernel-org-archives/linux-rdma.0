From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Tue, 30 Apr 2019 12:53:16 +0000
Message-ID: <20190430125310.GH3562@mellanox.com>
References: <20190428115207.GA11924@ziepe.ca>
 <CAHk-=wj4ay=jy6wuN4d9p9v+O32i0aH9SMfu39VKP-Ai7hKp=g@mail.gmail.com>
 <20190428234935.GA15233@mellanox.com>
 <CAHk-=whWh+5-jGmgw2HPM8XhzXzvGcLo19UGLtqYe_teJsRgRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whWh+5-jGmgw2HPM8XhzXzvGcLo19UGLtqYe_teJsRgRA@mail.gmail.com>
Content-Language: en-US
Content-ID: <550815CEF2E54F45B18ADB0FA7963199@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 28, 2019 at 05:09:08PM -0700, Linus Torvalds wrote:
> On Sun, Apr 28, 2019 at 4:49 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > It is for high availability - we have situations where the hardware
> > can fault and needs some kind of destructive recovery. For instance a
> > firmware reboot, or a VM migration.
> >
> > In these designs there may be multiple cards in the system and the
> > userspace application could be using both. Just because one card
> > crashed we can't send SIGBUS and kill the application, that breaks the
> > HA design.
>=20
> Why can't this magical application that is *so* special that it is HA
> and does magic mmap's of special rdma areas just catch the SIGBUS?
>=20
> Honestly, the whole "it's for HA" excuse stinks. It stinks because you
> now silently just replace the mapping with *garbage*. That's not HA,
> that's just random.

This should only used in cases where user space only writes to the BAR
page (it is an interrupt to the device essentially), so it doesn't
care that the pages are now garbage, we just need to redirect the
writes away from the bar.

However I think someone later on added a readable counter BAR pages to
one of the devices :( So even that ideal wasn't respected.

> Wouldn't it be a lot better to just get the SIGBUS, and then that
> magical application knows that "oh, it's gone", and it could - in its
> SIGBUS handler - just do the dummy anonymous mmap() with /dev/zero it
> if it wants to?

This does sound more appealing, and probably should have been done
instead. All this VMA stuff has been a big pain in the long run

Thanks,
Jason
