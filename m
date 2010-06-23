From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] various fixes for QIB driver
Date: Wed, 23 Jun 2010 11:14:28 -0700
Message-ID: <adavd99ty4b.fsf@roland-alpha.cisco.com>
References: <20100617231338.8006.18131.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100617231338.8006.18131.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 17 Jun 2010 16:13:38 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > The following patches are for various bug fixes.
 > I'm not sure what counts as a regression for code that is newly introduced.
 > I'm hoping that all except #2 can be made for 2.6.35 whereas
 > #2 can wait for 2.6.36 since it is actually a feature.

All except #2 look OK for 2.6.35.  I'll hold #2 for 2.6.36 -- I hope
it's independent?

In the future it might be cleaner to send a series 1-6 of fixes for
2.6.35 and then send the port assignment one as a 2.6.36 patch separate
from the series.  (No need to resend here)

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
