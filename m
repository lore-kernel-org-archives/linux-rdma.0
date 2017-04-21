From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RESEND rdma-core v4 4/8] libbnxt_re: Add support for posting
 and polling
Date: Fri, 21 Apr 2017 13:22:55 -0600
Message-ID: <20170421192255.GA12079@obsidianresearch.com>
References: <1492801032-17587-1-git-send-email-devesh.sharma@broadcom.com>
 <1492801032-17587-5-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492801032-17587-5-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 21, 2017 at 02:57:08PM -0400, Devesh Sharma wrote:

> +static void bnxt_re_ring_db(struct bnxt_re_dpi *dpi,
> +			    struct bnxt_re_db_hdr *hdr)
> +{
> +	__le64 *dbval;
> +
> +	pthread_spin_lock(&dpi->db_lock);
> +	dbval = (__le64 *)&hdr->indx;
> +	udma_to_device_barrier();
> +	iowrite64(dpi->dbpage, dbval);
> +	pthread_spin_unlock(&dpi->db_lock);
> +}

What are you expecting this db_lock to do?

Is 'dbpage' UC or WC memory?

If this is UC memory then writing 64 bit values concurrently from
multiple threads is OK and this lock does nothing.

If this is WC memory then you need to use mmio_wc_spinlock /
mmio_wc_spinunlock instead, or the lock doesn't work right.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
