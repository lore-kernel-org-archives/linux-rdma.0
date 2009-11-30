From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Mon, 30 Nov 2009 10:50:02 -0800
Message-ID: <adaiqcrx2xx.fsf@roland-alpha.cisco.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
	<20091125001136.GP6188@obsidianresearch.com>
	<20091130133406.GA32123@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091130133406.GA32123@mtls03> (Eli Cohen's message of "Mon, 30
	Nov 2009 15:34:06 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > If we change struct ibv_port_attr transport field from enum to uint8,
 > we eliminate binary compatibility problems. That's because the previous
 > filed is aligned to 16 bits address so that leaves us 16 bits more.
 > 
 > diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
 > index 07d4395..f7fe68d 100644
 > --- a/include/infiniband/verbs.h
 > +++ b/include/infiniband/verbs.h
 > @@ -192,7 +192,7 @@ struct ibv_port_attr {
 >         uint8_t                 active_width;
 >         uint8_t                 active_speed;
 >         uint8_t                 phys_state;
 > -       enum rdma_transport_type transport;
 > +       uint8_t                 transport;
 >  };

Do all architectures round up the structure size?  ie is this always
going to preserve ABI?

 > Moreover, I would like to change the field's name from transport to
 > link_protocl. Let me know if that makes more sense to you.

I was thinking the same thing, although maybe a name like "link_layer"
would be clearer?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
