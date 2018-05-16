From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Wed, 16 May 2018 12:42:37 -0400
Message-ID: <695ae613-931a-50ba-2b83-9d172e0ac2bc@dev.mellanox.co.il>
References: <20180509093020.24503-3-Haakon.Bugge@oracle.com>
 <ab1f16cd-aa60-0c43-841c-aed301fd2a7e@dev.mellanox.co.il>
 <F9802EE9-4420-44EE-93DC-27CC799B427E@oracle.com>
 <3bee76df-49a6-cf3c-6df4-749a6309358e@dev.mellanox.co.il>
 <B3360947-5905-47BD-ABC4-6C4BB32F5DA6@oracle.com>
 <20180514210200.GN21531@ziepe.ca>
 <ab0e1318-8e1a-5822-5484-33e460095830@dev.mellanox.co.il>
 <E41BCEAA-0204-448D-8188-ACA03932B3AC@oracle.com>
 <20180515190424.GL5615@ziepe.ca>
 <3E15B62F-E705-43BD-8A72-9E74F784D40E@oracle.com>
 <20180516151201.GA25661@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516151201.GA25661@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/16/2018 11:12 AM, Jason Gunthorpe wrote:
> On Wed, May 16, 2018 at 08:47:21AM +0200, Håkon Bugge wrote:
> 
>>> This is not a difficult issue.
>>>
>>> If the GMP is properly tagged with the right PKey then it will never
>>> be delivered to the VM if the VM does not have the PKey in the
>>> table.
>>
>> Not quite right. For the shared port model, a GMP will (most
>> probably) be accepted by the physical port, due to:
> 
> Sure, but I am talking about the VM's 'virtual port'.
> 
>> So, if the GMP is destined to VM1, which is a limited member, but we
>> have another VM2 which is a full member of the same partition, the
>> GMP will pass the HCA’s PKey check.
> 
> Sure.
> 
>>> It is up to the hypervisor to block GMPs that have Pkeys not in
>>> the virtual PKey table of the VF.
>>
>> The packet is received by the HCA and stripped from IB headers, in
>> particular the BTH. How can the "hypervisor" block it when its
>> doesn’t have access to the GMP’s BTH.PKey?
> 
> This is wrong too, in Linux the WC's for GMP packets include the pkey
> index that was used to RX the packet. This is a Linux extension
> matching the one on the sending side.
> 
> The hypervisor *must* block these GMPs, it is a hard requirement of
> the pkey security model for VMs.

Aside from the pkey enforcement at the VF, there is also the issue of
the pkey trap - if physical port model is followed for shared virtual
ports, trap should be generated which could look confusing to SM as well
as counting in some error counter (for physical port, it's either
PortCounter:Port[Xmit Rcv]ConstraintErrors.

> AFAIK the Mellanox drivers do this right - do you know differently?
> 
>>> The only time you could need a new REJ code is if the GMP is using a
>>> PKey different from the REQ - which is a pretty goofy thing to do
>>> considering this VM case.
>>
>> Its goofy. In the CX-3 shared port model, the BTH.PKey is the
>> default one and the REQ.PKey is the full one even if the sending
>> VM’s port only is a limited member. This patch series fixes the last
>> issue.
> 
> Again, this is wrong, the BTH.Pkey and REQ.Pkey should be the same -

I do not believe there is anything in the spec that requires this. I
agree it's the simplest use model though.

> please fix that first before trying to change anything else.
> 
>>> Remember the SM doesn't know what Pkeys are in the VM, so it is
>>> basically impossible for the REQ side to reliably select two different
>>> pkeys and know that they will bothmake it to the VM.
>>
>> The active side should use the "authentic" PKey in the REQ
>> message. That is the one that would be used in BTH.PKey when
>> communication has been established. This is implemented by this
>> patch series.
>>
>> Not sure what you mean by "reliably select two different pkeys". The
>> CM REQ message contains one PKey.
> 
> If BTH.Pkey != REQ.PKey then the requestor side has to obviously
> select two PKeys, which is basically impossible.
> 
> The VM should not be part of the default partition, for instance.

I think that the VM is at least a limited member of the default partition.

-- Hal

>> See above, not sure how that could be implemented. And if it is
>> solved by the HCA trapping the GMP due to the PKey check, it doesn’t
>> help me, as the purpose of the series is to avoid (excessive) PKey
>> traps sent to the SM.
> 
> It might not help you, but is shows this fix for the pkey trap issue
> is wrong. You must fix the pkey traps on the sending side, not on the
> responder side..
> 
>>> If I recall there were bugs here in mlx drivers, where the driver
>>> sent with the wrong Pkey. I think this has actually been fixed
>>> now, so please check the upstream kernel to be sure the Pkey is
>>> not what it is supposed to be.
>>
>> Let me get back to you with some ibdumps here.
> 
> Upstream kernel (eg 4.16) and newish Mellanox firmware please.
> 
> And it would be fantastic if you could ID why this is happening, AFAIK
> it should be OK in the kernel.
> 
> Jason
> 
