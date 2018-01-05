From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 5 Jan 2018 16:27:24 -0700
Message-ID: <20180105232724.GE11348@ziepe.ca>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
 <20180104222842.26756-5-bart.vanassche@wdc.com>
 <1515172870.3403.11.camel@redhat.com>
 <20180105173448.GY11348@ziepe.ca>
 <1515175618.3403.26.camel@redhat.com>
 <20180105192549.GA11348@ziepe.ca>
 <1515183835.3403.62.camel@redhat.com>
 <20180105203506.GD11348@ziepe.ca>
 <1515193988.3403.69.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515193988.3403.69.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 05, 2018 at 06:13:08PM -0500, Doug Ledford wrote:
> Ok, allow me to clarify: restrict the sysfs file to create mappings to
> only the init_net namespace, and by views I meant allow the host
> srp_daemon to create a mapping with a specific namespace and that would
> then create a device file in that namespace, not a sysfs file.

I'm not familiar enough with the status of the 'device namespace'
stuff, but..

AFAIK a today this works with the orchestation software just putting
the device nodes it wants the container to have in /dev/ tmpfs and
then the kernel prevents the container from creating new device nodes.

So, in that configuration plugging new block devices into the
container is a userspace problem, not the kernel, and you'd never run
something like srp_daemon inside a container..

> When we arguing over namespaces, especially as they related to IPoIB
> devices, we decided to allow the tuple to be p_key/qp/gid so that you
> can have to separate containers on the same p_key and gid with the

Well, the PKey and GID is supposed to be the differentiator for ACL
like purposes.

And in roce we can have a full MAC address assigned to the container
(for iser and what not)

So it isn't broken, it is just limited. (ie by the gid table size)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
