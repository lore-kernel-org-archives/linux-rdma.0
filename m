From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
 	and eventually hangs
Date: Tue, 15 Sep 2009 20:57:56 +0400
Message-ID: <4AAFC794.7090205@vlnb.net>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>	<4AA4F561.504@vlnb.net>	<f3177b9e0909081529i4dd74faq9a6c5a4783b5ded4@mail.gmail.com>	<e2e108260909090938x6b72c519teed7dfd280eac804@mail.gmail.com>	<f3177b9e0909111250w159def51h9b720366e27fa3a7@mail.gmail.com>	<4AAE909F.6030202@vlnb.net>	<f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4@mail.gmail.com>	<e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>	<f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>	<4AAFC42D.4030708@vlnb.net> <f3177b9e0909150953x11d19210mf07cbdcc57928d42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0909150953x11d19210mf07cbdcc57928d42-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Chris Worley, on 09/15/2009 08:53 PM wrote:
> On Tue, Sep 15, 2009 at 10:43 AM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
>> Chris Worley, on 09/15/2009 07:50 PM wrote:
>>> On Tue, Sep 15, 2009 at 12:10 AM, Bart Van Assche
>>> <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> On Tue, Sep 15, 2009 at 1:03 AM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>> On Mon, Sep 14, 2009 at 12:51 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
>>>>> wrote:
>>>>>> Chris Worley, on 09/11/2009 11:50 PM wrote:
>>>>>>> I've definitely removed the switch/firmware from being the cause.
>>>>>>>
>>>>>>> I'm thinking the reason you can't repeat the test may be latency
>>>>>>> related.  We get ~50usecs average latency (on small block sizes),
>>>>>>> which can't be achieved using regular SSD's (and rotating drives are
>>>>>>> nowhere close).  Maybe a ramdisk would help repeat the issue.
>>>>>> I think you should try to reproduce the problem with ramdisk or nullio.
>>>>>> By
>>>>>> so you will eliminate possible influence of the SSD backend.
>>>>> W/ 12GB RAM in the target, I created a 7GB ramdisk:
>>>>>
>>>>> mount -t ramfs -o size=7g ramfs /mnt/
>>>>> dd if=/dev/zero of=/mnt/foo bs=1024k count=7000
>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>>>>>
>>>>> Then, on the initiator, I tested it... and it hung during sequential
>>>>> 8KB block reads:
>>>>>
>>>>> fio --rw=read --bs=8k --numjobs=64 --iodepth=64 --sync=0 --direct=1
>>>>> --randrepeat=0 \
>>>>>  --group_reporting --ioengine=libaio --filename=/dev/sde --name=test
>>>>> --loops=10000 --runtime=600
>>>>>
>>>>> Note that I was running the SM on the target this time too.
>>>> Which Linux distro was installed on the inititiator and on the target
>>>> ? And if applicable, which OFED version ? Which kernel messages were
>>>> logged by SRPT around the time the issue occurred (after having
>>>> enabled SRPT logging first) ?
>>> As logging hadn't helped this issue previously, I've not been enabling
>>> it.  That plus the kernel hacks needed to invoke logging, it's not
>>> worth enabling.
>>>
>>> This was with Ubuntu 8.10, built-in IB on the 2.6.27-14-server kernel.
>>>
>>> I couldn't get ramdisks working w/ SCST in RHEL5.2.  When running:
>>>
>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>
>>> I get the error:
>>>
>>> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required
>>> capabilities
>>>
>>> ... which doesn't occur in the Ubuntu kernel, so I've been unable to
>>> test RHEL kernels w/ ramdisks.  In general, this problem occurs w/ 8KB
>>> and smaller blocks w/ the Ubuntu kernels, and 2KB and smaller blocks
>>> w/ RHEL kernels.
>> Use ramfs instead.
> 
> Do you mean:
> 
> mount -t ramfs -o size=7g ramfs /mnt/

You should then create a file on it and use it.

> ?
> 
> That's what I'm doing.
> 
> Chris
>>> Chris
>>>> Bart.
>>>>
>>>
>>> ------------------------------------------------------------------------------
>>> Come build with us! The BlackBerry&reg; Developer Conference in SF, CA
>>> is the only developer event you need to attend this year. Jumpstart your
>>> developing skills, take BlackBerry mobile applications to market and stay
>>> ahead of the curve. Join us from November 9&#45;12, 2009. Register now&#33;
>>> http://p.sf.net/sfu/devconf
>>> _______________________________________________
>>> Scst-devel mailing list
>>> Scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>>> https://lists.sourceforge.net/lists/listinfo/scst-devel
>>>
>>
> _______________________________________________
> general mailing list
> general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
