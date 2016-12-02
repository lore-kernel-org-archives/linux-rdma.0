From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/16] IB/pvrdma: Add Queue Pair support
Date: Fri, 2 Dec 2016 15:43:40 +0200
Message-ID: <20161202134339.GA12627@yuval-lap>
References: <cover.1475458407.git.aditr@vmware.com>
 <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr@vmware.com>
 <20161202103542.GA3663@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161202103542.GA3663@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > +	dev_dbg(&dev->pdev->dev, "create queuepair with %d, %d, %d, %d\n",
> > +		cmd->max_send_wr, cmd->max_recv_wr, cmd->max_send_sge,
> > +		cmd->max_recv_sge);
> > +
> > +	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_QP_RESP);
> 
> Warning: rsp is not in use so either use NULL or actually check response.
> 

Please ignore

> > +	if (ret < 0) {
> > +		dev_warn(&dev->pdev->dev,
> > +			 "could not create queuepair, error: %d\n", ret);
> > +		goto err_pdir;
> > +	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
