From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 04/15] IB/pvrdma: Add functions for Verbs support
Date: Tue, 23 Aug 2016 18:13:42 +0300
Message-ID: <20160823151341.GA10264@yuval-lap>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-5-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470266864-16888-5-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 03, 2016 at 04:27:33PM -0700, Adit Ranadive wrote:
> + */
> +int pvrdma_query_port(struct ib_device *ibdev, u8 port,
> +		      struct ib_port_attr *props)
> +{
> +	struct pvrdma_dev *dev = to_vdev(ibdev);
> +	union pvrdma_cmd_req req;
> +	union pvrdma_cmd_resp rsp;
> +	struct pvrdma_cmd_query_port *cmd = &req.query_port;
> +	struct pvrdma_cmd_query_port_resp *resp = &rsp.query_port_resp;
> +	int err;
> +
> +	memset(cmd, 0, sizeof(*cmd));
> +	cmd->hdr.cmd = PVRDMA_CMD_QUERY_PORT;
> +	cmd->port_num = port;
> +
> +	err = pvrdma_cmd_post(dev, &req, &rsp);

Patch order again, this guy is added in patch 7/15 ("IB/pvrdma: Add device
command support").
Maybe it is only me having trouble to read it so do not want to be a nagger
here but don't we have some (hidden) agreement that each patch is atomic
and i should be able to compile the kernel after each one?

> +	if (err < 0 || rsp.hdr.ack != PVRDMA_CMD_QUERY_PORT_RESP) {
> +		dev_warn(&dev->pdev->dev, "could not query port\n");
> +		return -EFAULT;
> +	}
> +
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
