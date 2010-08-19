From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Userspace MMU Notification
Date: Thu, 19 Aug 2010 10:19:08 -0700
Message-ID: <adamxsisepf.fsf@roland-alpha.cisco.com>
References: <20100819163206.GA3194@mgebm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100819163206.GA3194-CVBTeua0HjReoWH0uzbU5w@public.gmane.org> (Eric B. Munson's message of
	"Thu, 19 Aug 2010 17:32:06 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-CVBTeua0HjReoWH0uzbU5w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dykman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > During the .35 merge window I attempted to merge the ummunotify driver and
 > was told by Linus that he didn't like the approach.  At that point several
 > members of the RDMA community were hashing out a way to do the same thing
 > that would get Linus' blessing.  I haven't seen anything about it since and
 > I am curious if any decisions were made.

I am implementing a similar mechanism in the uverbs driver.  I hope to
have something done in time to review it for the 2.6.37 window.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
