From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 5 Jan 2018 10:34:48 -0700
Message-ID: <20180105173448.GY11348@ziepe.ca>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
 <20180104222842.26756-5-bart.vanassche@wdc.com>
 <1515172870.3403.11.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515172870.3403.11.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 05, 2018 at 12:21:10PM -0500, Doug Ledford wrote:

> > +static int srp_parse_in(struct sockaddr_storage *sa, const char *addr_port_str)
> > +{
> > +	char *addr = kstrdup(addr_port_str, GFP_KERNEL);
> > +	char *port_str = addr;
> > +	int ret;
> > +
> > +	if (!addr)
> > +		return -ENOMEM;
> > +	strsep(&port_str, ":");
> > +	ret = inet_pton_with_scope(&init_net, AF_UNSPEC, addr, port_str, sa);
> > +	kfree(addr);
> > +	return ret;
> > +}
> > +
> 
> This particular function is problematic in that it adds new namespace
> unaware code.  The namespace code in the RDMA stack is in a limbo state
> of partially implemented, partially not.  I'm loathe to add any more
> code that is not fully namespace aware as that just worsens the
> hysteresis in the stack.  So we need to figure out how to do this in a
> namespace aware manner.  I haven't previously been thinking about this
> specific namespace issue, so I'm not prepared to even make suggestions
> for a fix for this yet...

Do the userspace daemon's still manage the connection to SRP?

If yes, then the networking information should be relative to the
namespace of the thing that wrote to the sysfs file..

Also, are there srp_daemon patches for this too? I've been asking to
see the userspace side for new uAPI features before accepting the
kernel part so that everything can be well understood. If yes, please
send, even if it is RFCish..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
