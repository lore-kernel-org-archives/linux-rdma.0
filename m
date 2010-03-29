From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: nfsrdma broken on 2.6.34-rc1?
Date: Mon, 29 Mar 2010 12:01:07 -0700
Message-ID: <adaiq8fvtos.fsf@roland-alpha.cisco.com>
References: <4BB0E670.3010507@opengridcomputing.com>
	<B18454F3200D4A43B57F175388845AAC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B18454F3200D4A43B57F175388845AAC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Mon, 29 Mar 2010 11:43:45 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > The rdma_cm might be able to support this if the port space were separated based
 > > on the address family, depending on how PS IB ends up.
 > 
 > I think separate port spaces is the correct solution.

This gets a bit tricky -- for normal IP stuff, there's the "bindv6only"
sysctl (and the IPV6_V6ONLY socket option).  Without that, you can't
bind an IPv4 socket to the same port as an IPv6 socket, since the IPv6
socket will accept IPv4 connections via an v4->v6 mapped address.  (You
can look at inet_csk_bind_conflict() to see the full complexity of the
checking done when binding an IPv4 socket)

I wonder what the right way from the RDMA CM to stay close to Linux
sockets semantics without adding too much horror is.  (Adding Jason to
the CC list since he usually has an opinion about things like this :)

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
