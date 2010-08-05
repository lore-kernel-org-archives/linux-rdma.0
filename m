From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband: qib: Missing linux/slab.h include
Date: Thu, 05 Aug 2010 09:29:58 -0700
Message-ID: <adafwyt58ft.fsf@roland-alpha.cisco.com>
References: <20100804.225552.241946831.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100804.225552.241946831.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> (David Miller's
	message of "Wed, 04 Aug 2010 22:55:52 -0700 (PDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  > Without this I'm getting build errors with Linus's current tree.
  > Apologies if this is already fixed in the RDMA git tree.
  > 
  > diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
  > index 3593983..312ca9a 100644
  > --- a/drivers/infiniband/hw/qib/qib.h
  > +++ b/drivers/infiniband/hw/qib/qib.h
  > @@ -45,6 +45,7 @@
  >  #include <linux/mutex.h>
  >  #include <linux/list.h>
  >  #include <linux/scatterlist.h>
  > +#include <linux/slab.h>

No objection to adding this and I will include it for my next pull.  But
out of curiousity what arch are you seeing this on?  I'm not seeing any
problems on x86 and I haven't heard any complaints about -next so I'm
curious what the error you're seeing is.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
