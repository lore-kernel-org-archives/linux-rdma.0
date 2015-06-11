From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 12/12] RDMA/ocrdma: Changes in driver to
 incorporate the moving of GID Table mgmt to IB/Core.
Date: Wed, 10 Jun 2015 22:11:24 -0600
Message-ID: <20150611041124.GC16599@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1433772735-22416-13-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433772735-22416-13-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 05:12:15PM +0300, Matan Barak wrote:
> From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> 
> 1.Check and set port capability flags to indicate RoCEV2 support.

??? This series has nothing to with rocev2 now, what is this about?

>  	mutex_init(&dev->dev_lock);
> -	dev->sgid_tbl = kzalloc(sizeof(union ib_gid) *
> -				OCRDMA_MAX_SGID, GFP_KERNEL);

Should sgid_tbl be dropped from the structure?

> +int ocrdma_modify_gid(struct ib_device *ibdev, u8 port_num, unsigned int index,
> +		      const union ib_gid *gid, const struct ib_gid_attr *attr,
> +		      void **context)
> +{
> +	struct ocrdma_dev *dev;
> +
> +	dev = get_ocrdma_dev(ibdev);
>  
>  	return 0;
>  }

Empty modify gid? Shouldn't it be completely empty?

This is correct? This HW sends the full SGID in the WQE?

> +enum {
> +     OCRDMA_L3_TYPE_IB_GRH   = 0x00,
> +     OCRDMA_L3_TYPE_IPV4     = 0x01,
> +     OCRDMA_L3_TYPE_IPV6     = 0x02
> +};

These added constants are not used? Probably others as well?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
