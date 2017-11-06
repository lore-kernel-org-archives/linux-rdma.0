From: Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] svcrdma: Enqueue after setting XPT_CLOSE in completion
 handlers
Date: Mon, 6 Nov 2017 10:19:44 -0500
Message-ID: <20171106151944.GC599@fieldses.org>
References: <20171027144743.15444.3407.stgit@klimt.1015granger.net>
 <CANjDDBi15wrUqnnpgBabwQLg1iz92PJkbt6vN9OBFK9E2Ng5SQ@mail.gmail.com>
 <28EB7B95-5EF6-41D0-8910-6BC7784CE28E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <28EB7B95-5EF6-41D0-8910-6BC7784CE28E-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 03, 2017 at 05:19:30PM -0400, Chuck Lever wrote:
> Hi Bruce-
> 
> > On Oct 28, 2017, at 3:43 AM, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
> > 
> > looks good
> > 
> > Reveiwed-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> > 
> > On Fri, Oct 27, 2017 at 8:19 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >> I noticed the server was sometimes not closing the connection after
> >> a flushed Send. For example, if the client responds with an RNR NAK
> >> to a Reply from the server, that client might be deadlocked, and
> >> thus wouldn't send any more traffic. Thus the server wouldn't have
> >> any opportunity to notice the XPT_CLOSE bit has been set.
> >> 
> >> Enqueue the transport so that svcxprt notices the bit even if there
> >> is no more transport activity after a flushed completion, QP access
> >> error, or device removal event.
> >> 
> >> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >> ---
> >> net/sunrpc/xprtrdma/svc_rdma_transport.c |   11 ++++++++---
> >> 1 file changed, 8 insertions(+), 3 deletions(-)
> >> 
> >> Hi Bruce-
> >> 
> >> Please consider this patch for v4.15. Thanks!
> 
> I notice nfsd-next does not have this patch. Is there anything
> else I need to do? Should I resend with Devesh's Reviewed-by
> tag?

Thanks for the reminder; applied for 4.15 with Devesh's Reviewed-by.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
