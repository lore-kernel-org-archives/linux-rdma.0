From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: APM support for IPoIB
Date: Tue, 2 Oct 2012 17:21:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A9888D@FMSMSX151.amr.corp.intel.com>
References: <506A17EA.8080400@oracle.com>
 <20121001235303.GH22342@obsidianresearch.com>
 <009101cda0be$6d8cb220$48a61660$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <009101cda0be$6d8cb220$48a61660$@com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Bang Nguyen' <bang.nguyen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Richard Frank' <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Jason - Like your idea for full APM support especially across subnets, but
> wouldn't that require some sort capability that lives above the subnet level
> and is able to query both SMs/SAs?  Sounds vaguely router-ish?

I'm guessing that it would require that the ports involved have different GIDs and coordinate the partition keys, but I'm not sure anything else is needed.  The GIDs and PKeys could be managed manually by an administrator.

A service could query both SAs for PRs, then pass them in a single CM message to the remote side.  Since the SAs are on different subnets, no matter which paths were selected, they would automatically by disjoint, so I don't believe any other coordination is required.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
