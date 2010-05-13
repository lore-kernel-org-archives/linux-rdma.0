From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Thu, 13 May 2010 08:50:11 -0700
Message-ID: <adapr0zsswc.fsf@roland-alpha.cisco.com>
References: <4B12AA78.7090401@gmail.com>
	<ada8wbzi490.fsf@roland-alpha.cisco.com> <4BCFFC48.4060401@gmail.com>
	<adazl0c92kp.fsf@roland-alpha.cisco.com> <4BEC06DB.30505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BEC06DB.30505-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Alex Vainman's message of "Thu, 13
	May 2010 17:04:11 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Maybe we should use the /proc/pid/pagemap and /proc/kpageflags files?
 > These files let a userspace process find out which physical frame
 > each virtual page is mapped to and to get the properties of each page
 > frame including the page size.

Sounds interesting... the only problem is that /proc/kpageflags is
root-only, so we can't use that.  But does /proc/pid/pagemap give enough
information to be useful?

 > The disadvantage of this method is, that it applicable on kernel >=
 > 2.6.25, since this interface is supported starting from the kernel
 > 2.6.25.

I think that's OK
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
