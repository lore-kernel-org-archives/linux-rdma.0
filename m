From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 22:53:17 -0700
Message-ID: <adatys62rle.fsf@roland-alpha.cisco.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com>
	<20100323165920.GH29129@obsidianresearch.com>
	<D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> (Jeff Squyres's
	message of "Tue, 23 Mar 2010 13:17:40 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > What do you poll on the fd for?

 > With ummunotify, you only read() from the fd when (counter !=
 > last_counter).  Were you thinking that the poll() would be for
 > something else?

The ummunotify fd supported poll() (and SIGIO etc).  You don't have to
use it if you don't want to, but I made it as much of a normal fd as
possible.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
