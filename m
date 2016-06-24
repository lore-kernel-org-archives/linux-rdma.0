From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Interrupted IO causing async errors
Date: Fri, 24 Jun 2016 08:36:55 -0500
Message-ID: <001601d1ce1d$7990c800$6cb25800$@opengridcomputing.com>
References: <00e101d1cd65$e19bf360$a4d3da20$@opengridcomputing.com> <BDD2D64C-7A05-42EB-83C2-F95825C7579D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BDD2D64C-7A05-42EB-83C2-F95825C7579D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Raju Rangoju' <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Thursday, June 23, 2016 7:15 PM
> To: Steve Wise
> Cc: Raju Rangoju; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Interrupted IO causing async errors
> 
> Hi Steve-
> 
> > On Jun 23, 2016, at 11:42 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> wrote:
> >
> > Hey chuck, we observe with 4.7-rc4 (and older kernels too) that interrupting
a
> > dbench test on a nfsrdma/cxgb4 mount while it is doing heavy I/O can result
in
> > cxgb4 logging an "invalid stag" error on an ingress RDMA WRITE message.   Is
> > this expected?  I'm wondering if this is a normal side effect of
interrupting
> > the IO on the mount.  Maybe due to the mount options or NFS version?    This
> > error could happen if the NFSRDMA client invalidated MRs that were
advertised
> to
> > the server for IO, while IO was still in flight.  Is this expected or should
we
> > dive in further?  Thoughts?  thanks...
> 
> When an application is signaled, outstanding RPCs are terminated.
> When an RPC completes, whether because a reply was received,
> or because the local application has died, any memory that was
> registered on behalf of that RPC is invalidated before it can be
> used for something else. The data in that memory remains at rest
> until invalidation and DMA unmapping is complete.
> 
> It appears that your server is attempting to read an argument or
> write a result for an RPC that is no longer pending. I think both
> sides should report a transport error, and the connection should
> terminate. No other problems, though: other operation should
> continue normally after the client re-establishes a fresh connection.
> 
> If this doesn't match your observations, let me know.
>

This is exactly what we see.  Thanks!

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
