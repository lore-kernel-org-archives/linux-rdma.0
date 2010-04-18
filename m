From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ummunotify: fix umn-test build
Date: Sun, 18 Apr 2010 07:38:06 -0700
Message-ID: <ada633oltbl.fsf@roland-alpha.cisco.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
	<20100414094341.ba69842d.randy.dunlap@oracle.com>
	<20100417174404.GB3579@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100417174404.GB3579-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> (Eric B. Munson's message of
	"Sat, 17 Apr 2010 21:44:05 +0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eric, sorry for not seeing this earlier, but it looks like the last
patch I emailed out did not include all the tiny changes I made prior to
asking Linus to pull this (which he ended up not doing).  For example
this fix to the include Kbuild file was there.

You could look at:
http://git.kernel.org/?p=linux/kernel/git/roland/infiniband.git;a=commit;h=cfe60a43c3434907a47323fb82d2960e915a9538

to see what was actually in my pull request.  There may be other trivial
tweaks worth including.

Thanks for resurrecting this work BTW.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
