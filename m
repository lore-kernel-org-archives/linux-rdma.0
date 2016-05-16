From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure
 dynamic
Date: Mon, 16 May 2016 08:52:16 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org>
References: <20160315155441.222586021@linux.com> <20160315155455.173645653@linux.com> <057c8ac8-1d34-e7b9-c0ad-91d805c81139@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <057c8ac8-1d34-e7b9-c0ad-91d805c81139-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 13 May 2016, Doug Ledford wrote:

> I don't like this entire chunk.  Please handle both the cxgb3 and cxgb4
> changes like you did the mlx4 changes.  Specifically, use an enum to
> define the array index for names and an array of offsets so that the
> textual names from the enum can be used to access the array.  The way
> things are here is horribly fragile.

Ok but I cannot separate this out in a a distinct patch.

> Secondly, do *not* use a BUG_ON in this patch.  I saw at least two of
> them.  There is nothing in this patch so serious that we should crash
> the kernel.  Any failure here is something we can work around and keep
> running.

WARN_ON_ONCE then?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
