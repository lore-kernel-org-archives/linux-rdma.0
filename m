From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibverbs] Align Flow Steering API to the extension
 verbs scheme
Date: Thu, 15 May 2014 09:30:16 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1405150929390.24421@gentwo.org>
References: <1400075090-14296-1-git-send-email-ogerlitz@mellanox.com> <1400075090-14296-2-git-send-email-ogerlitz@mellanox.com> <20140514160804.GC6253@obsidianresearch.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140514160804.GC6253-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 14 May 2014, Jason Gunthorpe wrote:

> >  /**
> > diff --git a/man/ibv_create_flow.3 b/man/ibv_create_flow.3
> > new file mode 100644
> > index 0000000..f7c767e
> > +++ b/man/ibv_create_flow.3
> > @@ -0,0 +1,86 @@
> > +.TH IBV_CREATE_FLOW 3 2013-08-21 libibverbs "Libibverbs
> > Programmer's Manual"
>
> Christoph: can you, as a user of this API, give the man page a quick
> read to check that it captures everything?

Looks fine to us.

Reviewed-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
