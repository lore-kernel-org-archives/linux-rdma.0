From: Devesh Sharma via Qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [RFC 0/3] VirtIO RDMA
Date: Fri, 12 Apr 2019 15:21:56 +0530
Message-ID: <CANjDDBj0rqZEmHzMH+2461_DvjV5K4hT=hJ_usBuucV4Xwh84g@mail.gmail.com>
References: <20190411110157.14252-1-yuval.shaia@oracle.com>
	<20190411190215.2163572e.cohuck@redhat.com>
	<20190411172402.GA14509@mellanox.com>
	<20190411173419.GB6259@lap1> <20190411174124.GA6428@lap1>
Reply-To: Devesh Sharma <devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
In-Reply-To: <20190411174124.GA6428@lap1>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org
Sender: "Qemu-devel"
	<qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: "mst@redhat.com" <mst@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 11, 2019 at 11:11 PM Yuval Shaia <yuval.shaia@oracle.com> wrote:
>
> On Thu, Apr 11, 2019 at 08:34:20PM +0300, Yuval Shaia wrote:
> > On Thu, Apr 11, 2019 at 05:24:08PM +0000, Jason Gunthorpe wrote:
> > > On Thu, Apr 11, 2019 at 07:02:15PM +0200, Cornelia Huck wrote:
> > > > On Thu, 11 Apr 2019 14:01:54 +0300
> > > > Yuval Shaia <yuval.shaia@oracle.com> wrote:
> > > >
> > > > > Data center backends use more and more RDMA or RoCE devices and more and
> > > > > more software runs in virtualized environment.
> > > > > There is a need for a standard to enable RDMA/RoCE on Virtual Machines.
> > > > >
> > > > > Virtio is the optimal solution since is the de-facto para-virtualizaton
> > > > > technology and also because the Virtio specification
> > > > > allows Hardware Vendors to support Virtio protocol natively in order to
> > > > > achieve bare metal performance.
> > > > >
> > > > > This RFC is an effort to addresses challenges in defining the RDMA/RoCE
> > > > > Virtio Specification and a look forward on possible implementation
> > > > > techniques.
> > > > >
> > > > > Open issues/Todo list:
> > > > > List is huge, this is only start point of the project.
> > > > > Anyway, here is one example of item in the list:
> > > > > - Multi VirtQ: Every QP has two rings and every CQ has one. This means that
> > > > >   in order to support for example 32K QPs we will need 64K VirtQ. Not sure
> > > > >   that this is reasonable so one option is to have one for all and
> > > > >   multiplex the traffic on it. This is not good approach as by design it
> > > > >   introducing an optional starvation. Another approach would be multi
> > > > >   queues and round-robin (for example) between them.
> > > > >
> > > > > Expectations from this posting:
> > > > > In general, any comment is welcome, starting from hey, drop this as it is a
> > > > > very bad idea, to yeah, go ahead, we really want it.
> > > > > Idea here is that since it is not a minor effort i first want to know if
> > > > > there is some sort interest in the community for such device.
> > > >
> > > > My first reaction is: Sounds sensible, but it would be good to have a
> > > > spec for this :)
> > >
> > > I'm unclear why you'd want to have a virtio queue for anything other
> > > that some kind of command channel.
> > >
> > > I'm not sure a QP or CQ benefits from this??
> >
> > Virtqueue is a standard mechanism to pass data from guest to host. By
>
> And vice versa (CQ?)
>
> > saying that - it really sounds like QP send and recv rings. So my thought
> > is to use a standard way for rings. As i've learned this is how it is used
> > by other virtio devices ex virtio-net.
> >
> > >
> > > Jason
> >
I would like to ask more basic question, how virtio queue will glue
with actual h/w qps? I may be to naive though.

-Regards
Devesh
