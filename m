From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: partitions / ib_read_bw
Date: Fri, 21 Jun 2013 17:18:37 -0600
Message-ID: <20130621231837.GB10637@obsidianresearch.com>
References: <AB9234BD-66C3-4D8E-93CA-5AF8D26818AB@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AB9234BD-66C3-4D8E-93CA-5AF8D26818AB-YOWKrPYUwWM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 21, 2013 at 09:48:31PM +0000, Coulter, Susan K wrote:

> The server shows it is populating ibv_qp_attr with the pkey(s) of any full partition it is a member of, 
> but the client does not get that same pkey in ibv_wc.

See the man page for ibv_poll_cq:

               uint16_t                pkey_index;     /* P_Key index (valid only for GSI QPs) */

Which is read to mean that pkey_index is never valid in user space
apps. (why we include it is beyond me)

You can test Pkey connectivity more directly by doing a GMP query to
something like the PMA on a node, using various PKeys. Invalid ones
will timeout, valid ones will work.

Take a look at python-rdma..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
