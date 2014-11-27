From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC PATCH 03/16] ib/mad: Add check for jumbo MADs support on
 a device
Date: Thu, 27 Nov 2014 15:51:44 +0200
Message-ID: <54772C70.8060602@dev.mellanox.co.il>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com> <1415908465-24392-4-git-send-email-ira.weiny@intel.com> <54770F44.2090909@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54770F44.2090909-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/27/2014 1:47 PM, Or Gerlitz wrote:
> On 11/13/2014 9:54 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>
>> Add a device capability flag for OPA devices to signal their support
>> of "jumbo"
>> MADs.
>>
>> Check for IB_DEVICE_JUMBO_MAD_SUPPORT in the device capabilities and if
>> supported mark the special QPs created.
>
> Ira,
>
> Few comments here, the device capability is OK, specifically if it helps
> for the mad
> layer logic to be simpler and/or more robust.
>
> You should add device attribute telling what is the size of MADs
> supported by the
> device, I think the IBTA mandated 256Band in the OPA case, the driver
> will fill there 2k.
>
> You can't just state that (jumbo == 2k) and go to complete design/changes
> which use this hard-coded assumption. You need to see how to re-spin
> this series
> w.o this assumption.

Why do we need both? can't we just rely on just the size?

We're already short on bits in device_cap_flags so maybe we can do
without?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
