From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: presentation on ib acm
Date: Thu, 28 Apr 2011 07:48:29 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3902@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC8B4BA4@orsmsx501.amr.corp.intel.com>
 <A4E971F4031F1840BBA6E79B417E62E80278484E@MTRCASDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A4E971F4031F1840BBA6E79B417E62E80278484E-FXD4EHQYOQ+layAChLZOBkEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I have a question; On slide #8 you write: "Small latency hit if librdmacm
> compiled with ACM support, but service is not running".
> Is this latency hit on the fast path or control path?

This is during connection setup only.  The additional latency is basically a single if statement, so I doubt whether it would really be measurable.

> What do you refer as "small"? I guess this is for the cache miss cases. I
> expect the average to be better - this is the whole idea behind this idea,
> isn't it?

That comment is only referring to the case where librdmacm is compiled to use ACM, but the ACM service is not running.

But, I think you're correct in your thinking.  On a cache miss, ACM can be slower than querying the SA directly.

We are trying to schedule further testing on the Hyperion cluster in order to gather additional performance and overhead data.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
