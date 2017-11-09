From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v1 rdma-core 1/2] bnxt_re/lib: fix the memory barrier
 call during poll-cq
Date: Thu, 9 Nov 2017 11:05:21 -0700
Message-ID: <20171109180521.GM7063@ziepe.ca>
References: <1510225840-20034-1-git-send-email-devesh.sharma@broadcom.com>
 <1510225840-20034-2-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510225840-20034-2-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 09, 2017 at 06:10:39AM -0500, Devesh Sharma wrote:
> Putting a read barrier before issuing a read on valid bit
> is incorrect. When checking for the validity of CQE in the
> CQ buffer the code must wait for the read-barrier to finish
> after issuing a read operation on CQE valid bit.
> 
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>  providers/bnxt_re/main.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

This is probably fine

> +	uint8_t valid = 0;
> +
> +	valid = ((le32toh(hdr->flg_st_typ_ph) &
> +		  BNXT_RE_BCQE_PH_MASK) == cq->phase);

Hrm,

Techincally this should be something like

le32toh(atomic_read(hdr->flg_st_typ_ph))

And the the kernel version of this should be using READ_ONCE()

In user space we should probably create a

 udma_from_device_read_once(x)

That incorporates the barrier and the 'access_once' semantics..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
