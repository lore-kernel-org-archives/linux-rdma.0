From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Tue, 22 Feb 2011 09:49:50 -0500
Message-ID: <1298386190.18945.1.camel@obelisk.thedillows.org>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	 <aday66hxxwe.fsf@cisco.com> <1298074037.15679.17.camel@lap75545.ornl.gov>
	 <4D635974.10807@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D635974.10807-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2011-02-22 at 08:36 +0200, Or Gerlitz wrote:
> David Dillow wrote:
> > It looks like I can only have up to 256 keys for each fast page 
> > registration MR, so that seems to limit the mappings in flight
> 
> My understanding is that for --specific-- MR, its associated rkey would 
> wrap every 256 mappings see ib_update_fast_reg_key and friends. And 
> anyway, for specific MR you can have only one mapping living at any 
> point of time (e.g set before sending the request, invalidated remotely 
> with the response or locally after getting the response)

Thanks for the note Or -- you confirmed my suspensions after testing
last night. Looks like multiple MRs per request, then.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
