From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Mon, 9 Jun 2014 13:13:51 -0500
Message-ID: <004701cf840e$90e1cf00$b2a56d00$@opengridcomputing.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1> <CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com> <20140609165105.GB1816@obsidianresearch.com> <alpine.DEB.2.10.1406091307230.9663@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1406091307230.9663-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Lameter' <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "'Lacombe, John S'" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Christoph Lameter [mailto:cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org]
> Sent: Monday, June 09, 2014 1:11 PM
> To: Jason Gunthorpe
> Cc: Or Gerlitz; Tatyana Nikolova; Steve Wise; Roland Dreier; Lacombe, John S; Sean
Hefty;
> linux-rdma
> Subject: Re: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
> 
> On Mon, 9 Jun 2014, Jason Gunthorpe wrote:
> 
> > The message from netdev has, IMHO, always been pretty clear - offload
> > can live in it's own little side world but cannot appear to the user
> > to be integrated to the main stack (because it isn't).
> 
> Hmmm... The flow steering API already does what the port mapper does and
> its already merged. Why do we need another implementation?
> 

I don't see how the flow steering API does anything like the port mapping. 

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
