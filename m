From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Thu, 11 Mar 2010 10:59:13 -0800
Message-ID: <adaaaueelby.fsf@roland-alpha.cisco.com>
References: <20100310155749.GA25964@vlad-laptop>
	<A27E2E88-63A0-45EE-9A70-F95B2A0C25AD@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A27E2E88-63A0-45EE-9A70-F95B2A0C25AD-U0mLk4xYmo8@public.gmane.org> (=?utf-8?Q?=22?=
 =?utf-8?Q?H=C3=A5kon?= Bugge"'s
	message of "Thu, 11 Mar 2010 18:29:56 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?H=C3=A5kon?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Cc: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Did you consider my input in http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg02803.html wrt. to these enhancements?

I think we can worry about that if/when an HCA comes along that supports
global atomics for ordinary atomics but not enhanced atomics.  Although
perhaps it would be cleaner to change the atomic_cap enum to:

	/*
	 * IB_ATOMIC_NONE:	no atomic capability
	 * IB_ATOMIC_HCA:	all ops are atomic within HCA
	 * IB_ATOMIC_GLOB:	standard ops atomic with respect to all
				memory ops; masked ops atomic within HCA
	 * IB_ATOMIC_GLOB_MASKED: all ops atomic with respect to all
	 *			memory ops
	 */
	enum ib_atomic_cap {
		IB_ATOMIC_NONE,
		IB_ATOMIC_HCA,
		IB_ATOMIC_GLOB,
		IB_ATOMIC_GLOB_MASKED
	};

(with better wording for the comments)
Thoughts?

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
