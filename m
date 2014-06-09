From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Mon, 9 Jun 2014 09:46:48 -0500
Message-ID: <000801cf83f1$a4366920$eca33b60$@opengridcomputing.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1> <CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "'Lacombe, John S'" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Steve, Tatyana
> 
> Reading this cover letter, I think it's good idea to follow Steve's
> suggestion and add portions from here into the IB/core change you
> introduced (patch #1 in this series) and is now merged into Roland's
> for-next -- before Roland's sends his 3.16 merge window pull request
> to Linus (there is enough time!!), since the current change-log
> http://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/commit/?h=for-
> next&id=1943d56776ad31a119517efeb309786db3b4383e
> practically says nothing on what is the PM about
> 

Roland, can you do this?

> 2nd, there's nothing specific to iWARP in the port mapper implementation, right?
> 
> What it does is the following:
> 
> 1. kernel rdma driver tells a user space daemon they want to reserve
> (claim) the combination of IP address X and TCP port Y for the sake of
> RDMA connections
> 
> 2. user space daemon opens a socket and binds to X:Y
> 

No, the use space daemon opens a socket and binds to address X port 0 and thus allocates an ephemeral port number Z.  The mapping of X->Z is then made available to clients trying to connect to this service.

> Specifically, down the road, more use cases, not only the current
> iWARP case may pop up.
> 

It is really only needed for iWARP and not IB because IB doesn't share the port space with the host TCP stack.  iWARP does.

> So taking into account that the implementation doesn't have anything
> whivh is IW specific, and that future non-IW use case might show up,
> why we need to fill the IB core code with IW_PM notation? why not just
> use RDMA_PM notation? this can be achieved quickly with
> 
> $ sed -i g/iw_pm/rdma_pm/g *
> 
> and friends on Roland's tree and later squashed into the relevant patches.
> 
> I understand that my comment came little late... but taking into
> account the ease of the change (sed exercise), why not doing it? the
> IB core patch exposes API to user-space, so we should make sure to do
> it right
> 

I'm not convinced this is desirable.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
