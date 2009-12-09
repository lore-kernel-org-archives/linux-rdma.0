From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 09 Dec 2009 11:06:41 -0800
Message-ID: <adak4wwrmpq.fsf@roland-alpha.cisco.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
	<20091125001136.GP6188@obsidianresearch.com>
	<20091130133406.GA32123@mtls03>
	<adaiqcrx2xx.fsf@roland-alpha.cisco.com>
	<20091130190345.GV6188@obsidianresearch.com>
	<ada1vjaukx8.fsf@roland-alpha.cisco.com>
	<20091207172511.GA13496@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091207172511.GA13496@mtls03> (Eli Cohen's message of "Mon, 7
	Dec 2009 19:25:11 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > It looks good to me. Thanks, I will take it for RDMAoE.

Great... as Jason suggested, please also add in the appropriate reserved
fields to pad the struct to a 32 bit boundary and zero them in the
wrapper.  So if there is a next time we don't have this problem again.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
