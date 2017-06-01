From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/mlx4: Fix MAD tunneling when SRIOV is enabled
Date: Thu, 01 Jun 2017 18:30:03 -0400
Message-ID: <1496356203.7171.71.camel@redhat.com>
References: <20170521161113.20772-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170521161113.20772-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-05-21 at 19:11 +0300, Leon Romanovsky wrote:
> The cited patch added a type field to structures ib_ah and
> rdma_ah_attr.
> 
> Function mlx4_ib_query_ah() builds an rdma_ah_attr structure from the
> data in an mlx4_ib_ah structure (which contains both an ib_ah
> structure
> and an address vector).
> 
> For mlx4_ib_query_ah() to work properly, the type field in the
> contained
> ib_ah structure must be set correctly.
> 
> In the outgoing MAD tunneling flow, procedure mlx4_ib_multiplex_mad()
> paravirtualizes a MAD received from a slave and sends the processed
> mad out over the wire. During this processing, it populates an
> mlx4_ib_ah structure and calls mlx4_ib_query_ah().
> 
> The cited commit overlooked setting the type field in the contained
> ib_ah structure before invoking mlx4_ib_query_ah(). As a result, the
> type field remained uninitialized, and the rdma_ah_attr structure was
> incorrectly built. This resulted in improperly built MADs being sent
> out
> over the wire.
> 
> This patch properly initializes the type field in the contained ib_ah
> structure before calling mlx4_ib_query_ah(). The rdma_ah_attr
> structure
> is then generated correctly.
> 
> Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr
> types")
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
