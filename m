From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [Qemu-devel] [RFC 0/3] VirtIO RDMA
Date: Mon, 22 Apr 2019 13:45:27 -0300
Message-ID: <20190422164527.GF21588@ziepe.ca>
References: <20190411110157.14252-1-yuval.shaia@oracle.com>
	<20190411190215.2163572e.cohuck@redhat.com>
	<20190415103546.GA6854@lap1>
	<e73e03c2-ea2b-6ffc-cd23-e8e44d42ce80@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <e73e03c2-ea2b-6ffc-cd23-e8e44d42ce80@suse.de>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Hannes Reinecke <hare@suse.de>
Cc: mst@redhat.com, linux-rdma@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, Yuval Shaia <yuval.shaia@oracle.com>, virtualization@lists.linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 19, 2019 at 01:16:06PM +0200, Hannes Reinecke wrote:
> On 4/15/19 12:35 PM, Yuval Shaia wrote:
> > On Thu, Apr 11, 2019 at 07:02:15PM +0200, Cornelia Huck wrote:
> > > On Thu, 11 Apr 2019 14:01:54 +0300
> > > Yuval Shaia <yuval.shaia@oracle.com> wrote:
> > > 
> > > > Data center backends use more and more RDMA or RoCE devices and more and
> > > > more software runs in virtualized environment.
> > > > There is a need for a standard to enable RDMA/RoCE on Virtual Machines.
> > > > 
> > > > Virtio is the optimal solution since is the de-facto para-virtualizaton
> > > > technology and also because the Virtio specification
> > > > allows Hardware Vendors to support Virtio protocol natively in order to
> > > > achieve bare metal performance.
> > > > 
> > > > This RFC is an effort to addresses challenges in defining the RDMA/RoCE
> > > > Virtio Specification and a look forward on possible implementation
> > > > techniques.
> > > > 
> > > > Open issues/Todo list:
> > > > List is huge, this is only start point of the project.
> > > > Anyway, here is one example of item in the list:
> > > > - Multi VirtQ: Every QP has two rings and every CQ has one. This means that
> > > >    in order to support for example 32K QPs we will need 64K VirtQ. Not sure
> > > >    that this is reasonable so one option is to have one for all and
> > > >    multiplex the traffic on it. This is not good approach as by design it
> > > >    introducing an optional starvation. Another approach would be multi
> > > >    queues and round-robin (for example) between them.
> > > > 
> Typically there will be a one-to-one mapping between QPs and CPUs (on the
> guest). 

Er we are really overloading words here.. The typical expectation is
that a 'RDMA QP' will have thousands and thousands of instances on a
system.

Most likely I think mapping 1:1 a virtio queue to a 'RDMA QP, CQ, SRQ,
etc' is a bad idea...

> However, I'm still curious about the overall intent of this driver. Where
> would the I/O be routed _to_ ?
> It's nice that we have a virtualized driver, but this driver is
> intended to do I/O (even if it doesn't _do_ any I/O ATM :-)
> And this I/O needs to be send to (and possibly received from)
> something.

As yet I have never heard of public RDMA HW that could be coupled to a
virtio scheme. All HW defines their own queue ring buffer formats
without standardization.

> If so, wouldn't it be more efficient to use vfio, either by using SR-IOV or
> by using virtio-mdev?

Using PCI pass through means the guest has to have drivers for the
device. A generic, perhaps slower, virtio path has some appeal in some
cases.

> If so, how would we route the I/O from one guest to the other?
> Shared memory? Implementing a full-blown RDMA switch in qemu?

RoCE rides over the existing ethernet switching layer quemu plugs
into

So if you built a shared memory, local host only, virtio-rdma then
you'd probably run through the ethernet switch upon connection
establishment to match the participating VMs.

Jason
