From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rdma_cm.h: Fix SCTP protocol ID
Date: Wed, 13 Jan 2010 13:21:07 -0800
Message-ID: <adak4vln1ks.fsf@roland-alpha.cisco.com>
References: <20100113192454.GA17655@comcast.net>
	<adaska9n2d3.fsf@roland-alpha.cisco.com>
	<7E10F17E68C24836BE68F8F22B64862B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7E10F17E68C24836BE68F8F22B64862B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Wed, 13 Jan 2010 13:11:52 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > Technically, I believe it's available to userspace, though the librdmacm doesn't
 > define it.  I'd be surprised if anything uses it.

Wouldn't trying to use RDMA_PS_SCTP hit the

	default:
		return -EPROTONOSUPPORT;

case in cma_get_port()?  So one couldn't actually do anything with
RDMA_PS_SCTP?  Or is there some way to avoid binding?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
