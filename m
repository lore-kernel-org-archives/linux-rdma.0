From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] verbs: Report the device's PCI write end
 paddding capability
Date: Wed, 15 Nov 2017 18:18:58 +0200
Message-ID: <6bf6b93d-199f-ff7b-5d92-cc482cdc6870@dev.mellanox.co.il>
References: <1510667228-18579-1-git-send-email-yishaih@mellanox.com>
 <1510667228-18579-2-git-send-email-yishaih@mellanox.com>
 <20171114203344.GS4263@ziepe.ca>
 <915b8140-2f83-1bc2-3334-b2454f4abb33@dev.mellanox.co.il>
 <20171115151518.GM25894@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115151518.GM25894-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/15/2017 5:15 PM, Jason Gunthorpe wrote:
> On Wed, Nov 15, 2017 at 03:10:30PM +0200, Yishai Hadas wrote:
> 
>> The man page was updated with a detailed description on the above
>> capability, see PR:
>> https://github.com/linux-rdma/rdma-core/pull/250
> 
> Yah, that is nicer
> 
> Here is some copy-editing:
> 
> Extended device capability flags (device_cap_flags_ex):
> .br
> .TP 7
> IBV_DEVICE_PCI_WRITE_END_PADDING
> 
> Indicates the device has support for padding PCI writes to a full cache line.
> 
> Padding packets to full cache lines reduces the amount of traffic required at
> the memory controller at the expense of creating more traffic on the PCI-E
> port.
> 
> Workloads that have a high CPU memory load and low PCI-E utilization will
> benefit from this feature, while workloads that have a high PCI-E utilization
> and small packets will be harmed.
> 
> For instance, with a 128 byte cache line size, the transfer of any packets
> less than 128 bytes will require a full 128 transfer on PCI, pontentially
> doubling the required PCI-E bandwith.
> 
> This feature can be enabled on a QP or WQ basis via the
> IBV_QP_CREATE_PCI_WRITE_END_PADDING or IBV_WQ_FLAGS_PCI_WRITE_END_PADDING
> flags.
> 

OK, PR was updated accordingly.
https://github.com/linux-rdma/rdma-core/pull/250
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
