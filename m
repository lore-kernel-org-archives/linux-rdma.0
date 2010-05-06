From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix chunk sg list overflow in mlx4_alloc_icm()
Date: Thu, 06 May 2010 09:08:32 -0700
Message-ID: <adaljbx9fnj.fsf@roland-alpha.cisco.com>
References: <20100430132131.0d829b3c@frecb007965>
	<adatyqmmej0.fsf@roland-alpha.cisco.com>
	<20100506080453.43594a4b@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506080453.43594a4b@frecb007965> (sebastien dugue's message
	of "Thu, 6 May 2010 08:04:53 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 >  Yes, some customer got hit by this, which ended up corrupting memory.

I'll tag it for stable kernels too then.  Thanks.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
