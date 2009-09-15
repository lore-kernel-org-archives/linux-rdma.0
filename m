From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow	reads
 and eventually hangs
Date: Tue, 15 Sep 2009 20:39:06 +0400
Message-ID: <4AAFC32A.5050003@vlnb.net>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>	<f3177b9e0909031620i10db945ep69ddc36a7044334a@mail.gmail.com>	<e2e108260909060617y13a1ded8jd6686d02521ecb4@mail.gmail.com>	<f3177b9e0909060636k6e293c06la3dfe9f929da4915@mail.gmail.com>	<f3177b9e0909060641i296c7aefp322712f52de9786a@mail.gmail.com>	<4AA4F561.504@vlnb.net>	<f3177b9e0909081529i4dd74faq9a6c5a4783b5ded4@mail.gmail.com>	<e2e108260909090938x6b72c519teed7dfd280eac804@mail.gmail.com>	<f3177b9e0909111250w159def51h9b720366e27fa3a7@mail.gmail.com>	<4AAE909F.6030202@vlnb.net> <f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Chris Worley, on 09/15/2009 03:03 AM wrote:
> On Mon, Sep 14, 2009 at 12:51 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
>> Chris Worley, on 09/11/2009 11:50 PM wrote:
>>> I've definitely removed the switch/firmware from being the cause.
>>>
>>> I'm thinking the reason you can't repeat the test may be latency
>>> related.  We get ~50usecs average latency (on small block sizes),
>>> which can't be achieved using regular SSD's (and rotating drives are
>>> nowhere close).  Maybe a ramdisk would help repeat the issue.
>> I think you should try to reproduce the problem with ramdisk or nullio. By
>> so you will eliminate possible influence of the SSD backend.
> 
> W/ 12GB RAM in the target, I created a 7GB ramdisk:
> 
> mount -t ramfs -o size=7g ramfs /mnt/
> dd if=/dev/zero of=/mnt/foo bs=1024k count=7000
> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
> 
> Then, on the initiator, I tested it... and it hung during sequential
> 8KB block reads:
> 
> fio --rw=read --bs=8k --numjobs=64 --iodepth=64 --sync=0 --direct=1
> --randrepeat=0 \
>    --group_reporting --ioengine=libaio --filename=/dev/sde --name=test
> --loops=10000 --runtime=600
> 
> Note that I was running the SM on the target this time too.

Should you try then with iSCSI with IPoIB? It will eliminate the SRP stack.

> Thanks,
> 
> Chris
>> Vlad
>>
> 
> ------------------------------------------------------------------------------
> Come build with us! The BlackBerry&reg; Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay 
> ahead of the curve. Join us from November 9&#45;12, 2009. Register now&#33;
> http://p.sf.net/sfu/devconf
> _______________________________________________
> Scst-devel mailing list
> Scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
