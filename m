From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [RFC 0/3] VirtIO RDMA
Date: Thu, 11 Apr 2019 17:24:08 +0000
Message-ID: <20190411172402.GA14509@mellanox.com>
References: <20190411110157.14252-1-yuval.shaia@oracle.com>
	<20190411190215.2163572e.cohuck@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
In-Reply-To: <20190411190215.2163572e.cohuck@redhat.com>
Content-Language: en-US
Content-ID: <D48BEB556881BA44BDF61657FE88A114@eurprd05.prod.outlook.com>
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
To: Cornelia Huck <cohuck@redhat.com>
Cc: "mst@redhat.com" <mst@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Yuval Shaia <yuval.shaia@oracle.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 11, 2019 at 07:02:15PM +0200, Cornelia Huck wrote:
> On Thu, 11 Apr 2019 14:01:54 +0300
> Yuval Shaia <yuval.shaia@oracle.com> wrote:
>=20
> > Data center backends use more and more RDMA or RoCE devices and more an=
d
> > more software runs in virtualized environment.
> > There is a need for a standard to enable RDMA/RoCE on Virtual Machines.
> >=20
> > Virtio is the optimal solution since is the de-facto para-virtualizaton
> > technology and also because the Virtio specification
> > allows Hardware Vendors to support Virtio protocol natively in order to
> > achieve bare metal performance.
> >=20
> > This RFC is an effort to addresses challenges in defining the RDMA/RoCE
> > Virtio Specification and a look forward on possible implementation
> > techniques.
> >=20
> > Open issues/Todo list:
> > List is huge, this is only start point of the project.
> > Anyway, here is one example of item in the list:
> > - Multi VirtQ: Every QP has two rings and every CQ has one. This means =
that
> >   in order to support for example 32K QPs we will need 64K VirtQ. Not s=
ure
> >   that this is reasonable so one option is to have one for all and
> >   multiplex the traffic on it. This is not good approach as by design i=
t
> >   introducing an optional starvation. Another approach would be multi
> >   queues and round-robin (for example) between them.
> >=20
> > Expectations from this posting:
> > In general, any comment is welcome, starting from hey, drop this as it =
is a
> > very bad idea, to yeah, go ahead, we really want it.
> > Idea here is that since it is not a minor effort i first want to know i=
f
> > there is some sort interest in the community for such device.
>=20
> My first reaction is: Sounds sensible, but it would be good to have a
> spec for this :)

I'm unclear why you'd want to have a virtio queue for anything other
that some kind of command channel.

I'm not sure a QP or CQ benefits from this??

Jason
