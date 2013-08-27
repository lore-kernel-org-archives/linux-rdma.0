From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: add change_queue_depth and change_queue_type
 support
Date: Tue, 27 Aug 2013 18:46:09 +0200
Message-ID: <521CD7D1.9000807@acm.org>
References: <521B5DD5.3020804@profitbricks.com> <521C63FA.3070709@acm.org> <521CD628.8090902@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521CD628.8090902-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/27/13 18:39, Jack Wang wrote:
> I look into scsi core about above statement:
> In drivers/scsi/scsi_scan.c:865:		
>
>   if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
>              !(*bflags & BLIST_NOTQ))
>                  sdev->tagged_supported = 1;
> It check inquiry result byte 7 with cmdque bit.

Ah, thanks for looking that up. I had overlooked that statement. So it 
should be fine to keep all the code that depends on the value of 
sdev->tagged_supported.

Regards,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
