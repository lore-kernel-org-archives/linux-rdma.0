From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] svcrdma: Remove extra writeargs sanity check for
 NFSv2/3
Date: Fri, 11 Jul 2014 14:49:30 -0400
Message-ID: <20140711184929.GC9775@fieldses.org>
References: <20140710174225.3734.44692.stgit@klimt.1015granger.net>
 <20140710174435.3734.69638.stgit@klimt.1015granger.net>
 <20140710181944.GB26561@fieldses.org>
 <3BA364F8-E5ED-45A1-8662-E5F91AA7AF0A@oracle.com>
 <20140710184948.GC26561@fieldses.org>
 <B89AB7AC-32E1-4944-9287-73958A569A8E@oracle.com>
 <20140710194349.GD26561@fieldses.org>
 <F8AD3320-C653-4713-965F-FE52FF0D49CA@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F8AD3320-C653-4713-965F-FE52FF0D49CA-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 10, 2014 at 04:43:54PM -0400, Chuck Lever wrote:
> I think the sanity check you pointed out is strictly satisfied by
> testing against the unaligned number of bytes. Is there a strong
> reason to do the extra math for that check during each WRITE?

I can't think of any good reason why the check should be against the
rounded-up length.

So my worry was just a more general "uh-oh, a non-multiple-of-4-length
is pretty weird, future me may not remember that's a possibility."

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
