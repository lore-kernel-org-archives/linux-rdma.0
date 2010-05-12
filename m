From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] libibverbs: add path record definitions to sa.h
Date: Wed, 12 May 2010 16:17:14 -0700
Message-ID: <ada39xwu2v9.fsf@roland-alpha.cisco.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>
	<adapr18zmmj.fsf@roland-alpha.cisco.com>
	<63BD07796ED544AEAC6E41E669DC6EAC@amr.corp.intel.com>
	<870D78B1ADDD407388ADBFF921BCFAC6@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <870D78B1ADDD407388ADBFF921BCFAC6-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Wed, 12 May 2010 16:07:53 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I'd like to release a new version of librdmacm that can support the user space
 > SA query feature in 2.6.33, which will also be part of OFED 1.5.2.  Currently,
 > there's a dependency on the path record definition being part of libibverbs.  Do
 > you have any opinions on the best way to handle this?  I guess, ideally, I'd
 > like to see a released version of libibverbs include this, but I can think of
 > ways around this.

I can release an updated version of libibverbs (I have enough stuff
pending that this is probably a good idea anyway).  However could you do
some autoconf stuff so librdmacm works against older libibverbs (but
doesn't enable the stuff that can't be done without the missing stuff)?
Or maybe it's not worth it.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
