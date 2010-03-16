From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Tue, 16 Mar 2010 16:49:05 -0700
Message-ID: <adaeijj96a6.fsf@roland-alpha.cisco.com>
References: <20100310155749.GA25964@vlad-laptop>
	<A27E2E88-63A0-45EE-9A70-F95B2A0C25AD@Sun.com>
	<adaaaueelby.fsf@roland-alpha.cisco.com>
	<BA082DF0-B3C6-4405-B480-F69B0193BF17@Sun.COM>
	<adavdd1a64g.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavdd1a64g.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org> (Roland Dreier's message
	of "Fri, 12 Mar 2010 07:53:35 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?H=C3=A5kon?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Cc: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Hence, I think it would be cleaner if a new capability,
 > masked_atomic_cap, were introduced, using the original definitions
 > (NONE, HCA, GLOB).

Vlad, what do you think about that?  The more I think about it, the
cleaner this seems to me.  And it doesn't even consume a device
capability flag bit, which is a nice bonus.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
