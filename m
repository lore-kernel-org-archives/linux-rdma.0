From: "Arend Dittmer" <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
Subject: RE: SRPT and SCST
Date: Tue, 10 Nov 2009 16:33:56 -0800
Message-ID: <3142CEFB1403044F9954E2DF6C85660FB801C9@orca.penguincomputing.com>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com><654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9@orca.penguincomputing.com><e2e108260911052306l230d8d7cxbae68bf08678d6fe@mail.gmail.com><4AF40FBC.9080004@vlnb.net><654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4FA@orca.penguincomputing.com><e2e108260911060653g6832c124uaa6e11072a12e448@mail.gmail.com><4AF45134.30207@vlnb.net><3142CEFB1403044F9954E2DF6C85660FBB34E6@orca.penguincomputing.com><e2e108260911080149t569fc016p6e38d86a15cb7d05@mail.gmail.com><4AF87B05.1050902@vlnb.net> <f3177b9e0911091243j135fe526t7c5a03f860d46b68@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To Bart's earlier question  ... we apologize for not being able to come=
 up with a time and date when the initiators lost contact with the targ=
et. We have not been able to test with an initiator from a vanilla kern=
el. We only tested with the initiator that ships with RedHat 5.3. We bu=
ilt the module against a slightly modified RedHat kernel that includes =
process management patches that allow for a unified process space for o=
ur cluster management software Scyld clusterware. Our patches do not af=
fect any storage components.=20

[root@head0 ~]# bpsh 1 modinfo ib_srp
filename:       /lib/modules/2.6.18-128.1.1.el5.530g0000/kernel/drivers=
/infiniband/ulp/srp/ib_srp.ko

license:        Dual BSD/GPL
description:    InfiniBand SCSI RDMA Protocol initiator v0.2 (November =
1, 2005)
author:         Roland Dreier
srcversion:     23B2629641E1A475BF72F44
depends:        ib_core,scsi_mod,ib_cm,ib_sa
vermagic:       2.6.18-128.1.1.el5.530g0000 SMP mod_unload gcc-4.1
parm:           srp_sg_tablesize:Max number of gather/scatter entries p=
er I/O (default is 12) (int)
parm:           topspin_workarounds:Enable workarounds for Topspin/Cisc=
o SRP target bugs if !=3D 0 (in
t)
parm:           mellanox_workarounds:Enable workarounds for Mellanox SR=
P target bugs if !=3D 0 (int)
parm:           srp_dev_loss_tmo:Default number of seconds that srp tra=
nsport should              in
sulate the lost of a remote port (default is 60 secs (int)
module_sig:     883f35049c0555e56ccec1c0ba19c3112f87b09e2872185017b618b=
6026be92291a62b5446018e009d1e
3299cd274ad8e31c3d0b03081b112959d4d84

Also ... we ran with only a single thread.

Thanks

Arend    =20


-----Original Message-----
=46rom: Chris Worley [mailto:worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
Sent: Mon 11/9/2009 3:43 PM
To: Vladislav Bolkhovitin
Cc: Bart Van Assche; Arend Dittmer; Philip Pokorny; scst-devel-5NWGOfrQmnc@public.gmane.org=
urceforge.net; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Vu Pham
Subject: Re: SRPT and SCST
=20
On Mon, Nov 9, 2009 at 1:26 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wr=
ote:
> Bart Van Assche, on 11/08/2009 12:49 PM wrote:
>>
>> On Fri, Nov 6, 2009 at 6:28 PM, Arend Dittmer
>> <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>>>
>>> Please find attached the gzip'ed /var/log/messages.
>>
>> This log clearly show the login and logout actions from the differen=
t
>> initiators. I couldn't find anything unusual in the posted log file
>> however. Around which time did the initiator start complaining about
>> aborted SCSI commands ? Does this issue also happen when using the S=
RP
>> initiator included in a vanilla (non-OFED) Linux kernel ?
>
> It looks painfully similar to what Chris Worley experienced some time=
 ago
> and somehow fixed/workarounded.
>
> Chris, can you comment on this?

The "thread=3D1" fixed the problem mostly, but I am working with anothe=
r
group that says they still get an abort, but haven't gotten around to
providing me with the info I need to look at it.

Chris
>
>> Bart.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
