From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Handling busy responses from the SA
Date: Fri, 4 Jun 2010 16:57:39 -0600
Message-ID: <20100604225739.GK15969@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3@MNEXMB1.qlogic.org> <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DC96C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DC96C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 04, 2010 at 02:05:10PM -0700, Hefty, Sean wrote:

> Maybe we should re-think that guideline and allow users to simply
> indicate that the MAD layer should use reasonable defaults.  This
> would enable the ib_mad module to adjust the timeout values for all
> consumers based on actual destination response times.  It could also
> back off retrying multiple requests that were initiated around the
> same time, instead only retrying the first request, while simply
> increasing the timeout values for the others.  This is more complex,
> but we should be able to start with something fairly simple.

A common method for handling this sort of thing is to randomize
the retry timeout. It would be a good idea to randomize all timeouts,
but the BUSY replies should probably randomize over a longer time
period.

Randomization prevents nodes in the cluster from self-synchronizing
and making the load on the SA worse.

But, I also agree with Roland.. having the SA return busy when it is
under load seems insane :) But if you really want to do this then I
think a different, larger, timeout should be used than the standard
mad timeout.

Also, I guess, it would be a good API choice if the caller could say
'get me a reply for this mad or error within 60s' rather than specify
details like retry counts, etc. The timeout values should be globally
set and derived from the usual SA provided data for network transits...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
