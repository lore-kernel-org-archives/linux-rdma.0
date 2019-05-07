From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [Qemu-devel] [RFC 0/3] VirtIO RDMA
Date: Tue, 7 May 2019 16:43:08 -0300
Message-ID: <20190507194308.GK6201@ziepe.ca>
References: <20190411110157.14252-1-yuval.shaia@oracle.com>
	<20190411190215.2163572e.cohuck@redhat.com>
	<20190415103546.GA6854@lap1>
	<e73e03c2-ea2b-6ffc-cd23-e8e44d42ce80@suse.de>
	<20190422164527.GF21588@ziepe.ca> <20190430171350.GA2763@lap1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20190430171350.GA2763@lap1>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: mst@redhat.com, linux-rdma@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 30, 2019 at 08:13:54PM +0300, Yuval Shaia wrote:
> On Mon, Apr 22, 2019 at 01:45:27PM -0300, Jason Gunthorpe wrote:
> > On Fri, Apr 19, 2019 at 01:16:06PM +0200, Hannes Reinecke wrote:
> > > On 4/15/19 12:35 PM, Yuval Shaia wrote:
> > > > On Thu, Apr 11, 2019 at 07:02:15PM +0200, Cornelia Huck wrote:
> > > > > On Thu, 11 Apr 2019 14:01:54 +0300
> > > > > Yuval Shaia <yuval.shaia@oracle.com> wrote:
> > > > > 
> > > > > > Data center backends use more and more RDMA or RoCE devices and more and
> > > > > > more software runs in virtualized environment.
> > > > > > There is a need for a standard to enable RDMA/RoCE on Virtual Machines.
> > > > > > 
> > > > > > Virtio is the optimal solution since is the de-facto para-virtualizaton
> > > > > > technology and also because the Virtio specification
> > > > > > allows Hardware Vendors to support Virtio protocol natively in order to
> > > > > > achieve bare metal performance.
> > > > > > 
> > > > > > This RFC is an effort to addresses challenges in defining the RDMA/RoCE
> > > > > > Virtio Specification and a look forward on possible implementation
> > > > > > techniques.
> > > > > > 
> > > > > > Open issues/Todo list:
> > > > > > List is huge, this is only start point of the project.
> > > > > > Anyway, here is one example of item in the list:
> > > > > > - Multi VirtQ: Every QP has two rings and every CQ has one. This means that
> > > > > >    in order to support for example 32K QPs we will need 64K VirtQ. Not sure
> > > > > >    that this is reasonable so one option is to have one for all and
> > > > > >    multiplex the traffic on it. This is not good approach as by design it
> > > > > >    introducing an optional starvation. Another approach would be multi
> > > > > >    queues and round-robin (for example) between them.
> > > > > > 
> > > Typically there will be a one-to-one mapping between QPs and CPUs (on the
> > > guest). 
> > 
> > Er we are really overloading words here.. The typical expectation is
> > that a 'RDMA QP' will have thousands and thousands of instances on a
> > system.
> > 
> > Most likely I think mapping 1:1 a virtio queue to a 'RDMA QP, CQ, SRQ,
> > etc' is a bad idea...
> 
> We have three options, no virtqueue for QP, 1 to 1 or multiplexing. What
> would be your vote on that?
> I think you are for option #1, right? but in this case there is actually no
> use of having a virtio-driver, isn't it?

The virtio driver is supposed to be a standard, like a hardware
standard, for doing the operation.

It doesn't mean that every single element under the driver needs to
use the virtio format QP.

Jason
