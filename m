From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/iser: fix max_sectors calculation
Date: Thu, 28 Apr 2016 10:33:02 +0300
Message-ID: <CAJ3xEMiVfsWCEF9xX-aEExNGkF+Uxp+6udyJheKrh82Ebm0i+Q@mail.gmail.com>
References: <1461013588-8825-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461013588-8825-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 12:06 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> iSER currently has a couple places that set max_sectors in either the host
> template or SCSI host, and all of them get it wrong.
>
> This patch instead uses a single assignment that (hopefully) gets it right:
> the max_sectors value must be derived from the number of segments in the
> FR or FRM structure, but actually be one lower than the page size multiplied
> by the number of sectors, as it has to handle the case of non-aligned I/O.
>
> Without this I get trivivial to reproduce hangs when running xfstests
> (on XFS) over iSER to Linux targets.

nit, trivivial  --> trivial, please fix

Sagi, Christoph,

You mentioned stable kernels, can you  spot the breakage point?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
