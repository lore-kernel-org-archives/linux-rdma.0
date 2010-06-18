From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] allow passthrough of rmpp packets to user mad
	clients
Date: Fri, 18 Jun 2010 10:38:42 -0600
Message-ID: <20100618163842.GJ4630@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8@MNEXMB1.qlogic.org> <adask52o9p6.fsf@roland-alpha.cisco.com> <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C2F@MNEXMB1.qlogic.org> <20100618154134.GA12884@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF259E5A7B73@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF259E5A7B73-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 18, 2010 at 09:33:01AM -0700, Hefty, Sean wrote:
> > Why not just add byte-stream like APIs to the kernel interface for
> > RMPP?
> 
> RMPP is more like IP segmentation than TCP segmentation.

Why do you say that?

Each RMPP session is identified by a unique, ID, can run transfer data
in both directions, does reassembly, re-ordering, re-transmit, and can 
transfer unbounded amounts of data, without knowing how much in
advance.

Sounds exactly like TCP to me..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
