From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH] infiniband: qib: Missing linux/slab.h include
Date: Thu, 05 Aug 2010 12:09:46 -0700 (PDT)
Message-ID: <20100805.120946.45921714.davem@davemloft.net>
References: <20100804.225552.241946831.davem@davemloft.net>
	<adafwyt58ft.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adafwyt58ft.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Date: Thu, 05 Aug 2010 09:29:58 -0700

> No objection to adding this and I will include it for my next pull.  But
> out of curiousity what arch are you seeing this on?  I'm not seeing any
> problems on x86 and I haven't heard any complaints about -next so I'm
> curious what the error you're seeing is.

sparc64 allmodconfig
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
