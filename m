From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma cm + XRC
Date: Tue, 10 Aug 2010 16:18:57 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A960131B@orsmsx501.amr.corp.intel.com>
References: <4C5331DC.9080109@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
 <4C618334.7010106@systemfabricworks.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com>
 <20100810171405.GM11306@obsidianresearch.com>
 <4C61BF26.9060003@systemfabricworks.com>
 <20100810225435.GA2999@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100810225435.GA2999-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Well.. the XRC domain needs to be an input to create_ep just like
> the PD :(
> 
> In looking at how this API turned out maybe the PD should have been
> carried in the rdma_addrinfo? Certainly I would put the XRC domain
> in there.. Recall my original comments about the PD being used to
> restrict device selection in rdma_getaddrinfo.

Personally, if I had it to do over, I don't know that I would have exposed the PD through the librdmacm at all.  Does anyone ever allocate more than one per device?

I feel similarly about the XRC domain.  Is there any real reason to expose it?  What if we just defined a 1:1 relationship between PDs and XRC domains, or between XRC domains and XRC TGT QPs?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
