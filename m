From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/13] IB-mgmt: Port madeye to userspace
Date: Thu, 04 Nov 2010 18:31:15 +0200
Message-ID: <4CD2DFD3.7040900@Voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B38B@orsmsx501.amr.corp.intel.com>	<4CD26E04.3060408@voltaire.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B65F@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B65F-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> sent MADs that complete in error.  For ibacm, the only CM MAD of interest is the REQ, 
> since it contains SLID/DLID information that can be used to update a path record cache.

still, I am not sure to be with you, the mads used by the CM aren't reliable, correct? 
so I don't see why/how a mad containing e.g junk DLID completes with error...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
