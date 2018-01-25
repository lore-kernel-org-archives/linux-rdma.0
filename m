From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v5 0/3] IB/srp patches for kernel v4.16
Date: Thu, 25 Jan 2018 11:06:59 -0800
Message-ID: <a136f97d-cc29-3fb1-6692-770eb11eba13@wdc.com>
References: <20180122222713.13197-1-bart.vanassche@wdc.com>
 <1516727351.27592.46.camel@redhat.com> <1516743303.3339.36.camel@wdc.com>
 <1516895274.27592.125.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516895274.27592.125.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/25/18 07:47, Doug Ledford wrote:
> Sure, I know most of the stuff above, as I used to maintain the aic7xxx
> driver back when SCSI was actually popular.  But the target layer in the
> scsi core didn't exist back in the day.  Our structure was block layer->
> scsi disk/scsi cd-rom drivers->scsi core->scsi low level driver.  The
> setup back then was that block layer had its own request queue depth,
> then it would pass block layer requests to the scsi disk driver that
> turned them into scsi command blocks and would issue up to host->
> cmd_per_lun scbs at a time (assuming the device allowed tagged
> commands, without that you only got one at a time).  Being out of the
> loop, but knowing how things used to work, I figured the SRP driver
> already controlled how many commands would be presented to the target at
> the other side by hooking into the scsi core as a low level device
> driver and setting cmd_per_lun.  I think what's happened in the
> intervening years is that they seem to have taken the scsi disk driver
> and scsi cd-rom drivers and replaced them with a generic target driver
> that handles all block targets and then uses the old scsi disk and scsi
> cd-rom drivers as personalities for the given target, yes?

Hello Doug,

Sorry but I don't know the entire history of the Linux kernel SCSI 
stack. All I know is how it works today:
- A filesystem or other subsystem submits a request to the block layer
   core.
- The block layer core passes the request to the SCSI core.
- The SCSI core invokes the upper layer driver (e.g. sd or sr) to
   translate the block request into a SCSI command.
- The SCSI command is submitted by the SCSI core to the SCSI low-level
   driver (LLD).
- When the command is completed, the SCSI LLD reports this to the SCSI
   core. The SCSI core asks the upper layer driver to post-process the
   result and next reports the completion to the block layer.

To keep the above description brief I have left out the SCSI error 
handling strategy.

> And they now
> allow per-target command depth setting where as in the old days the
> queue depth for all tagged allowed targets was the device driver's
> cmd_per_lun, yes? (Back when I worked on this, multi-lun devices were
> not well supported, and cmd_per_lun, which should have really been
> cmd_per_device, was truly applied per lun and could easily cause a
> tagged device to have many more outstanding commands than intended if it
> was a multi-lun tagged capable device, at least on the old aic7xxx
> driver it could)  So that the queue depth on devices now a days is
> essentially min(target->can_queue, shost->cmd_per_lun), yes?

My understanding is that the queue depth per LUN is the minimum of the 
following three parameters:
* shost->can_queue
* target->can_queue
* shost->cmd_per_lun

Best regards,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
