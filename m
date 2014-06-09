From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Mon, 9 Jun 2014 13:32:01 -0500
Message-ID: <005d01cf8411$1aa73570$4ff5a050$@opengridcomputing.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1> <CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com> <20140609165105.GB1816@obsidianresearch.com> <alpine.DEB.2.10.1406091307230.9663@gentwo.org> <004701cf840e$90e1cf00$b2a56d00$@opengridcomputing.com> <alpine.DEB.2.10.1406091326430.9663@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1406091326430.9663-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Lameter' <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "'Lacombe, John S'" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Christoph Lameter [mailto:cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org]
> Sent: Monday, June 09, 2014 1:28 PM
> To: Steve Wise
> Cc: 'Jason Gunthorpe'; 'Or Gerlitz'; 'Tatyana Nikolova'; 'Roland Dreier'; 'Lacombe, John
S';
> 'Sean Hefty'; 'linux-rdma'
> Subject: RE: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
> 
> On Mon, 9 Jun 2014, Steve Wise wrote:
> 
> > I don't see how the flow steering API does anything like the port mapping.
> 
> You can redirect flows with a particular port number. Thats the same as
> port mappig right?
> 

We don't want to redirect any flows.  We want to map "tcp" port numbers to ephemeral port
numbers so a offload iWARP connection 4-tuple doesn't collide with a host tcp connection
4-tuple. 

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
