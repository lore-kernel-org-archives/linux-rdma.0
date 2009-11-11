From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: strong ordering for data registered memory
Date: Wed, 11 Nov 2009 09:57:23 -0800
Message-ID: <adaskclvta4.fsf@roland-alpha.cisco.com>
References: <4AF9CACE.8070700@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF9CACE.8070700-UdXhSnd/wVw@public.gmane.org> (David Brean's message of "Tue, 10 Nov
	2009 15:19:26 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Some time ago there was an email sent to this group with the subject
 > "weak ordering for data registered memory".  I don't recall any action
 > resulting from this thread.  So, I have a question.  If a bit were
 > defined to specify "strong ordering", perhaps as a "access" flag (see
 > ibv_access_flags) and used with ibv_reg_mr(), would that be sufficient
 > for (1) client applications that need a HW "guarantee" of writing the
 > last byte of an RDMA last and (2) platform implementations that need
 > to deliver that feature?

What would happen if an application asked for strong ordering and the
adapter and/or platform is not capable of that?

Weak ordering is a bit easier to handle -- the app is saying "if you can
make things go faster, don't worry about ordering here" and a platform
where it doesn't matter can just ignore it.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
