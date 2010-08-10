From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma cm + XRC
Date: Tue, 10 Aug 2010 10:22:54 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C106@orsmsx501.amr.corp.intel.com>
References: <4C5331DC.9080109@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
 <4C618334.7010106@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com>
 <20100810171405.GM11306@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100810171405.GM11306-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > There's a ai_qp_type field available.  I think the RDMA TCP port
> > space would work.
> 
> Not sure the port space matters at all?
> 
> Is there anything additional CM information for XRC other than
> requesting an XRC QP type? (XRCSRQ or something?)

It's nothing huge:

Modifications to Table 99:
* Responder Resources field, Values column: 0 for XRC
* Transport Service Type field, Description column: See
  Section 14.6.3.1 Transport Service Type.
* Retry Count field, Values column: 0 for XRC
* RNR Retry Count field, Values column: 0 for XRC
* SRQ field, Values column: 0 for XRC
* Change (reserved) field at position byte 51, bit 5 to:
  * Field: Extended Transport Type
  * Description: See Section 14.6.3.2 Extended Transport Type
  * Used for Purpose: C
  * Byte [Bit] Offset: 51 [5]
  * Length, Bits: 3

Modifications to Table 103:
* Initiator Depth field, Values column: 0 for XRC
* End-to-End Flow Control field, Values column: 0 for XRC
* SRQ field, Values column: 1 for XRC

But should still be set correctly.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
