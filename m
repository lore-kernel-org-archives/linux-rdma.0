From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/uverbs: Support for XRC
Date: Tue, 26 Jan 2010 15:51:12 -0800
Message-ID: <aday6jko26n.fsf@roland-alpha.cisco.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>
	<1264446094-4460-3-git-send-email-rolandd@cisco.com>
	<4B5EFEAD.9040702@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B5EFEAD.9040702-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Tue, 26
	Jan 2010 16:39:41 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > > -	IB_USER_VERBS_CMD_POST_SRQ_RECV
 > > +	IB_USER_VERBS_CMD_POST_SRQ_RECV,
 > > +	IB_USER_VERBS_CMD_CREATE_XRC_SRQ,
 > > +	IB_USER_VERBS_CMD_OPEN_XRCD,
 > > +	IB_USER_VERBS_CMD_CLOSE_XRCD
 > 
 > Jack,Roland I believe that adding entries to this enum means ABI change towards libibverbs or eventually cause ABI change between libibverbs and its consumers, (e.g change in size/content of the verbs context structure, etc), correct? 

This is a backwards-compatible ABI extension -- we are adding new
commands.  And I believe OFED has been shipping this ABI for quite a
while now (since 1.4?).

 > I'd like to use this ABI change and introduce/expose also the ib_modify_cq verb to user space. Basically, the related patches should be quite simple (uverbs, libibverbs, libmlx4), still, I'll be glad if you tell/coach me against what code base to do that. 

OK, but we should coordinate this with all the other ABI extensions that
OFED has already made.

 > One more thing I'd like to add to libibverbs and some device driver libraries is send-with-invalidate, but this is only user space patch set without any kernel/user, lib/app ABI change, correct?

It is a library ABI change of course to add the send with invalidate
opcode.  But that is OK.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
