From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r calls
Date: Wed, 07 Jul 2010 11:54:00 -0700
Message-ID: <adatyobyvg7.fsf@roland-alpha.cisco.com>
References: <1278527821-14804-1-git-send-email-sdake@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278527821-14804-1-git-send-email-sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Steven
	Dake's message of "Wed, 7 Jul 2010 11:37:01 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The readdir POSIX api is not thread safe.  This presents problems in
 > multithreaded programs that use the libibverbs APIs.  This patch has been
 > tested with a libibverbs application (http://www.corosync.org) on
 > Mellanox MT26428 cards.

This is a bit vague.  Is the problem that other threads may do readdir()
while libibverbs initializes?

 >  #include "ibverbs.h"
 >  
 > +
 >  HIDDEN int abi_ver;

whitespace damage here.

 > +	buf = (struct dirent *)malloc(offsetof(struct dirent, d_name) + NAME_MAX + 1);

cast of void* is not needed.  Also it seems this could be alloca() and
simplify things (avoid error checking and freeing).

Thanks,
  Roland

-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
