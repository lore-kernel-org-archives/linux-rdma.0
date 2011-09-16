From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] An argument for allowing applications to manually send
 RMPP packets if desired
Date: Fri, 16 Sep 2011 13:28:16 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387ECDF@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387E899@MNEXMB1.qlogic.org>
 <CAL1RGDUXM9-Ey1aF8xQo3X_L1PLrVyyLPYvqmy6Qeu5M2JnJPA@mail.gmail.com>
 <20110912172334.GC18574@obsidianresearch.com>
 <CAL1RGDVPZzMKmMg7mokhG0btX+3NH_+tL-9P5guV10h6X6i0iw@mail.gmail.com>
 <20110912190623.GD18574@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110912190623.GD18574-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There hasn't been any discussion of this patch since Monday, I'd like to
see if we can keep this conversation moving forward.

Right now, as I see it, we have a scalability issue with how rmpp
packets are currently handled. While the current method works great on
small to mid-sized fabrics - and vastly simplifies life for the
application programmer - as fabrics grow in size, it risks memory
exhaustion when many nodes make similar queries to a server at the same
time. In addition, it eliminates the flexibility provided in the RMPP
protocol; if the SA/SM handles RMPP packets individually it can not only
stash packets for re-use, it can take advantage of the timing and
windowing in the protocol to throttle its responses during periods of
heavy load.

Note that no one is arguing that the existing model isn't appropriate
for client applications - I doubt we will be seeing fabrics so large
that a single NodeInfo response would exhaust all RAM on the client.

Roland, you suggested developing a new interface that avoids the copying
without requiring the full protocol to be handled in user space,
possibly using writev(). But is it really worthwhile to add complexity
to ib_mad, ib_umad, libibumad and libibmad for something that's only
needed on (for example) one machine out of several thousand? In
addition, such an interface still would not allow a sophisticated SM
implementation to do load management of the queries. Trying to put load
management of MAD queries in the kernel itself would result in a
constantly changing kernel module as we try to adapt to emerging issues
as the fabrics become ever larger.

The patch at hand avoids all that complexity by simply allowing the SM
application handle RMPP itself in whatever manner is considered best. If
the SM wants to use the current RMPP implementation it can, turning this
ability on is completely optional.

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
