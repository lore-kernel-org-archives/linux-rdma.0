From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/10] iw_cxgb4: Add driver, fw, and hw headers.
Date: Wed, 07 Apr 2010 14:33:58 -0700
Message-ID: <adahbnn0wxl.fsf@roland-alpha.cisco.com>
References: <20100402192346.14117.92767.stgit@build.ogc.int>
	<20100402192357.14117.39150.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100402192357.14117.39150.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Fri, 02 Apr 2010 14:23:57 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

You have:

 > +struct fw_ri_send_wr {
 ...
 > +	__be16 wrid;

 > +struct fw_ri_recv_wr {
 ...
 > +	__be16 wrid;

But also:

 > +static inline void init_wr_hdr(union t4_wr *wqe, u16 wrid,
 > +			       enum fw_wr_opcodes opcode, u8 flags, u8 len16)
 ...
 > +	wqe->send.wrid = wrid;

and similar for recv.wrid in qp.c.  sparse correctly warns about this
endianness clash.

The intention is that the device just treats wrid as opaque I assume so
I think the correct fix is to go from __be16 to u16 in the structure
declarations.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
