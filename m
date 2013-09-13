From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Make queue size configurable
Date: Fri, 13 Sep 2013 16:15:29 +0200
Message-ID: <52331E01.3060005@gmail.com>
References: <521363EA.8080906@acm.org> <52136609.3090406@acm.org>  <1378782080.3794.6.camel@feather.ornl.gov> <522F5A81.8040101@acm.org> <1378937796.6649.5.camel@haswell.thedillows.org> <5231E8CE.5060105@gmail.com> <5231EC1A.7030902@acm.org> <5232C76B.4010704@gmail.com> <5232CF86.20507@acm.org> <5232D9BC.7090808@acm.org> <5233043F.5020804@gmail.com> <52331444.8070007@acm.org> <52331854.9010607@gmail.com> <52331B47.9070202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52331B47.9070202-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, David Dillow <dad-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/13/2013 04:03 PM, Bart Van Assche wrote:
> On 09/13/13 15:51, Jack Wang wrote:
>> On 09/13/2013 03:33 PM, Bart Van Assche wrote:
>>> On 09/13/13 14:25, Jack Wang wrote:
>>>> I tried your srp-ha branch in github,
>>>> echo string
>>>>> SRP2="id_ext=${THCA2_GUID},ioc_guid=${THCA2_GUID},dgid=${TGID_P2},pkey=${PKEY},service_id=${THCA2_GUID},can_queue=512"
>>>>>
>>>>>
>>>> to add_target failed with
>>>>
>>>>>    ib_srp: unknown parameter or missing value 'can_queue=512
>>>>> [  122.405385] ' in target creation request
>>>> Do I miss something?
>>>
>>> Hello Jack,
>>>
>>> Have you already tried the same command with "echo -n" instead of "echo"
>>> ? If I remember correctly the SRP initiator doesn't like a newline at
>>> the end of the string written into the sysfs add_target attribute.
>>>
>>> Hope this helps,
>>>
>>> Bart.
>>>
>> Thanks Bart,
>>
>> You're right, that is the problem, with -n option I can set can_queue
>> successfully.
>>
>> But cat /sys/class/scsi_host/hostx/can_queue still show 63
>>
>> Looks like it cause by the logic below:
>>
>>
>>>     /*
>>> 1870                  * Reserve credits for task management so we don't
>>> 1871                  * bounce requests back to the SCSI mid-layer.
>>> 1872                  */
>>> 1873                 target->scsi_host->can_queue
>>> 1874                         = min(target->req_lim -
>>> SRP_TSK_MGMT_SQ_SIZE,
>>> 1875                               target->scsi_host->can_queue);
>>> 1876                 target->scsi_host->cmd_per_lun
>>> 1877                         = min_t(int, target->scsi_host->can_queue,
>>> 1878                                 target->scsi_host->cmd_per_lun);
>>
>> Could you give some hint on this, why we need to update can_queue and
>> cmd_per_lun here?
> 
> Hello Jack,
> 
> What is the value of target->req_lim on your setup ? The initiator
> limits the queue size to the target request limit because any attempt to
> queue more commands would cause the target to reply with "BUSY" anyway.
> 
> Bart.
> 
> 
Hello Bart,

> cat /sys/class/scsi_host/host36/req_lim 
> 64

I just checked srp spec, which do define such behaviour, I wonder in
SCST/SRPT, how the request limit is chosen, is it report from low level
hardware driver?

Thanks
Jack



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
