From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB/qib: Adjust two size determinations in qib_init_pportdata()
Date: Thu, 6 Apr 2017 22:48:25 +0300
Message-ID: <20170406194823.GA28301@yuval-lap>
References: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
 <b5bc4160-aace-b919-7fe2-a4742d03c4ba@users.sourceforge.net>
 <20170405143242.GB5006@yuval-lap>
 <523b0864-e655-ed1f-8fe5-5995e0b0bde1@users.sourceforge.net>
 <20170405151525.GA5519@yuval-lap>
 <c3885f83-8239-e21d-74fc-bf4fe03dd5dc@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c3885f83-8239-e21d-74fc-bf4fe03dd5dc-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 05, 2017 at 05:21:22PM +0200, SF Markus Elfring wrote:
> > I found that the fix brings no harm to the existing code.
> 
> How do you think about to take another look at remaining update candidates
> at other source code places for this Linux module?

You mean the other patches in this patch-set?

> 
> Regards,
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
