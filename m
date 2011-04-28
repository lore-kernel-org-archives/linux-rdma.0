From: Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: presentation on ib acm
Date: Thu, 28 Apr 2011 13:58:44 +0000
Message-ID: <A4E971F4031F1840BBA6E79B417E62E80278484E@MTRCASDAG01.mtl.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC8B4BA4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC8B4BA4-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Very nice ppt. Thanks.

I have a question; On slide #8 you write: "Small latency hit if librdmacm compiled with ACM support, but service is not running". 
Is this latency hit on the fast path or control path? 
What do you refer as "small"? I guess this is for the cache miss cases. I expect the average to be better - this is the whole idea behind this idea, isn't it?

Cheers,
Alex Rosenbaum


-----Original Message-----
From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org [mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Hefty, Sean
Sent: Thursday, March 31, 2011 4:58 PM
To: linux-rdma; OpenFabrics EWG
Subject: [ewg] presentation on ib acm

I had created a presentation on the IB ACM to present at the OFA conference, but I think I was deemed too boring to actually present.  In any case, I completed the attached presentation for those interested in reading more about it.

Simply put, IB ACM is a daemon that takes IP addresses and returns path records.  Its main focus is on meeting the scalability requirements of MPI applications on large clusters.  Work on IB ACM is ongoing.

Enjoy!

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
