From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 12/15] IB/pvrdma: Add the main driver module for PVRDMA
Date: Thu, 1 Sep 2016 19:54:05 +0300
Message-ID: <20160901165404.GA3429@yuval-lap.mynet>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-13-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470266864-16888-13-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 03, 2016 at 04:27:41PM -0700, Adit Ranadive wrote:
+
> +	/* Activate pvrdma device */
> +	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_ACTIVATE);
> +
> +	/* Make sure the write is complete before reading status. */
> +	mb();
> +
> +	/* Check if device was successfully activated */
> +	ret = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
> +	if (ret != 0) {
> +		dev_err(&pdev->dev, "failed to activate device\n");
> +		ret = -EINVAL;
> +		goto err_disable_intr;
> +	}

What if it will take the device to activate longer than the time between
write to PVRDMA_DEVICE_CTL_ACTIVATE and read from PVRDMA_REG_ERR?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
