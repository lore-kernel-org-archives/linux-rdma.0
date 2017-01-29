From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 04/11] libbnxtre: Add support for posting and
 polling
Date: Sun, 29 Jan 2017 16:43:38 -0700
Message-ID: <20170129234338.GG24051@obsidianresearch.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-5-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-5-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 28, 2017 at 05:13:35PM -0500, Devesh Sharma wrote:

> +#define true           1
> +#define false          0

Nope, delete.

> +
> +static void bnxt_re_ring_db(struct bnxt_re_dpi *dpi,
> +			    struct bnxt_re_db_hdr *hdr)
> +{
> +	uint64_t *dbval = (uint64_t *)&hdr->indx;
> +
> +	/*TODO: cpu_to_le64 */
> +	pthread_spin_lock(&dpi->db_lock);
> +	iowrite64(dpi->dbpage, dbval);
> +	/* write barrier */
> +	wmb();
> +	pthread_spin_unlock(&dpi->db_lock);

That wmb sure looks like it is in the wrong place. Better check them all..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
