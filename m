From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: num reserved eqs presented as log and actual
Date: Fri, 19 Feb 2010 11:10:41 -0800
Message-ID: <adaeikh82j2.fsf@roland-alpha.cisco.com>
References: <4B790CAD.2070007@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B790CAD.2070007-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> (Yevgeny Petrilin's message of
	"Mon, 15 Feb 2010 10:58:21 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Multifunctional firmware should present number of reserved EQs as
 > an actual number (number of reserved eqs is not necessarily a power
 > of 2).
 > Older drivers treat this field as log, so when there are relatively big
 > number of reserved eqs, they would fail.
 > The firmware would present the number of EQs as log in a single function mode
 > (which would also work for older driver versions) and as actual number (in other field)
 > in multifunctional mode. The new code would check both fields.
 > Fixes commit be504b0b9fbe9ba447c93ef0f5789f377102d555

I can't really follow this changelog.  The (very old) ConnextX PRM I
have states that the field returned by the firmware is the actual
number, so the old driver behavior was wrong.  Or was the PRM wrong?

Are you changing the firmware behavior to make that field into a log?

Is this really the best way to clean this up, having the same
information twice in two different formats?
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
