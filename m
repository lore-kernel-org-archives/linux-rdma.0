From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Make queue size configurable
Date: Tue, 10 Sep 2013 19:44:33 +0200
Message-ID: <522F5A81.8040101@acm.org>
References: <521363EA.8080906@acm.org> <52136609.3090406@acm.org> <1378782080.3794.6.camel@feather.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378782080.3794.6.camel-VK19RVc5TWXUd6DVheFtbw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dad-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/10/13 05:01, David Dillow wrote:
> On Tue, 2013-08-20 at 14:50 +0200, Bart Van Assche wrote:
>> @@ -2227,6 +2270,7 @@ static const match_table_t srp_opt_tokens = {
>>          { SRP_OPT_SG_TABLESIZE,         "sg_tablesize=%u"       },
>>          { SRP_OPT_COMP_VECTOR,          "comp_vector=%u"        },
>>          { SRP_OPT_TL_RETRY_COUNT,       "tl_retry_count=%u"     },
>> +       { SRP_OPT_CAN_QUEUE,            "can_queue=%d"          },
>
> I'm pretty much OK with the patch, but since we're stuck with it going
> forward, I'd like to have a better externally visible name here --
> queue_depth? max_queue? queue_size?
>
> Otherwise,
> Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

Hello Dave,

If this name was not yet in use in any interface that is visible in user 
space, I would agree that we should come up with a better name. However, 
the SCSI mid-layer already uses that name today to export the queue 
size. To me this looks like a good reason to use the name "can_queue" ? 
An example:

$ cat /sys/class/scsi_host/host93/can_queue
62

See also the shost_rd_attr(can_queue, "%hd\n") statement in 
drivers/scsi/scsi_sysfs.c.

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
