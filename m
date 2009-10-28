From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] [RFC] rdma/cm: support option to allow manually setting IB path
Date: Wed, 28 Oct 2009 11:11:22 -0700
Message-ID: <adaiqdzs81h.fsf@cisco.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>
	<A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com>
	<20091020181458.GD14520@obsidianresearch.com>
	<46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com>
	<20091020191404.GH14520@obsidianresearch.com>
	<9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com>
	<20091022004245.GV14520@obsidianresearch.com>
	<AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com>
	<20091022013542.GX14520@obsidianresearch.com>
	<B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com>
	<DC0770A17FDC4DACAC0251A3362CE87A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DC0770A17FDC4DACAC0251A3362CE87A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Thu, 22 Oct 2009 13:26:37 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This looks fine to me... the only thing I could wonder about is:

 > +	RDMA_OPTION_ID_TOS	= 0,
 > +
 > +	RDMA_OPTION_IB_PATH	= 1

why a blank line here? ;)

Jason and Or, does this seem ready to queue for 2.6.33?

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
