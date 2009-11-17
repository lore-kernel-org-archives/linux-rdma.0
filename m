From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/9] ib/addr: simplify resolving IPv4 addresses
Date: Tue, 17 Nov 2009 12:51:31 -0800
Message-ID: <1258491091.11975.1.camel@wilder.ibm.com>
References: <AD17449F0C4E4FE7B20C32412F077C00@amr.corp.intel.com>
	 <4B024258.7070500@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B024258.7070500-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I hope to give them a go shortly.

On Tue, 2009-11-17 at 08:27 +0200, Or Gerlitz wrote:
> Sean Hefty wrote:
> > Merge resolve local/remote address resolution into a single
> > data flow to ensure consistent access and use of the local routing tables.
> 
> Sean, I reviewed patches 1-6 & 8 and they all look fine, I will give the whole series a try later this week to further validate them.
> 
> > Based on work from:
> > David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> David, Jason, are you planning to test these patches as well? specifically I assume the IPv6 work should be of interest to you...
> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
