From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: SRP initiator driver maintainership
Date: Tue, 21 Jan 2014 12:03:25 +0200
Message-ID: <52DE45ED.8060703@dev.mellanox.co.il>
References: <1388783770.20053.10.camel@haswell.thedillows.org> <52DD5ED4.3050000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52DD5ED4.3050000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/20/2014 7:37 PM, Bart Van Assche wrote:
> On 01/03/14 22:16, David Dillow wrote:
>> Today was my last day at ORNL, and my future endeavors will leave even
>> less time to maintain the SRP initiator.
>>
>> My thanks especially go to Bart, for keeping the pressure to improve
>> alive, and for driving so many of those improvements.
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 6c20792..a36f1b5 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -7466,7 +7466,6 @@ S:	Maintained
>>   F:	drivers/scsi/sr*
>>   
>>   SCSI RDMA PROTOCOL (SRP) INITIATOR
>> -M:	David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
>>   L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>   S:	Supported
>>   W:	http://www.openfabrics.org
> (replying to an e-mail of two weeks ago)
>
> Hello Dave,
>
> Thanks for all the time you have spent reviewing and testing SRP
> initiator patches. Such maintainer work is unglamorous but important -
> it is due to the combined effort of all kernel maintainers that the
> Linux kernel earned its high quality reputation.
>
> Roland, what is your preference with regard to maintainership of the SRP
> initiator driver ? My plan is to continue contributing patches to the
> SRP initiator driver at about the same pace as I had done in the past.
> Do you prefer to take over maintainership of this driver yourself or is
> it okay for you that I become the official maintainer for this driver ?
>
> Thanks,
>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Bart,

Your contribution to SRP was and still is important!
You led the efforts improving and stabilizing SRP driver and
adding the fast-failover logic which was needed for so long.

Roland,
I collaborated with Bart on SRP enhancement in the past year or so
and I think Bart is a perfect match for SRP maintainership.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
