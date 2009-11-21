From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ib_post_send in drivers
Date: Sat, 21 Nov 2009 13:01:28 -0700
Message-ID: <20091121200128.GD1966@obsidianresearch.com>
References: <4B06C0EA.2070501@systemfabricworks.com> <e2e108260911201126o5233ea3v94163083fe3d26fc@mail.gmail.com> <E102E8F5252B43318544B660CF6B78F7@amr.corp.intel.com> <e2e108260911210317t323adfe0k4aa3e821d3a1c63c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e2e108260911210317t323adfe0k4aa3e821d3a1c63c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 21, 2009 at 12:17:32PM +0100, Bart Van Assche wrote:

> ib_post_send() has to request a completion notification for each WR,
> which has a negative performance impact. My opinion is that the
> current behavior makes ib_post_send() easier to implement, while the
> behavior specified in the IBAS is more interesting for applications
> that use the verbs API.

It seems to me an error return from ib_post_send either means the
caller is asking for something impossible, or the QP is wrecked, and
is thus pretty much non-recoverable. For instance all the errors for
mlx4 fit this pattern - and I think that is a reasonable requirement
for any implementation of ib_post_send.

So in that light the absence/presence of a completion does not seem
important - if you get an error back you should always tear down the
QP.

Are SRP/etc calling ib_post_send in a way that ever returns errors?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
