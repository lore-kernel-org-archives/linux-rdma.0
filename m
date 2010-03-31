From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 12/51] IB/qib: Add qib_dma.c
Date: Wed, 31 Mar 2010 16:18:20 -0700
Message-ID: <adaljcz43n9.fsf@roland-alpha.cisco.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	<20091203190408.29507.27708.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +struct ib_dma_mapping_ops qib_dma_mapping_ops = {
 > +	qib_mapping_error,
 > +	qib_dma_map_single,
 > +	qib_dma_unmap_single,
 > +	qib_dma_map_page,
 > +	qib_dma_unmap_page,
 > +	qib_map_sg,
 > +	qib_unmap_sg,
 > +	qib_sg_dma_address,
 > +	qib_sg_dma_len,
 > +	qib_sync_single_for_cpu,
 > +	qib_sync_single_for_device,
 > +	qib_dma_alloc_coherent,
 > +	qib_dma_free_coherent
 > +};

I think it would be better to use designated initializers (".xxx = yyy,")
here to avoid problems if this struct ever changes layout.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
