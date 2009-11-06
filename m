From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Fri, 06 Nov 2009 14:59:56 +0300
Message-ID: <4AF40FBC.9080004@vlnb.net>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com>	 <f3177b9e0911040802o7fce0f4fte02c52dfe940f582@mail.gmail.com>	 <3142CEFB1403044F9954E2DF6C85660FBB34BF@orca.penguincomputing.com>	 <f3177b9e0911041004t2e75d545v5cc10d5375550bde@mail.gmail.com>	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4DD@orca.penguincomputing.com>	 <4AF29201.6000606@penguincomputing.com> <4AF2D2B8.5080304@vlnb.net>	 <e2e108260911051034o43db58cdi65b84ce46219bb94@mail.gmail.com>	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9@orca.penguincomputing.com> <e2e108260911052306l230d8d7cxbae68bf08678d6fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260911052306l230d8d7cxbae68bf08678d6fe-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche, on 11/06/2009 10:06 AM wrote:
> On Fri, Nov 6, 2009 at 3:54 AM, Philip Pokorny
> <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>> ======= Update
>> At Chris's suggestion, I changed the scst threading to a *single* thread.  I
>> also changed the number of outstanding commands to 32 (from 64)  We have a
>> relatively large number of initiators (50, currently testing with only 4)
>> but each initiator has it's own dedicated, non-shared set of LVM "block"
>> devices.  So it does not seem necessary to set the device queue size to
>> initiators*device_queue_size.  I set the total device queued commands to 37.
>>
>> Re-running the test, the storage is "stable" and completed the first phase
>> of the test (create and check the filesystem) but now two of four clients
>> have "live-locked" waiting for an I/O to complete for the last 15 minutes or
>> so.
>>
>> On the initiators iostat looks like this:
>>
>> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz
>> avgqu-sz   await  svctm  %util
>> sdb               0.00     0.00  0.00  0.00     0.00     0.00     0.00
>> 160.02    0.00   0.00 100.01
>> sdb               0.00     0.00  0.00  0.00     0.00     0.00     0.00
>> 160.02    0.00   0.00 100.01
>> sdb               0.00     0.00  0.00  0.00     0.00     0.00     0.00
>> 160.02    0.00   0.00 100.01
>> sdb               0.00     0.00  0.00  0.14     0.00     8.14   114.00
>> 159.34 180114.00 7002.00 100.03
>> sdb               0.00     0.00  0.00  0.00     0.00     0.00     0.00
>> 160.02    0.00   0.00 100.01
>> sdb               0.00     0.00  0.00  0.00     0.00     0.00     0.00
>> 160.02    0.00   0.00 100.01
>>
>> This tells me that there is a pending I/O waiting to be completed but it
>> seems to have been lost on the server, because this is taking much too
>> long.  There are 7 seconds "between" each line of output above so that's
>> almost 30 seconds of output with *no* change in the I/O status.
>>
>> The "gzip | tar -x" I was running is "hung"
> 
> Hello Phil,
> 
> Can you please post the SCST target logs available for the above scenario ?

Yes, and please make sure you are running the debug build.

> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
