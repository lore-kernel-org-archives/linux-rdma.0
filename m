From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Wed, 18 Aug 2010 15:41:20 -0700
Message-ID: <adar5hvsfvz.fsf@roland-alpha.cisco.com>
References: <4C5331DC.9080109@systemfabricworks.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com>
	<4C618334.7010106@systemfabricworks.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com>
	<20100810171405.GM11306@obsidianresearch.com>
	<4C61BF26.9060003@systemfabricworks.com>
	<20100810225435.GA2999@obsidianresearch.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A960131B@orsmsx501.amr.corp.intel.com>
	<20100810232339.GO11306@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100810232339.GO11306-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Tue, 10 Aug 2010 17:23:39 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > I feel similarly about the XRC domain.  Is there any real reason to
 > > expose it?  What if we just defined a 1:1 relationship between PDs
 > > and XRC domains, or between XRC domains and XRC TGT QPs?

 > Near as I can tell it serves the same purpose as the PD, to provide
 > a form of security within a single process..

No, XRC domains can be shared between different processes -- that's kind
of the point of XRCs.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
