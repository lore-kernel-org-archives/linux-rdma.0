From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Handling busy responses from the SA
Date: Fri, 4 Jun 2010 16:19:06 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DCB3A@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DC96C@orsmsx501.amr.corp.intel.com>
 <20100604225739.GK15969@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100604225739.GK15969-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> A common method for handling this sort of thing is to randomize
> the retry timeout. It would be a good idea to randomize all timeouts,
> but the BUSY replies should probably randomize over a longer time
> period.
> 
> Randomization prevents nodes in the cluster from self-synchronizing
> and making the load on the SA worse.

I agree that randomization would be nice, but I think we want even more than that.  Part of the issues that we've seen with the current implementation is that when a large HPC job starts, everyone and their dog sends the SA a query.  These time out around the same time and get resent, and the SA ends up processing a huge number of duplicates.  The mad layer could be a lot more intelligent and avoid sending more than a handful (1?) of retries (or even initial requests) at a time until some complete.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
