From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libcxgb4: fixes for debug build
Date: Thu, 15 Dec 2016 15:03:31 -0700
Message-ID: <20161215220331.GB28939@obsidianresearch.com>
References: <20161215212201.AAA3BE08C3@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161215212201.AAA3BE08C3-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>  	PDBG("%s found vendor %d device %d type %d\n",
> -	     __FUNCTION__, vendor, device, hca_table[i].chip_version);
> +	     __FUNCTION__, vendor, device, CHELSIO_CHIP_VERSION(hca_table[i].device >> 8));

Don't #define debug macros to {} to avoid this kind of bug

see b60ae256e7d1541edc8fd6a072a17c143ce70b4a

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
