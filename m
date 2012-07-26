From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: EINVAL when INIT -> RTR on RoCE
Date: Thu, 26 Jul 2012 11:10:43 -0600
Message-ID: <20120726171043.GA7596@obsidianresearch.com>
References: <B2CAB3C7-6049-4B8B-90C1-9DD2180857EE@gmail.com>
 <CAL1RGDUEMiuNKBjShYUmj2OTAS=YDGgpK7d5Li090r2ot8VanQ@mail.gmail.com>
 <CAL1RGDUsk2YV4GwYF7doina+bDGqw6VAHAEajJ7Qg7PJhF6aew@mail.gmail.com>
 <F0AFA058-856F-48A0-99A1-2FB5398B31B6@gmail.com>
 <2159AA50-F259-4963-BAB3-C300171C37BE@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2159AA50-F259-4963-BAB3-C300171C37BE-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "\"Xavier R. Gu?rin\"" <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 26, 2012 at 09:49:57AM -0400, "Xavier R. Gu?rin" wrote:

> On a side note, I see from rc_pingpong that ibv_query_gid requires
> an index, and that this index is asked to the user of the pingpong
> program. What is that index about (the man page is not very
> explicit)?  Cannot it be deduced in any way ?

It is the source GID of the local adaptor. Generally you can just use
index 0, particularly on RoCEE..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
