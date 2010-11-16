From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Tue, 16 Nov 2010 20:03:41 +0200
Message-ID: <20101116180341.GA29132@mtldesk30>
References: <20101115140829.GA20355@mtldesk30>
 <AANLkTi=zJsFjbrZrpj-E65T49ewgqdia+MOPnqmgx5KW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=zJsFjbrZrpj-E65T49ewgqdia+MOPnqmgx5KW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 16, 2010 at 11:38:45AM +0200, Aleksey Senin wrote:
> On Mon, Nov 15, 2010 at 4:08 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> Don't you need to do the same when detaching?

Yes, indeed. It was in the original OFED patch but somehow I failed to
include that hunk.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
