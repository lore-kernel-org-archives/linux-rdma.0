From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 05/12] IB/core: Add default GID for RoCE GID
 table
Date: Thu, 11 Jun 2015 00:20:17 -0600
Message-ID: <20150611062017.GC22369@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1433772735-22416-6-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433772735-22416-6-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 05:12:08PM +0300, Matan Barak wrote:

> +unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port);
> +

What is all this gid_type_mask stuff about? rocev2?

> +unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port)
> +{
> +	return !!rdma_protocol_roce(ib_dev, port);
> +}

Just return bool and drop the !!

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
