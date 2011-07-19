From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/7] libibverbs: Update examples for IBoE
Date: Tue, 19 Jul 2011 22:44:02 +0300
Message-ID: <CAJZOPZKa3o6VJA9-F6R6prRC4sORct6Lg1mGz4k1qmbPt-NJ1g@mail.gmail.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1107191230350.5580@ogerlitz.voltaire.com>
	<20110719165236.GB18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110719165236.GB18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> Since IBoE requires usage of GRH, update ibv_*_pinpong examples to accept
>> GIDs. GIDs are given as an index to the local port's table and are exchanged
>> between the client and the server through the socket connection.

> Since these examples are meant as programming examples, using the GID
> index as an command line parameter is not an example of good UI
> design. Other tools (ie diags, ibtool, etc) accept the GID in
> canonical IPv6 format and match that to the GID table.

To my taste these examples should be used as programming examples for
their verbs
data path part, as for connection establishment, I would prefer app
writers use the rdma-cm and I don't think the control plane of these
examples (the IB L2/L3/L4 info exchange) should be used in real life
apps. In the same manner that under IB the user doesn't specify the
LID from the command line but rather the device and port, I don't
think they need to specify the GID but rather the device and port. The
index isn't always zero, since this is what let people test VLANs
(under IBoE for each VLAN a new entry is added to the GID table as the
GID includes both mac and vlan).

Or.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
