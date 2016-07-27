From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/15] IB/pvrdma: Add device command support
Date: Wed, 27 Jul 2016 14:57:06 -0700
Message-ID: <16e2ecc7-44f1-18c1-e189-d3ee7fac6b4f@vmware.com>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-3-git-send-email-aditr@vmware.com>
 <20160718131354.GF6165@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718131354.GF6165-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/18/16 6:13 AM, Yuval Shaia wrote:
>> +
>> +static int pvrdma_cmd_recv(struct pvrdma_dev *dev, union pvrdma_cmd_resp *resp)
>> +{
>> +	dev_dbg(&dev->pdev->dev, "receive response from device\n");
>> +
>> +	spin_lock(&dev->cmd_lock);
>> +	memcpy(resp, dev->resp_slot, sizeof(*resp));
>> +	spin_unlock(&dev->cmd_lock);
> 
> In case your virtual HW supports more than one concurrent commands, if
> cmd_lock protects cmd_slot i would expect to have extra resp_lock to
> protect resp_slot.

Thanks for the suggestion! Currently, our virtual hardware only supports
processing one command at a time. I'll skip adding the resp->lock since it
may not add much value here.

> btw, otherwise why not just lock the entire flow:
> 	memcpy(dev->cmd_slot, req, sizeof(*req));
> 	pvrdma_write_reg(dev, PVRDMA_REG_REQUEST, 0);
> 	pvrdma_read_reg(dev, PVRDMA_REG_ERR);
> 	memcpy(resp, dev->resp_slot, sizeof(*resp));
> 
> This might improve performances.
> 

Since this is in the slow control path and we execute 1 command at a time,
not sure if that would be beneficial.

>> +
>> +	return 0;
>> +}
>> +
>> +int
>> +pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
>> +		bool expect_resp, union pvrdma_cmd_resp *resp)
>> +{
>> +	int err;
>> +
>> +	dev_dbg(&dev->pdev->dev, "post request to device\n");
>> +
>> +	/* Serializiation */
>> +	down(&dev->cmd_sema);
>> +
>> +	spin_lock(&dev->cmd_lock);
>> +	memcpy(dev->cmd_slot, req, sizeof(*req));
>> +	spin_unlock(&dev->cmd_lock);
>> +
>> +	init_completion(&dev->cmd_done);
>> +	pvrdma_write_reg(dev, PVRDMA_REG_REQUEST, 0);
>> +
>> +	/* Make sure the request is written before reading status. */
>> +	mb();
>> +	err = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
>> +	if (err == 0) {
>> +		if (expect_resp) {
>> +			err = wait_for_completion_interruptible_timeout(
>> +				&dev->cmd_done,
>> +				msecs_to_jiffies(PVRDMA_CMD_TIMEOUT));
>> +			if (err == 0) {
>> +				dev_warn(&dev->pdev->dev,
>> +					 "completion timeout\n");
>> +				err = -ETIMEDOUT;
>> +			} else {
>> +				err = pvrdma_cmd_recv(dev, resp);
> 
> Maybe it is a silly question but in case of two commands that issued almost
> simultaneously, it possible that fast execution of second command will
> reach this point first and the reasponse here is of the first one?
> 

I don't think that may happen since we do have a semaphore here to protect that.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
