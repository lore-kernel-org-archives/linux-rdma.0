From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Wed, 11 Nov 2009 15:36:24 +0300
Message-ID: <4AFAAFC8.1060006@vlnb.net>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com><654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9@orca.penguincomputing.com><e2e108260911052306l230d8d7cxbae68bf08678d6fe@mail.gmail.com><4AF40FBC.9080004@vlnb.net><654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4FA@orca.penguincomputing.com><e2e108260911060653g6832c124uaa6e11072a12e448@mail.gmail.com><4AF45134.30207@vlnb.net><3142CEFB1403044F9954E2DF6C85660FBB34E6@orca.penguincomputing.com><e2e108260911080149t569fc016p6e38d86a15cb7d05@mail.gmail.com><4AF87B05.1050902@vlnb.net> <f3177b9e0911091243j135fe526t7c5a03f860d46b68@mail.gmail.com> <3142CEFB1403044F9954E2DF6C85660FB801C9@orca.penguincomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3142CEFB1403044F9954E2DF6C85660FB801C9-/U8SqUwOx9/OOpeOfUw7maQk6oIRg43YAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Arend Dittmer, on 11/11/2009 03:33 AM wrote:
> To Bart's earlier question  ... we apologize for not being able to come up with a time and date when the initiators lost contact with the target. We have not been able to test with an initiator from a vanilla kernel. We only tested with the initiator that ships with RedHat 5.3. We built the module against a slightly modified RedHat kernel that includes process management patches that allow for a unified process space for our cluster management software Scyld clusterware. Our patches do not affect any storage components. 
> 
> [root@head0 ~]# bpsh 1 modinfo ib_srp
> filename:       /lib/modules/2.6.18-128.1.1.el5.530g0000/kernel/drivers/infiniband/ulp/srp/ib_srp.ko
> 
> license:        Dual BSD/GPL
> description:    InfiniBand SCSI RDMA Protocol initiator v0.2 (November 1, 2005)
> author:         Roland Dreier
> srcversion:     23B2629641E1A475BF72F44
> depends:        ib_core,scsi_mod,ib_cm,ib_sa
> vermagic:       2.6.18-128.1.1.el5.530g0000 SMP mod_unload gcc-4.1
> parm:           srp_sg_tablesize:Max number of gather/scatter entries per I/O (default is 12) (int)
> parm:           topspin_workarounds:Enable workarounds for Topspin/Cisco SRP target bugs if != 0 (in
> t)
> parm:           mellanox_workarounds:Enable workarounds for Mellanox SRP target bugs if != 0 (int)

Hmm, "workarounds for Mellanox SRP target", i.e. for SCST SRP target? 
For what are those workarounds and why don't fix the corresponding 
problems in the target? From the source code it isn't obvious..

> parm:           srp_dev_loss_tmo:Default number of seconds that srp transport should              in
> sulate the lost of a remote port (default is 60 secs (int)
> module_sig:     883f35049c0555e56ccec1c0ba19c3112f87b09e2872185017b618b6026be92291a62b5446018e009d1e
> 3299cd274ad8e31c3d0b03081b112959d4d84
> 
> Also ... we ran with only a single thread.
> 
> Thanks
> 
> Arend     
> 
> 
> -----Original Message-----
> From: Chris Worley [mailto:worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Mon 11/9/2009 3:43 PM
> To: Vladislav Bolkhovitin
> Cc: Bart Van Assche; Arend Dittmer; Philip Pokorny; scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Vu Pham
> Subject: Re: SRPT and SCST
>  
> On Mon, Nov 9, 2009 at 1:26 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
>> Bart Van Assche, on 11/08/2009 12:49 PM wrote:
>>> On Fri, Nov 6, 2009 at 6:28 PM, Arend Dittmer
>>> <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>>>> Please find attached the gzip'ed /var/log/messages.
>>> This log clearly show the login and logout actions from the different
>>> initiators. I couldn't find anything unusual in the posted log file
>>> however. Around which time did the initiator start complaining about
>>> aborted SCSI commands ? Does this issue also happen when using the SRP
>>> initiator included in a vanilla (non-OFED) Linux kernel ?
>> It looks painfully similar to what Chris Worley experienced some time ago
>> and somehow fixed/workarounded.
>>
>> Chris, can you comment on this?
> 
> The "thread=1" fixed the problem mostly, but I am working with another
> group that says they still get an abort, but haven't gotten around to
> providing me with the info I need to look at it.
> 
> Chris
>>> Bart.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
