From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ib/ipoib: remove TX moderation from the ethtool related code
Date: Wed, 20 Jan 2010 08:53:04 -0800
Message-ID: <ada8wbs3ehb.fsf@roland-alpha.cisco.com>
References: <Pine.LNX.4.64.1001111118260.27317@zuben.voltaire.com>
	<4B5725AE.5090505@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B5725AE.5090505-smomgflXvOZWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Wed, 20
	Jan 2010 17:47:58 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > > As of commit f56bcd8 "IPoIB: Use separate CQ for UD send completions",
 > > there are no TX interrupts at the main code path. Change the ethtool
 > > related code to comply with this, such the users will not be misleaded
 > > to assume they can control TX interrupt moderation. 
 > Hi Roland, did you had the chance to look on this one?

Yes, looks fine, planning to merge it for 2.6.34.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
