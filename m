From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 1/4] RDMA/bnxt_re: Add memory barriers when processing
 CQ/EQ entries
Date: Mon, 6 Nov 2017 10:19:25 -0700
Message-ID: <20171106171925.GB18802@ziepe.ca>
References: <1509984452-18336-1-git-send-email-selvin.xavier@broadcom.com>
 <1509984452-18336-2-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1509984452-18336-2-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 06, 2017 at 08:07:29AM -0800, Selvin Xavier wrote:
> From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> 
> The code determines if the next ring entry is valid before proceeding
> further to read the rest of the entry. The CPU can re-order and read
> the rest of the entry first, possibly reading a stale entry, if DMA
> of a new entry happens right after reading it.

Please make sure the bnxt user space stuff in rdma-core does not have the
same problem...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
