From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 12/51] IB/qib: Add qib_dma.c
Date: Thu, 8 Apr 2010 13:40:24 -0700
Message-ID: <1270759224.2278.0.camel@chromite.mv.qlogic.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	 <20091203190408.29507.27708.stgit@chromite.mv.qlogic.com>
	 <adaljcz43n9.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaljcz43n9.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OK. This will be in v3.

On Wed, 2010-03-31 at 16:18 -0700, Roland Dreier wrote:
> > +struct ib_dma_mapping_ops qib_dma_mapping_ops = {
>  > +	qib_mapping_error,
>  > +	qib_dma_map_single,
>  > +	qib_dma_unmap_single,
>  > +	qib_dma_map_page,
>  > +	qib_dma_unmap_page,
>  > +	qib_map_sg,
>  > +	qib_unmap_sg,
>  > +	qib_sg_dma_address,
>  > +	qib_sg_dma_len,
>  > +	qib_sync_single_for_cpu,
>  > +	qib_sync_single_for_device,
>  > +	qib_dma_alloc_coherent,
>  > +	qib_dma_free_coherent
>  > +};
> 
> I think it would be better to use designated initializers (".xxx = yyy,")
> here to avoid problems if this struct ever changes layout.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
