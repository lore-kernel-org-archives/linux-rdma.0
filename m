From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 05/10] IB/qib: Use rdmavt lid defines in qib
Date: Mon, 7 Dec 2015 13:54:39 -0700
Message-ID: <20151207205439.GA29576@obsidianresearch.com>
References: <20151207204735.11219.68688.stgit@phlsvslse11.ph.intel.com>
 <20151207204911.11219.50129.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151207204911.11219.50129.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 07, 2015 at 03:49:12PM -0500, Dennis Dalessandro wrote:
>  	/* A multicast address requires a GRH (see ch. 8.4.1). */
> -	if (ah_attr->dlid >= QIB_MULTICAST_LID_BASE &&
> -	    ah_attr->dlid != QIB_PERMISSIVE_LID &&
> +	if (ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) &&
> +	    ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE) &&

Uh cpu_to_be16 please..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
