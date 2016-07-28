From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/15] IB/pvrdma: Add device command support
Date: Thu, 28 Jul 2016 22:51:39 +0000
Message-ID: <BLUPR0501MB8363954E94FE9D268E66CB7C5000@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-3-git-send-email-aditr@vmware.com>
 <20160718124652.GE6165@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718124652.GE6165-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 18 Jul 2016 15:46:53 +0300 Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jul 12, 2016 at 12:36:32PM -0700, Adit Ranadive wrote:
> > This patch enables posting Verb requests and receiving responses to/from
> > the backend PVRDMA emulation layer.
> >

...

> > +int
> > +pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
> > +		bool expect_resp, union pvrdma_cmd_resp *resp)
> > +{
> > +	int err;
> > +
> > +	dev_dbg(&dev->pdev->dev, "post request to device\n");
> > +
> > +	/* Serializiation */
> > +	down(&dev->cmd_sema);
> > +
> > +	spin_lock(&dev->cmd_lock);
> > +	memcpy(dev->cmd_slot, req, sizeof(*req));
> 
> Just to protect against memory corruption suggesting to do:
> 	memcpy(dev->cmd_slot, req, min(PAGE_SIZE, sizeof(*req)));
> 

Done.

> > +	spin_unlock(&dev->cmd_lock);
> > +
> > +	init_completion(&dev->cmd_done);
> > +	pvrdma_write_reg(dev, PVRDMA_REG_REQUEST, 0);
> > +
> > +	/* Make sure the request is written before reading status. */
> > +	mb();
> > +	err = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
> > +	if (err == 0) {
> > +		if (expect_resp) {
> 
> How about utilizing resp instead of extra argument.
> This will save you for example from the local variable rsp in function
> pvrdma_destroy_qp (patch #10)
> 

Ok. Will remove the extra argument.

> > +			err = wait_for_completion_interruptible_timeout(
> > +				&dev->cmd_done,
> > +				msecs_to_jiffies(PVRDMA_CMD_TIMEOUT));
> > +			if (err == 0) {
> > +				dev_warn(&dev->pdev->dev,
> > +					 "completion timeout\n");
> 
> Is this really a warning only? i.e. i assume some high level flow is
> break now.
> 

I have changed this to a dev_err.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
