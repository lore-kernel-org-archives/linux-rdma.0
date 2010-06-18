From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] allow passthrough of rmpp packets to user mad clients
Date: Fri, 18 Jun 2010 09:41:34 -0600
Message-ID: <20100618154134.GA12884@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8@MNEXMB1.qlogic.org> <adask52o9p6.fsf@roland-alpha.cisco.com> <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C2F@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C2F-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 18, 2010 at 08:42:38AM -0500, Mike Heinz wrote:

> First addressing Roland's comment, there are in fact TCP socket
> options which control how much buffering is done in the kernel and
> hence control message size and segmentation points for TCP.  Those
> options allow the careful balance of window size, kernel memory
> space and TCP performance to be tuned, the defaults for these
> options tend to be relatively small.  This is possible for TCP since
> the protocol is defined at the application level as a byte stream
> protocol, hence it is up to the TCP stack to decide the proper
> segmentation points and windowing.  Applications must be written to
> assume a recv() could return only part of a corresponding send() and
> could be at any arbitrary byte boundary.

Umh, dumb question..

Why not just add byte-stream like APIs to the kernel interface for
RMPP?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
