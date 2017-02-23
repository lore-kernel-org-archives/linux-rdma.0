From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/4] sunrpc: flag transports as using IETF approved
 congestion control protocols
Date: Thu, 23 Feb 2017 13:55:02 -0700
Message-ID: <20170223205502.GA29673@obsidianresearch.com>
References: <20170223170337.10686-1-jlayton@redhat.com>
 <20170223170337.10686-2-jlayton@redhat.com>
 <2152dfdf-f847-2511-1600-6499b6ea9708@talpey.com>
 <1487880034.3448.8.camel@redhat.com>
 <65056db6-f30a-c44d-b01c-b549887c4895@talpey.com>
 <20170223201109.GC11882@fieldses.org>
 <20170223202609.GC26301@obsidianresearch.com>
 <18ef37c3-95db-9a2c-dbcb-f579672065d6@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <18ef37c3-95db-9a2c-dbcb-f579672065d6-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 23, 2017 at 03:33:53PM -0500, Tom Talpey wrote:

> The key words are "IETF-approved". Mitigation and Interaction are
> operational decisions, not protocol design.

We are talking about this bit from RFC 3530 ?

   Where an NFS version 4 implementation supports operation over the IP
   network protocol, the supported transports between NFS and IP MUST be
   among the IETF-approved congestion control transport protocols, which
   include TCP and SCTP.

This gives most of RDMA an out as it is not over the IP protocol. The
only obvious troubled one is RoCEv2..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
