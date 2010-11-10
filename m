From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: multicast sends not received by sending QP
Date: Wed, 10 Nov 2010 21:59:21 +0200
Message-ID: <AANLkTik2AvmBLogDDzbUCCgMz=5qvRRUo1DryDyEkqjT@mail.gmail.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B84C5788@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B84C5788-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The cluster is running OFED [...] I do not see this problem on 2.6.36

I think you hit this ofed only patch
http://git.openfabrics.org/git?p=ofed_1_5/linux-2.6.git;a=blob;f=kernel_patches/fixes/mlx4_0290_mcast_loopback.patch;h=786a3926529befac2c2d1fa6d8c36bada79d61a7;hb=HEAD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
