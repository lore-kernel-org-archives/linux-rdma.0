From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/19, v5] Make ib_srp better suited for H.A. purposes
Date: Tue, 13 Nov 2012 00:36:52 +0200
Message-ID: <CAJZOPZJPQkJ-kkW3ro9sRJXQJg_Yz_tjoJ1Rwb=XEePO3j_iJw@mail.gmail.com>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A85BB.1000505-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> This patch series makes the ib_srp driver better suited for use in a H.A. setup because:
> - multipathd is notified faster about transport layer failures.
> - Transport layer failures reliably result in SCSI host removal.
> - Switchover can be triggered explicitly by deleting an initiator device.
> - Disconnecting from a target without unloading ib_srp is now possible.

Can you describe few use cases, HA tests which don't pass w.o these
patches and do pass or react better with them?

> Changes since v2:
[...]
> - Dropped the patches for integration with multipathd.
can you explain this please? are  these non SRP patches which we
submitted/accepted
through another maintainer? can you point on the upstream commits?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
