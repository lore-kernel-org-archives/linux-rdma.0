From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 04/11] ib_core: IBoE CMA device binding
Date: Wed, 12 May 2010 13:03:42 -0700
Message-ID: <ada1vdgvqe9.fsf@roland-alpha.cisco.com>
References: <20100218172403.GE12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172403.GE12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:24:03 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 >  int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 > -			 struct ib_sa_path_rec *rec, struct ib_ah_attr *ah_attr)
 > +			 struct ib_sa_path_rec *rec, struct ib_ah_attr *ah_attr,
 > +			 int force_grh)

Rather than this change in API, could we just have this function look at
the link layer, and if it's ethernet, then always set the GRH flag?
Seems simpler than requiring the upper layers to do this and then pass
the result in?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
