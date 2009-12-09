From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 9 Dec 2009 14:48:43 -0700
Message-ID: <20091209214843.GM6188@obsidianresearch.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <20091130133406.GA32123@mtls03> <adaiqcrx2xx.fsf@roland-alpha.cisco.com> <20091130190345.GV6188@obsidianresearch.com> <ada1vjaukx8.fsf@roland-alpha.cisco.com> <20091207172511.GA13496@mtls03> <adak4wwrmpq.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adak4wwrmpq.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2009 at 11:06:41AM -0800, Roland Dreier wrote:
> 
>  > It looks good to me. Thanks, I will take it for RDMAoE.
> 
> Great... as Jason suggested, please also add in the appropriate reserved
> fields to pad the struct to a 32 bit boundary and zero them in the
> wrapper.  So if there is a next time we don't have this problem again.

Also, if we really must do this, can you please send a patch to Roland
that at least adds the constants for IB, ASAP. Ideally to be included
in OFED 1.5.

At least that way people can make updates to check it prior to RDMAoE
actually appearing..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
