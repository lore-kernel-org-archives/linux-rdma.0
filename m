From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 09/12] xprtrdma: Prepare rpcrdma_ep_post() for
 RDMA_NOMSG calls
Date: Fri, 10 Jul 2015 16:44:02 -0600
Message-ID: <20150710224402.GA8342@obsidianresearch.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204305.26247.39173.stgit@manet.1015granger.net>
 <CANjDDBh38PrxGgWGuKYCYcbjqY9ELrpkGqaRZ_ueKfD7FEQP8g@mail.gmail.com>
 <559FC17A.7060502@talpey.com>
 <CANjDDBipaXMO7Z5wirG127E9kQ0aHdWJ1s6ZM21th5RWLNh-4Q@mail.gmail.com>
 <F5F5CAC4-866E-4BCA-8094-908CE9ED3B4B@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F5F5CAC4-866E-4BCA-8094-908CE9ED3B4B-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2015 at 10:53:40AM -0400, Chuck Lever wrote:

> It is certainly possible to examine the device=E2=80=99s max_sge fiel=
d
> in rpcrdma_ep_create() and fail transport creation if the
> device=E2=80=99s max_sge is less than RPC_MAX_IOVS.

I just want to draw Sagi's attention to this problem, when considering
my thoughts on an alternate API for posting.

This thread is about NFS needing 4 sges for a (rare?) message type.

The API direction I suggested addresses this kind of issue as well,
because under the covers the driver/core can spin up a temporary MR
for this case and thus support an infinite s/g list for all posts.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
