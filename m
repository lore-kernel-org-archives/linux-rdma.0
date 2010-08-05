From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband: qib: Missing linux/slab.h include
Date: Thu, 05 Aug 2010 14:19:37 -0700
Message-ID: <adaeiec4v12.fsf@roland-alpha.cisco.com>
References: <20100804.225552.241946831.davem@davemloft.net>
	<adafwyt58ft.fsf@roland-alpha.cisco.com>
	<20100805.120946.45921714.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100805.120946.45921714.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> (David Miller's
	message of "Thu, 05 Aug 2010 12:09:46 -0700 (PDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > No objection to adding this and I will include it for my next pull.  But
 > > out of curiousity what arch are you seeing this on?  I'm not seeing any
 > > problems on x86 and I haven't heard any complaints about -next so I'm
 > > curious what the error you're seeing is.

 > sparc64 allmodconfig

Got it.  Interestingly x86, powerpc and ia64 all include linux/slab.h
via asm/pci.h (for no very obvious reason that I can see from a quick
look at what their asm/pci.h have), which is why I missed this.

anyway, applied your patch and will pass on to Linus shortly.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
