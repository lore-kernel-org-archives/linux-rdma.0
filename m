From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/uverbs: Support for XRC
Date: Wed, 27 Jan 2010 08:00:48 -0800
Message-ID: <ada8wbjo7v3.fsf@roland-alpha.cisco.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>
	<1264446094-4460-3-git-send-email-rolandd@cisco.com>
	<4B5EFEAD.9040702@Voltaire.com>
	<aday6jko26n.fsf@roland-alpha.cisco.com>
	<4B6003B2.4040101@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6003B2.4040101-smomgflXvOZWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Wed, 27
	Jan 2010 11:13:22 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > > OK, but we should coordinate this with all the other ABI extensions
 > > that OFED has already made

 > I believe the only thing I need to coordinate with is the XRC patch
 > set.

I think the IBoE patches in the OFED branch also extend the ABI.  we
should try to avoid stepping on that too.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
