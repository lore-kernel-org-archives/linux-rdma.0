From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 08/11] mlx4: Allow interfaces to correspond to each other
Date: Wed, 12 May 2010 13:30:22 -0700
Message-ID: <adafx1wuald.fsf@roland-alpha.cisco.com>
References: <20100218172430.GI12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172430.GI12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:24:30 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > +void *mlx4_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port)
 > +{
 > +	return mlx4_find_get_prot_dev(dev, proto, port);
 > +}
 > +EXPORT_SYMBOL(mlx4_get_prot_dev);

Not sure I understand why you have a wrapper to call another function
with exactly the same parameters?  Can't we get rid of this and just
rename mlx4_find_get_prot_dev() to mlx4_get_prot_dev()?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
