From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address
 resolution
Date: Thu, 21 Oct 2010 09:27:03 +0200
Message-ID: <20101021072703.GA1912@mtldesk30>
References: <20100826141851.GI8795@mtldesk30>
 <adazku85dcf.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adazku85dcf.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 20, 2010 at 10:22:56PM -0700, Roland Dreier wrote:
> Just curious -- what's up with this change here?  Is this connected to
> IBoE support, or is this an independent fix?

It is required for proper distribution of IBoE multicast packets while
still not hurting the mlx4_en driver's operation.

> Also as far as I can tell this variable sgid is write-only (ie you do
> the ib_get_cached_gid() but then never do anything with the value that
> that returns).  Am I missing something subtle?
> 

It is not required in the context of this patch. It should have been
part of patch 12/12 which adds VLAN support, in which case it is used
to extract the required VLAN ID.
Roland, would you like me to send patches 8-12 again with this fixed?

> 
> Finally this patch would have been easier to review without extraneous
> whitespace noise like
> 

Sorry about that. I pass them through checkpatch but this must have
been hiden within the "line over ..." messages.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
