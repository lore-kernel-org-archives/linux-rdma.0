From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/13] IB-mgmt: Port madeye to userspace
Date: Mon, 08 Nov 2010 18:17:23 +0200
Message-ID: <4CD82293.2020005@Voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B38B@orsmsx501.amr.corp.intel.com>	<4CD26E04.3060408@voltaire.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B65F@orsmsx501.amr.corp.intel.com>	<4CD2DFD3.7040900@Voltaire.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B837B857@orsmsx501.amr.corp.intel.com>	<4CD7CD7B.2020003@voltaire.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D6B54@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83D6B54-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> That requires registration with the SA.  The intent is to avoid using a centralized service when possible. 

yep, makes sense, look like this design finally went the decentralized way... cool

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
