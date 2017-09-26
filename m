From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Tue, 26 Sep 2017 11:12:16 -0700
Message-ID: <20170926181214.GA41364@knc-06.sc.intel.com>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
 <20170926174946.GA1218@mtr-leonro.local>
 <20170926175524.GA2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926175524.GA2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 08:55:24PM +0300, Leon Romanovsky wrote:
>On Tue, Sep 26, 2017 at 08:49:46PM +0300, Leon Romanovsky wrote:
>> On Tue, Sep 26, 2017 at 07:08:37AM -0700, Dennis Dalessandro wrote:
>> > Hi Doug,
>> >
>> > Here are the other two patches for opa_vnic. This adds a debugfs interface and
>> > that is why I'm sending it as a separate series apart from the rest of our
>> > submissions. The goal is to support view/modify of the VESW port config.
>> >
>> > Patches can can also be found in my GitHub repo at:
>> > https://github.com/ddalessa/kernel/tree/for-4.15
>> >
>> > ---
>>
>> Can you elaborate more on the reasons why debugfs was chosen over more
>> generic configuration tool?
>>
>> +DEBUGFS_FILE_OPS(vport_state);
>>
>> Maybe, I'm too biased with rdmatool, but I don't see many reasons to
>> introduce debugfs for the ULP.
>
>And honestly, netdevices have so much tools to configure them (ethtool,
>iproute2, e.t.c.) so I completely don't understand the rationale behind
>debugfs for OPA-VNIC.
>
>Thanks
>
Hi,

The debugfs interface here is for VNIC port encapsulation configuration.
They are not related to netdevice functionality.

They are for debug purpose only and not the supported configuration mechanism.
Hence, I think they probably shouldn't be in a tool like rdmatool.

Niranjana

>>
>> Thanks
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
