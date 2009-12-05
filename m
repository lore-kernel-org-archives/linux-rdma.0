From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Fri, 4 Dec 2009 21:16:07 -0700
Message-ID: <20091205041607.GT1966@obsidianresearch.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <20091130133406.GA32123@mtls03> <adaiqcrx2xx.fsf@roland-alpha.cisco.com> <20091130190345.GV6188@obsidianresearch.com> <ada1vjaukx8.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada1vjaukx8.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 04, 2009 at 08:03:31PM -0800, Roland Dreier wrote:

> then I think legacy apps should be OK (port_attr size doesn't change,
> binary compat is still there), and new apps that do check link_layer
> should also be OK ... if they use an old library and/or old driver,
> they'll see LINK_LAYER_UNSPECIFIED, which means that IBoE is not supported.
> 
> What do you think, does this work?

Yeah, that should be fine, quite sneaky indeed..

Maybe zero the whole padding though, for future?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
