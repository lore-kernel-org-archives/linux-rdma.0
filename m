From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ib_post_send in drivers
Date: Sat, 21 Nov 2009 14:52:52 -0700
Message-ID: <20091121215252.GE1966@obsidianresearch.com>
References: <4B06C0EA.2070501@systemfabricworks.com> <e2e108260911201126o5233ea3v94163083fe3d26fc@mail.gmail.com> <E102E8F5252B43318544B660CF6B78F7@amr.corp.intel.com> <e2e108260911210317t323adfe0k4aa3e821d3a1c63c@mail.gmail.com> <20091121200128.GD1966@obsidianresearch.com> <e2e108260911211237j2b9fd96cn3df78fe5c59fdc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e2e108260911211237j2b9fd96cn3df78fe5c59fdc5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 21, 2009 at 09:37:29PM +0100, Bart Van Assche wrote:

> It would be more useful IMHO if ib_post_send() would not
> post any WR instead of posting part of the WR's passed to
> ib_post_send() when the 'queue full' condition is hit. Note: SRPT uses
> a single SRQ per HCA, even when multiple SRP connections are active
> for the same HCA.

Well, yes, this is useful, but the way verbs is kinda designed, it
isn't the verbs layer that worries about that. If your app cannot
handle a partial send then it must track the SQ availability on its
own and never cause the SQ to overflow. This is what SRP initiator
does, for instance.

If you are keeping track, and you get ENOMEM then it is a bug.

A fair criticism is that verbs doesn't have APIs to export the various
Q availabilities - but I think ib_post_send is fine for its intended
role.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
