From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] libibverbs: add path record definitions to sa.h
Date: Wed, 12 May 2010 16:21:14 -0700
Message-ID: <68FF86CCA2A641EF83DFCBB57941D097@amr.corp.intel.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>	<adapr18zmmj.fsf@roland-alpha.cisco.com>	<63BD07796ED544AEAC6E41E669DC6EAC@amr.corp.intel.com>	<870D78B1ADDD407388ADBFF921BCFAC6@amr.corp.intel.com> <ada39xwu2v9.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada39xwu2v9.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I can release an updated version of libibverbs (I have enough stuff
>pending that this is probably a good idea anyway).  However could you do
>some autoconf stuff so librdmacm works against older libibverbs (but
>doesn't enable the stuff that can't be done without the missing stuff)?
>Or maybe it's not worth it.

I'll see if I can figure out how to update the autoconf stuff correctly.
Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
