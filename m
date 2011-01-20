From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 4/8] IB/srp: rework mapping engine to use multiple FMR
 entries
Date: Thu, 20 Jan 2011 07:36:03 -0500
Message-ID: <1295526963.22825.45.camel@obelisk.thedillows.org>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	 <1295411242-26148-5-git-send-email-dillowda@ornl.gov>
	 <AANLkTim6H063ta0w2A+zo9QH0jY5qL5uu1OxN4iqMFEm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim6H063ta0w2A+zo9QH0jY5qL5uu1OxN4iqMFEm-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-01-20 at 12:04 +0200, Or Gerlitz wrote:
> > We up the minimum page size for the FMR pool, as it is rare that the
> > kernel would send down a requests with scattered 512 byte fragments, and
> > no HCA supports such a small FMR mapping in any case.
> 
> 
> I believe you are wrong here as connectx support fmr-ing 512 byte
> segments ("block lists") since firmware 2.6 or so

Yep, that's what I get for working from memory of mthca -- though I
thought I had looked at mlx4 some time back. Thanks for the heads up.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
