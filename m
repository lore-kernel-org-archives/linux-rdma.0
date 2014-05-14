From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2 RFC 2/3] svcrdma: Recvfrom changes
Date: Wed, 14 May 2014 13:11:40 -0500
Message-ID: <009601cf6f9f$f47b2cb0$dd718610$@opengridcomputing.com>
References: <20140506174621.18208.24242.stgit@build.ogc.int> <20140506174632.18208.28160.stgit@build.ogc.int> <F997E138-FB04-4149-811D-CE68608E8D6B@gmail.com> <00f901cf6eeb$2ff1f630$8fd5e290$@opengridcomputing.com> <3DAF95F3-22D5-4FC5-8C98-5A440E54DC2F@gmail.com> <53737D15.6020902@opengridcomputing.com> <2AEECADA-4A40-4BF2-866E-7F178D016DDE@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2AEECADA-4A40-4BF2-866E-7F178D016DDE-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "'J. Bruce Fields'" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, 'Linux NFS Mailing List' <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Tom Tucker' <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> >
> >> If you print ch_count, it is 2 for NFS WRITEs from a Linux client,
> >> no matter how large the write payload is. Therefore I think the check
> >> as it is written is not particularly useful.
> >
> > Why are there 2?
> 
> The first chunk lists the pages the server is to read, and the second
> chunk has the zero pad for XDR alignment.
> 
> If pad optimization is enabled on the client, there is just 1 chunk in
> the RPC's Read list.
> 

So the code as it stands violates the RFC by sending 2 chunks?  And if I change the server
to only consume 1, then everything unaligned will break?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
