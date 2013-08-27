From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] IB/srp: add change_queue_depth and change_queue_type
 support
Date: Tue, 27 Aug 2013 11:06:05 +0200
Message-ID: <521C6BFD.5010600@profitbricks.com>
References: <521B5DD5.3020804@profitbricks.com> <521C63FA.3070709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521C63FA.3070709-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/27/2013 10:31 AM, Bart Van Assche wrote:
> On 08/26/13 15:53, Jack Wang wrote:
>> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> Date: Mon, 26 Aug 2013 15:50:03 +0200
>> Subject: [PATCH] IB/srp: add change_queue_depth/change_queue_type support
>>
>> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> 
> Hello Jack,
> 
> When posting a Linux kernel patch it is not only expected that the
> commit message explains what is changed but also why these changes have
> been made. What made you look into adding dynamic queue depth support ?
> Had you perhaps run into a performance issue, an issue that is solved by
> this patch ? If so, did it occur with all storage types or only with
> certain storage types (e.g. hard disks or hard disk arrays) ? How much
> did this patch improve performance ?
Hello Bart,

Thanks for informative comments.
The intention to add change_queue_type/change_queue_type support is we
saw some times srp run into scsi error handle when storage server(scst)
is busy, we want reduce the queue_depth at this point to avoid such
situation, as I understand about scsi core, it will try to auto change
queue depth according to scsi command results, when success ramp up
queue depth, and when storage return busy or queue full, it reduce the
queue depth.

The README of SCST suggests:
Unfortunately, currently SCST lacks dynamic I/O flow control, when the
queue depth on the target is dynamically decreased/increased based on
how slow/fast the backstorage speed comparing to the target link. So,
there are 6 possible actions, which you can do to workaround or fix this
issue in this case:

1. Ignore incoming task management (TM) commands. It's fine if there are
not too many of them, so average performance isn't hurt and the
corresponding device isn't getting put offline, i.e. if the backstorage
isn't too slow.

2. Decrease /sys/block/sdX/device/queue_depth on the initiator in case
if it's Linux (see below how) or/and SCST_MAX_TGT_DEV_COMMANDS constant
in scst_priv.h file until you stop seeing incoming TM commands.
ISCSI-SCST driver also has its own iSCSI specific parameter for that,
see its README file.

To decrease device queue depth on Linux initiators you can run command:

# echo Y >/sys/block/sdX/device/queue_depth

where Y is the new number of simultaneously queued commands, X - your
imported device letter, like 'a' for sda device. There are no special
limitations for Y value, it can be any value from 1 to possible maximum
(usually, 32), so start from dividing the current value on 2, i.e. set
16, if /sys/block/sdX/device/queue_depth contains 32.

3. Increase the corresponding timeout on the initiator. For Linux it is
located in
/sys/devices/platform/host*/session*/target*:0:0/*:0:0:1/timeout. It can
be done automatically by an udev rule. For instance, the following
rule will increase it to 300 seconds:

SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*", ACTION=="add",
ATTR{type}=="0|7|14", ATTR{timeout}="300"

By default, this timeout is 30 or 60 seconds, depending on your
distribution.

4. Try to avoid such seek intensive workloads.

5. Increase speed of the target's backstorage.

6. Implement in SCST dynamic I/O flow control. This will be an ultimate
solution. See "Dynamic I/O flow control" section on
http://scst.sourceforge.net/contributing.html page for possible
implementation idea.

I'm approaching the second one.


> 
>> @@ -1697,6 +1698,56 @@ static int srp_cm_handler(struct ib_cm_id *cm_id,
>> struct ib_cm_event *event)
>>
>>       return 0;
>>   }
>> +/**
>> + * srp_change_queue_type - changing device queue tag type
> 
> Please leave a blank line between the end of one function and the header
> of the next function.
> 
thanks, will do
>> +
>> +/**
>> + * srp_change_queue_depth - setting device queue depth
>> + * @sdev: scsi device struct
>> + * @qdepth: requested queue depth
>> + * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
>> + * (see include/scsi/scsi_host.h for definition)
>> + *
>> + * Returns queue depth.
>> + */
>> +static int
>> +srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
>> +{
>> +    if (reason == SCSI_QDEPTH_DEFAULT || reason ==
>> SCSI_QDEPTH_RAMP_UP) {
>> +        struct Scsi_Host *shost = sdev->host;
>> +        int max_depth;
> 
> Nothing important, but I think in the Linux kernel there is a preference
> to declare variables at the outermost scope.
> 
sure, will do.
>> +        if (!sdev->tagged_supported)
>> +            max_depth = 1;
> 
> This code seems incorrect to me for the SRP protocol. In the SRP
> protocol, although there is no TCQ support, queue depths above one are
> supported.
> 
> I also have a more general remark. There is no TCQ support in the SRP
> protocol, which means that sdev->tagged_supported is always 0 (false).
> So my recommendation is to leave out all code that depends on "if
> (sdev->tagged_supported)" and to remove the "if
> (!sdev->tagged_supported)" tests.
> 
Good to know, thanks for share will fix this.

KR
Jack


> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
