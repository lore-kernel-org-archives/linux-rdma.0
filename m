From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: mode connected infiniband
Date: Thu, 14 Jan 2010 09:22:31 -0800
Message-ID: <adabpgwmwiw.fsf@roland-alpha.cisco.com>
References: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Nico's message of "Thu, 14 Jan 2010 09:11:17 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nico <parpandet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > I'am using an infiniband kernel 2.6.32-trunk-686 from debian,

I guess the problem is that standard don't enable
CONFIG_INFINIBAND_IPOIB_CM.  It's probably worth filing a Debian bug for
that, and we should probably change the upstream kernel default to "yes"
as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
