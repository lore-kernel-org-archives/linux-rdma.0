From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs v6 6/7] libibverbs: Add man page for
 ibv_open_qp
Date: Tue, 4 Jun 2013 14:54:13 -0600
Message-ID: <20130604205413.GB30182@obsidianresearch.com>
References: <1370371791-15018-1-git-send-email-sean.hefty@intel.com>
 <1370371791-15018-7-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370371791-15018-7-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 04, 2013 at 11:49:50AM -0700, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

> +struct ibv_qp_open_attr {
> +.in +8
> +uint32_t          comp_mask;  /* Identifies valid fields */

Since the user is expected to set comp_mask we should clearly document
what it should be set to.

> +uint32_t          qp_num;     /* QP number */
> +void             *qp_context; /* Associated context of the QP */

Would be nice to clarify what this value is too. I took a quick peak
and it wasn't clear to me. The XRC example does not use it.

Is it a user defined cookie? If so can we call it a cookie instead?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
