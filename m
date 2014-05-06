From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH V2 RFC 0/3] svcrdma: refactor marshalling logic
Date: Tue, 6 May 2014 15:27:30 -0400
Message-ID: <20140506192730.GK18281@fieldses.org>
References: <20140506174621.18208.24242.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140506174621.18208.24242.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 06, 2014 at 12:46:21PM -0500, Steve Wise wrote:
> This patch series refactors the NFSRDMA server marshalling logic to
> remove the intermediary map structures.  It also fixes an existing bug
> where the NFSRDMA server was not minding the device fast register page
> list length limitations.
> 
> I've also made a git repo available with these patches on top of 3.15-rc4:
> 
> git://git.openfabrics.org/~swise/linux svcrdma-refactor
> 
> Changes since V1:
> 
> - fixed regression for devices that don't support FRMRs (see
>   rdma_read_chunk_lcl())
> 
> - split patch up for closer review.  However I request it be squashed
>   before merging as they is not bisectable, and I think these changes
>   should all be a single commit anyway.

If it's not split up in a way that's bisectable, then yes, just don't
bother.

--b.

> 
> Please review, and test if you can.
> 
> Signed-off-by: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 
> ---
> 
> Tom Tucker (3):
>       svcrdma: Sendto changes
>       svcrdma: Recvfrom changes
>       svcrdma: Transport and header file changes
> 
> 
>  include/linux/sunrpc/svc_rdma.h          |    3 
>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  633 ++++++++++++------------------
>  net/sunrpc/xprtrdma/svc_rdma_sendto.c    |  230 +----------
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |   62 ++-
>  4 files changed, 318 insertions(+), 610 deletions(-)
> 
> -- 
> 
> Steve / Tom
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
