From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Tue, 18 Jan 2011 21:31:13 -0800
Message-ID: <aday66hxxwe.fsf@cisco.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org> (David
	Dillow's message of "Tue, 18 Jan 2011 23:27:14 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Dave,

 > Now that at least one vendor is implementing full support for the SRP
 > indirect memory descriptor tables, we can safely expand the sg_tablesize,
 > and realize some performance gains, in many cases quite large. I don't
 > have vendor code that implements the full support needed for safety, but
 > the rareness of FMR mapping failures allows the mapping code to function,
 > at a risk, with existing targets.

Have you considered using memory registration through a send queue (from
the base memory management extensions)?  mlx4 at least has support for
this operation, which would let you pre-allocate everything and avoid
the possibility of failure (I think).

When do we get FMR mapping failures now?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
