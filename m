From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2 RFC 2/3] svcrdma: Recvfrom changes
Date: Wed, 14 May 2014 13:24:00 -0500
Message-ID: <009a01cf6fa1$ad1906b0$074b1410$@opengridcomputing.com>
References: <20140506174621.18208.24242.stgit@build.ogc.int> <20140506174632.18208.28160.stgit@build.ogc.int> <F997E138-FB04-4149-811D-CE68608E8D6B@gmail.com> <00f901cf6eeb$2ff1f630$8fd5e290$@opengridcomputing.com> <3DAF95F3-22D5-4FC5-8C98-5A440E54DC2F@gmail.com> <53737D15.6020902@opengridcomputing.com> <2AEECADA-4A40-4BF2-866E-7F178D016DDE@gmail.com> <009601cf6f9f$f47b2cb0$dd718610$@opengridcomputing.com> <639CE8CC-46CE-4EC9-A97B-2F146BA045C4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <639CE8CC-46CE-4EC9-A97B-2F146BA045C4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "'J. Bruce Fields'" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, 'Linux NFS Mailing List' <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Tom Tucker' <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> >>
> >
> > So the code as it stands violates the RFC by sending 2 chunks?
> 
> The Linux client is non-compliant because it sends two chunks. A compliant server
ignores the
> second chunk, so this is functionally harmless (but a waste of resources).
> 
> The Linux server is non-compliant because it _requires_ the XDR pad chunk. A compliant
client
> (eg. Linux with pad optimization enabled) does not interoperate with it.
> 
> > And if I change the server
> > to only consume 1, then everything unaligned will break?
> 
> If you change the server to consume only the first chunk, but do not also make it deal
with XDR
> padding as recommended in chapter 3 of RFC 5666, then WRITEs with a length that is not a
> multiple of four will fail. SYMLINKs with a large payload will also have this problem.
> 

Thanks Chuck for clarifying this!  So I'm going to defer this issue and fix it with a
subsequent patch to only process 1 chunk and handle pad correctly.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
