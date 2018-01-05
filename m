From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 5 Jan 2018 13:35:06 -0700
Message-ID: <20180105203506.GD11348@ziepe.ca>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
 <20180104222842.26756-5-bart.vanassche@wdc.com>
 <1515172870.3403.11.camel@redhat.com>
 <20180105173448.GY11348@ziepe.ca>
 <1515175618.3403.26.camel@redhat.com>
 <20180105192549.GA11348@ziepe.ca>
 <1515183835.3403.62.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515183835.3403.62.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 05, 2018 at 03:23:55PM -0500, Doug Ledford wrote:
> On Fri, 2018-01-05 at 12:25 -0700, Jason Gunthorpe wrote:
> > On Fri, Jan 05, 2018 at 01:06:58PM -0500, Doug Ledford wrote:
> > > > Do the userspace daemon's still manage the connection to SRP?
> > > > 
> > > > If yes, then the networking information should be relative to the
> > > > namespace of the thing that wrote to the sysfs file..
> > > 
> > > Maybe, maybe not.  It depends on the implementation.  IIRC you get one
> > > daemon per port, not one daemon per mount.
> > 
> > I don't think it depends - if we expose this sysfs file to a container
> 
> Who says we have to do that?  We could make the sysfs file only visible
> in the init namespace and let the init namespace daemon control what
> namespaces have what views.

What 'views'? It is a sysfs file controlled by the kernel - srp_daemon
has no control ove rit.

> views anyway.  We could just make that mandatory by refusing to create
> devices from anything other than init_net namespace.  Then even if
> someone does mount sysfs rw in a container, we're still good.

Usually we don't put that kind if policy in the kernel.

Someone could run a priviledged container with full device access and
expect this stuff to work right. In that case it is certainly correct
for the srp_daemon and kernel to be in the namespace of the calling
process.

> > So from a security perspective containers shouldn't even have access
> > to this thing at all without more work to ensure that the created
> > block device is also restriced inside the container.
> 
> This isn't sufficient.  The block device created must be constrained
> within the container, but if we allow direct device access to the
> underlying LUN on the target, then that target LUN must be exclusively
> owned by the container.

Yes. That is done on the storage controller via ACLs of that LUN. The
container's net namespace would be restricted in some way that the ACL
can uniquely identify it - and the srp_daemon could run inside the
container.

Otherwise the LUN has to be ACL'd to the host and the srp_daemon
running on the host creates the device and orchestartion sends it into
the contiainer.

> No other container, nor the host, can be allowed to have any access
> of any sort or it becomes a message passing bypass around
> containerization.

But maybe that is the user-intent. shared storage between VMs is a
real thing. We can't put that kind of policy choice in the kernel.

> This problem is made more difficult by the fact that there is persistent
> storage at the other end of the connection.  It doesn't really matter
> what netdevice we access a target through.

Well, it does. The netdevice is part of the ACL system the target
uses. It is actually super important that the right netdevice be
used..

Anyhow. Bart should look at what iscsi does for namespaces and copy
that.. No sense in inventing something unique for RDMA.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
