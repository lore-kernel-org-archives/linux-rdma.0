From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] RDMA CM + XRC, take two
Date: Tue, 10 May 2011 23:17:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373BBE2@ORSMSX101.amr.corp.intel.com>
References: <4DC86BB2.1020002@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DC86BB2.1020002-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This is an improved version of my previous patch to add XRC support to
> RDMA CM.

I would still like to see support merged upstream and into mainline libibverbs before applying this to my tree.
 
> This version now support the newer rdma CM interface. It needs some
> polishing but it works.

It's hard to comment on the patch as an attachment.  In several places, if/else statements were added, but indentation was not added to the opposite part of the statement.  There was also a rather large amount of code added to rdma_create_qp() that needs to be split into a separate function.  (I dislike functions longer than a screen.)
 
> It modifies the rdma_client/server examples to use xrc instead of rc.
> 
> The big hack is that the SRQ number needs to be transmitted to the remote
> side. This patch hijacks the private data, so it's not acceptable. Ideally the SRQ
> number should be transmitted either in the REQ or REP packet (depending
> on which side the sender or the receiver) alongside the QP number. But that
> would need a change in the specs. Any suggestions ?

What are the QPNs carried in the REQ and REP?

> Also a good chunk of the patch is to deal with the XRC verbs API. I wonder
> whether XRC could/should be more integrated into the existing verbs:

That would be my preference.   I'm not familiar with the OFED XRC interfaces, so I'm only going off of the annex.

> - sender should not need a domain,

Hiding the xrc domain with the pd might help prevent breaking the user space ABI.

> - there should be 2 types of xrc QPs (send and receive) instead of one,

I've thought of this as well, and think it may also help prevent breaking the ABI.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
