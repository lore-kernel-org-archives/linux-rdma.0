From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/7] libibverbs: Update examples for IBoE
Date: Tue, 19 Jul 2011 10:52:36 -0600
Message-ID: <20110719165236.GB18090@obsidianresearch.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1107191230350.5580@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1107191230350.5580-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2011 at 12:31:32PM +0300, Or Gerlitz wrote:
> Since IBoE requires usage of GRH, update ibv_*_pinpong examples to accept
> GIDs. GIDs are given as an index to the local port's table and are exchanged
> between the client and the server through the socket connection.

Since these examples are meant as programming examples, using the GID
index as an command line parameter is not an example of good UI
design. Other tools (ie diags, ibtool, etc) accept the GID in
canonical IPv6 format and match that to the GID table.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
