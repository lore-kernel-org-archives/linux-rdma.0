From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Mon, 12 Apr 2010 22:20:48 +0200
Message-ID: <20100412202047.GD2305@elf.ucw.cz>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1271053337-7121-1-git-send-email-ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi!

> I am resubmitting this patch because I believe that the discussion
> has shown this to be an acceptable solution.  I have fixed the 32 bit
> build errors, but other than that change, the code is the same as
> Roland's V3 patch.
> 
> From: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> 
> As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
> and follow-up messages, libraries using RDMA would like to track
> precisely when application code changes memory mapping via free(),
> munmap(), etc.  Current pure-userspace solutions using malloc hooks
> and other tricks are not robust, and the feeling among experts is that
> the issue is unfixable without kernel help.

I do not know. I still believe that this does not belong in the
kernel; application should not need to trace itself to know what it does.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
