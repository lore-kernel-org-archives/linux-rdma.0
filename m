From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Avoid that LUN scanning creates duplicate devices
Date: Sat, 25 Jun 2011 04:58:43 -0400
Message-ID: <20110625085843.GA3172@infradead.org>
References: <201106251010.30994.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201106251010.30994.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 25, 2011 at 10:10:30AM +0200, Bart Van Assche wrote:
> SCSI scanning of a channel:id:lun triplet in Linux works as follows (function
> scsi_scan_target() in drivers/scsi/scsi_scan.c):
> - If lun == SCAN_WILD_CARD, send a REPORT LUNS command to the target and
>   process the result.
> - If lun != SCAN_WILD_CARD, send an INQUIRY command to the LUN corresponding
>   to the specified channel:id:lun triplet to verify whether the LUN exists.
> So a SCSI driver must either take the channel and target id values in account
> in its quecommand() function or it should declare that it only supports one
> channel and one target id. Currently the ib_srp driver does neither. As a
> result scanning the SCSI bus via e.g. rescan-scsi-bus.sh causes many
> duplicate SCSI devices to be created. For each 0:0:L device, several
> duplicates are created with the same LUN number and with (C:I) != (0:0). Fix
> this by declaring that the ib_srp driver only supports one channel and one
> target id.

Looks good.  We should probably consider chosing sane defaults at least
for max_channel, but for now this is the best fix.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
