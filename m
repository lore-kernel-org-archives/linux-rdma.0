From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 5 Jan 2018 12:25:49 -0700
Message-ID: <20180105192549.GA11348@ziepe.ca>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
 <20180104222842.26756-5-bart.vanassche@wdc.com>
 <1515172870.3403.11.camel@redhat.com>
 <20180105173448.GY11348@ziepe.ca>
 <1515175618.3403.26.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515175618.3403.26.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 05, 2018 at 01:06:58PM -0500, Doug Ledford wrote:
> > Do the userspace daemon's still manage the connection to SRP?
> >
> > If yes, then the networking information should be relative to the
> > namespace of the thing that wrote to the sysfs file..
>
> Maybe, maybe not.  It depends on the implementation.  IIRC you get one
> daemon per port, not one daemon per mount.

I don't think it depends - if we expose this sysfs file to a container
then anything less than using the contain'd net namespace sounds like
it is a path to allow the container to escape its net namespace.

The complication here is that sysfs creates a device, and that device
is currently created in the host namespace.

So from a security perspective containers shouldn't even have access
to this thing at all without more work to ensure that the created
block device is also restriced inside the container.

Since it is a sysfs file, and most container systems mount syfs ro, we
can probably get away with ignoring namespaces for now?

But using the current process namespace is also a good choice.

In princinple there can be multiple srp_daemons if they can coordinate
which ones do which. For instance a container could run its own
srp_daemon restricted to the pkeys the container has access to. If the
device stuff above was fixed then this would even make some sense...

Otherwise srp_daemon has to run in the host namespace, where the
created devices end up and it rightly should not see the netdevices
that are assigned to other namespaces.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
