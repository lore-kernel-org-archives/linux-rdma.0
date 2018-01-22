From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 1/2] rdma/ib: Add trace point macros to display
 human-readable values
Date: Mon, 22 Jan 2018 10:47:09 -0700
Message-ID: <20180122174709.GE14372@ziepe.ca>
References: <20180120161440.6488.4311.stgit@manet.1015granger.net>
 <20180120161625.6488.7416.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180120161625.6488.7416.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 20, 2018 at 11:16:25AM -0500, Chuck Lever wrote:
> These can be shared with all kernel ULPs, and more can easily be
> added as needed.
> 
> Note: checkpatch.pl has some heartburn with the TRACE_DEFINE_ENUM
> macros and the LIST macros. These follow the same style as other
> header files under include/tracing/events , thus should be
> considered acceptable exceptions.
> 
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>  include/trace/events/rdma.h |  129 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 129 insertions(+)
>  create mode 100644 include/trace/events/rdma.h

Not knowing a lout about trace points, this does seem OK to me:

Acked-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

To flow through Anna's tree

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
