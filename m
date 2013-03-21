From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all
 ports of HCA are connected]
Date: Thu, 21 Mar 2013 21:30:07 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510EBB4AB2@CRSMSX102.amr.corp.intel.com>
References: <514278CA.8010809@oracle.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB3F62@CRSMSX102.amr.corp.intel.com>
 <514A0156.2070009@oracle.com> <20130320190208.GA23478@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com>
 <514A3169.7000501@oracle.com> <20130320222422.GA30100@obsidianresearch.com>
 <514A3BDF.2090105@oracle.com> <20130320231923.GA32300@obsidianresearch.com>
 <514A5C07.3080308@oracle.com> <20130321052122.GB20882@obsidianresearch.com>
 <514B6F74.9020707@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <514B6F74.9020707-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: brendan doyle [mailto:brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> 
> 
> On 21/03/2013 05:21, Jason Gunthorpe wrote:
> > On Thu, Mar 21, 2013 at 01:01:59AM +0000, brendan doyle wrote:
> >> On 20/03/2013 23:19, Jason Gunthorpe wrote:
> >>> On Wed, Mar 20, 2013 at 10:44:47PM +0000, brendan doyle wrote:
> >>>

[snip]

> >
> >>>> @@ -178,6 +178,7 @@ int _do_madrpc(int port_id, void *sndbuf, void
> *rcvbuf, int
> >>>>                  status = umad_status(rcvbuf);
> >>>> +               errno = status;
> >>> _do_madrpc already returns int, so this is not great either.
> >> OK I could concede on this, the Solaris kernel uses
> >> ib_user_mad_hdr.status to return an errno to indicate the nature of
> >> failure, where as linux does not.
> > Hrm? Linux will return at least ETIMEDOUT in the .status field.
> 
> Well Linux is not my bag, but I couldn't see where in the code this was the
> case.

I'm a bit confused by what you guys are debating here.  FWIW umad_status does not return MAD.status (IBTA 1.2.1 section 13.4.7)  but rather ib_user_mad.status.

ib_user_mad is the umad meta data to communicate with the kernel and ib_user_mad.status _is_ an errno value.  I don't know what solaris does.

Ira

> 
> > Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
