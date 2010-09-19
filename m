From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [stable] [PATCH 2.6.36] RDMA/cxgb3: Turn off rx coalescing for
	iwarp connections.
Date: Sat, 18 Sep 2010 20:58:30 -0700
Message-ID: <20100919035830.GB30706@kroah.com>
References: <20100919003821.11904.91366.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100919003821.11904.91366.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 18, 2010 at 07:38:21PM -0500, Steve Wise wrote:
> The HW by default has RX coalescing on.  For iwarp connections, this was
> causing a 100ms delay in connection establishement due to the ingress
> MPA Start message being stalled in HW.  So explicitly turn rx coalescing
> off when setting up iwarp connections.
> 
> This was causing very bad performance for NP64 gather operations using
> OpenMPI due to the way it sets up connections on larger jobs.
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---

Please read Documentation/stable_kernel_rules.txt for how to get a patch
into the stable tree.  Hint, you are close, but this isn't going to work
this way...

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
