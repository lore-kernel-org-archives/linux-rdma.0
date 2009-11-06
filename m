From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Fri, 06 Nov 2009 19:39:16 +0300
Message-ID: <4AF45134.30207@vlnb.net>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com>	 <f3177b9e0911041004t2e75d545v5cc10d5375550bde@mail.gmail.com>	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4DD@orca.penguincomputing.com>	 <4AF29201.6000606@penguincomputing.com> <4AF2D2B8.5080304@vlnb.net>	 <e2e108260911051034o43db58cdi65b84ce46219bb94@mail.gmail.com>	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9@orca.penguincomputing.com>	 <e2e108260911052306l230d8d7cxbae68bf08678d6fe@mail.gmail.com>	 <4AF40FBC.9080004@vlnb.net>	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4FA@orca.penguincomputing.com> <e2e108260911060653g6832c124uaa6e11072a12e448@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260911060653g6832c124uaa6e11072a12e448-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche, on 11/06/2009 05:53 PM wrote:
> On Fri, Nov 6, 2009 at 3:39 PM, Philip Pokorny
> <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>>>> This tells me that there is a pending I/O waiting to be completed but it
>>>> seems to have been lost on the server, because this is taking much too
>>>> long.  There are 7 seconds "between" each line of output above so that's
>>>> almost 30 seconds of output with *no* change in the I/O status.
>>>>
>>>> The "gzip | tar -x" I was running is "hung"
>> Upon further investigation, I found that the clients had actually aborted SCSI commands that took too long:
>>
>> sd 7:0:0:1: timing out command, waited 180s
>> sd 7:0:0:1: SCSI error: return code = 0x06000000
>> end_request: I/O error, dev sdb, sector 60377910
>> Buffer I/O error on device sdb1, logical block 30188699
>> lost page write due to I/O error on sdb1
>> sd 7:0:0:1: timing out command, waited 180s
>> sd 7:0:0:1: SCSI error: return code = 0x06000000
>> end_request: I/O error, dev sdb, sector 186810934
>> EXT3-fs error (device sdb1): ext3_get_inode_loc: unable to read inode block - inode=11675841, block=93405211
>> Aborting journal on device sdb1.
>>
>> I should point out that the IB_SRP CLIENT we are using is from OFED 1.3.2
>>
>> [root@head0 ~]# modinfo ib_srp
>> filename:       /lib/modules/2.6.18-128.1.1.el5.530g0000/kernel/drivers/infiniband/ulp/srp/ib_srp.ko
>> license:        Dual BSD/GPL
>> description:    InfiniBand SCSI RDMA Protocol initiator v0.2 (November 1, 2005)
>>
>> These are Red Hat 5 clients and we can upgrade to Red Hat 5.4 with the Red Hat IB_SRP, but it may be the same code.  Anything else will be more work.
> 
> It might be a good idea to repeat the test with the SRP initiator
> included with RHEL 5 instead of the OFED SRP initiator. At least one
> bug that is present in the OFED SRP initiator is not present in the
> RHEL 5 SRP initiator. See also
> https://bugs.openfabrics.org/show_bug.cgi?id=1745 for an example.
> 
>>> Can you please post the SCST target logs available for the above scenario ?
>> Yes, and please make sure you are running the debug build.
>>
>> =====
>> Sure.  We *are* running the CONFIG_SCST_DEBUG build.
>>
>> How do I collect the target logs?  I don't see anything obvious in /proc/scsi_tgt/...

They are in the regular kernel logs. Refer to you distribution kernel 
logging configuration to find out where they are stored. Usually it is 
/var/log/messages.

> The following commands will enable lots of additional tracing
> information (probably way too much):
> cat /proc/scsi_tgt/help
> echo all >/proc/scsi_tgt/trace_level
> echo all >/proc/scsi_tgt/vdisk/trace_level

The above commands will enable all the logging. But in this case it will 
be an overkill. By default CONFIG_SCST_DEBUG configuration has all the 
minimally necessary logging enabled, so, Philip, for your case you don't 
need to enable anything additional.

> echo all >/proc/scsi_tgt/ib_srpt/trace_level
> 
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
