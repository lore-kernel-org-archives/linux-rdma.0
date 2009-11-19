From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/9 v2] ib/addr: verify source and destination address families match
Date: Wed, 18 Nov 2009 17:30:05 -0800
Message-ID: <adaskcb8foi.fsf@roland-alpha.cisco.com>
References: <4329E49DC571489C9F9498770613E42D@amr.corp.intel.com>
	<75A0BA738B5E4574AC17BB674109FBB2@amr.corp.intel.com>
	<adaws1n8h3e.fsf@roland-alpha.cisco.com>
	<7F0D72D35EF140058670BF8E228966B8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F0D72D35EF140058670BF8E228966B8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Wed, 18 Nov 2009 17:27:37 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > I can go either way here - either update the comments in the header file, or
 > allow passing in NULL.  Do you or does anyone else have a preference?

I don't have a strong preference.  Or really any preference, except
maybe generally favoring interface stability -- ie keep doing what we've
been doing and leave src_addr as optional.  OTOH we could kill the
never-triggered test for src_addr and follow experience with the
interface.  Basically I don't know... whatever you'd rather do is fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
