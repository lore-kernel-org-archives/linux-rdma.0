From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: APM support for IPoIB
Date: Tue, 2 Oct 2012 11:00:08 -0600
Message-ID: <20121002170008.GA23733@obsidianresearch.com>
References: <506A17EA.8080400@oracle.com>
 <20121001235303.GH22342@obsidianresearch.com>
 <009101cda0be$6d8cb220$48a61660$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <009101cda0be$6d8cb220$48a61660$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Bang Nguyen' <bang.nguyen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Richard Frank' <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 02, 2012 at 09:53:17AM -0700, Paul Grun wrote:

> Jason - Like your idea for full APM support especially across
> subnets, but wouldn't that require some sort capability that lives
> above the subnet level and is able to query both SMs/SAs?  Sounds
> vaguely router-ish?

Well, in terms of the current spec, PRs are fully specified enough
that a sufficiently informed SA can return PRs for a non-requesting
port on the same node. I've long advocated for an improved PR
mechanism that would be more APM 'aware' and router compatible
(Connected Path Query)

There are a few good ways to get that sort of information into the
SA..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
