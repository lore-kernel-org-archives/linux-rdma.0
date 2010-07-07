From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 07 Jul 2010 09:26:14 -0700
Message-ID: <4C34AAA6.2080909@opengridcomputing.com>
References: <OF9B577A15.49E0F3EB-ONC1257759.005129F2-C1257759.0055D7D7@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF9B577A15.49E0F3EB-ONC1257759.005129F2-C1257759.0055D7D7-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bernard Metzler wrote:
> Steve,
>
> merging the port space of different transports is very particular
> and it would be good if we could avoid it w/o losing on transport
> independence. 

But the IB and IW port space is _already_ merged by the RDMA_CM.  That's 
my point.  So a solution that breaks this impacts transport-independent 
applications that use the rdma cm...

> Could we prove a strong need for that short-cut?
> If its really needed, one global RDMA_CM instance should be able
> to achive that requirement. But wouldn't that go together with a waste
> of unused transports resources (i.e., IB binds would create
> and bind also TCP sockets..?).
>   

My comment has nothing to do with TCP ports but rather RDMA ports as 
abstracted by the RDMA_CM.  The RDMA_PS_TCP port space is shared among 
all the RDMA transports.  So if you rdma_bind() to port space 
RDMA_PS_TCP, addr INADDR_ANY, port 9999, then it will bind the cm_id to 
all IB and IW providers for that address/port (note the providers don't 
really get called until rdma_listen()).  Thus if you propose moving the 
bind operation down into the device providers, then the IB providers 
will also have to add this logic.  Or some solution must be defined to 
keep the IB and IW port spaces common.  Otherwise the RDMA_CM cannot 
support transport independent applications...

I don't think there is anything wrong with doing this, but realize this 
change will impact all rdma providers as well as the core.


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
