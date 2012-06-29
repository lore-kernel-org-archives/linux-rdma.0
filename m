From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibumad: update umad_recv man page.
Date: Fri, 29 Jun 2012 09:23:43 -0700
Message-ID: <20120629092343.6119ad47.weiny2@llnl.gov>
References: <20120628181343.7f931c33.weiny2@llnl.gov>
	<4FEDB762.8090603@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FEDB762.8090603-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 29 Jun 2012 10:10:42 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 6/28/2012 9:13 PM, Ira Weiny wrote:
> > Document the umad and length parameters better.
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  man/umad_recv.3 |   18 +++++++++++++++++-
> >  1 files changed, 17 insertions(+), 1 deletions(-)
> > 
> > diff --git a/man/umad_recv.3 b/man/umad_recv.3
> > index e1b2985..3c93c4a 100644
> > --- a/man/umad_recv.3
> > +++ b/man/umad_recv.3
> > @@ -27,10 +27,26 @@ A negative
> >  makes the function block until a packet is received. A
> >  .I timeout_ms\fR
> >  parameter of zero indicates a non blocking read.
> > +
> > +.B Note
> > +.I length
> > +is the length of the
> 
> is a pointer to the length of the

good point.

> 
> > +.B data
> > +portion of the umad buffer.  This means that
> > +.I umad
> > +should point to a buffer at least umad_size() +
> > +.I length
> > +bytes long.
> > +
> > +.B Note also
> > +that
> > +.I length\fR
> > +must be >= 256 bytes.
> 
> I think that this should say "should" rather than "must".

The RHEL 6.2 kernel (and Rolands master) will return -EINVAL if the length is not large enough to handle the first packet or RMPP segment.

	/* We need enough room to copy the first (or only) MAD segment. */
	recv_buf = &packet->recv_wc->recv_buf;
	if ((packet->length <= sizeof (*recv_buf->mad) &&
	     count < hdr_size(file) + packet->length) ||
	    (packet->length > sizeof (*recv_buf->mad) &&
	     count < hdr_size(file) + sizeof (*recv_buf->mad)))
		return -EINVAL;

The -EINVAL from the kernel is not processed by the library and simply fails the call rather than returning the length required.

Would you like to change the above to return -ENOSPC?

> 
> > +
> >  .SH "RETURN VALUE"
> >  .B umad_recv()
> >  returns non negative receiving agentid on success, and a negative value on error as follows:
> > - -EINVAL      invalid port handle or agentid
> > + -EINVAL      invalid port handle or agentid or length too short
> 
> Shouldn't this just be length (pointer) NULL/not supplied (and not
> length too short) ?

I was simply trying to document the case above.

> 
> Length handling is already described in the man page:
> "The packet  is  copied  to the  umad buffer if there is sufficient room
> and the received length is indicated.  If the buffer is not large
> enough, the  size  of  the  umad buffer  needed  is returned in length."

Yes, I thought that too but looking at the kernel I figured there was a requirement for the length to be at least be a single packet long and the length being returned was a mechanism to return information about an RMPP session packet which is longer than a single MAD.

If this is not the intended behaviour then the kernel is broken and should be fixed.

Ira

> 
> -- Hal
> 
> >   -EIO         receive operation failed
> >   -EWOULDBLOCK non blocking read can't be fulfilled
> >  .SH "SEE ALSO"
> 


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
