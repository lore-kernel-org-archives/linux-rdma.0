From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: multicast sends not received by sending QP
Date: Wed, 10 Nov 2010 12:06:14 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B84C5862@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B84C5788@orsmsx501.amr.corp.intel.com>
 <AANLkTik2AvmBLogDDzbUCCgMz=5qvRRUo1DryDyEkqjT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik2AvmBLogDDzbUCCgMz=5qvRRUo1DryDyEkqjT-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The cluster is running OFED [...] I do not see this problem on 2.6.36
> 
> I think you hit this ofed only patch
> http://git.openfabrics.org/git?p=ofed_1_5/linux-
> 2.6.git;a=blob;f=kernel_patches/fixes/mlx4_0290_mcast_loopback.patch;h=786a
> 3926529befac2c2d1fa6d8c36bada79d61a7;hb=HEAD

Yes - this looks like the issue.  thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
