From: Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
Date: Tue, 29 May 2012 15:53:05 -0700
Message-ID: <4FC55351.6020503@sgi.com>
References: <4FC53AAA.3060203@ddn.com> <4FC544FE.3000204@sgi.com> <4FC54D62.3080003@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC54D62.3080003-LfVdkaOWEx8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dillowda-1Heg1YXhbW8@public.gmane.org" <dillowda-1Heg1YXhbW8@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thank you for clarifying!

On 05/29/2012 03:27 PM, Karandeep Chahal wrote:
> Hi Michael,
>
> Yes, I tried reconnecting the targets and removing reinserting ib-srp.
>
> Thanks
> Karan
>
>
> On 05/29/2012 05:51 PM, Michael Reed wrote:
>> Did you subsequently reconnect the target and confirm appropriate behavior?
>>
>>
>> On 05/29/2012 02:07 PM, Karandeep Chahal wrote:
>>> Subject: [PATCH] Infiniband srp fast failover patch. Currently ib_srp does
>>>      not do anything on receiving a DREQ from the target, it
>>>      only sends a response back. Further it also does not
>>>      monitor port (down) events. I have patched srp to remove
>>>      scsi devices when a port down event is received or if the
>>>      target sends a DREQ. Currently even though the target
>>>      notifies the initiator of its intentions of going away, the
>>>      initiator ignores that information. Later the initiator
>>>      gets upset when the devices "suddenly" disappear resulting
>>>      in srp initiating an error recovery process which takes a
>>>      long time. This caused high failover latencies as compared
>>>      to fibre channel. In my experiments with RHEL 6.0 and 6.2 I
>>>      encountered failover time that exceeded 2 minutes and 20
>>>      seconds (despite tweaking /etc/multipath.conf and
>>>      /sys/block/<>/timeout). With this patch the failover takes
>>>      30 seconds. I have tested this patch with and without a
>>>      switch.
>>>
>>> Yours, etc.
>>> Karan
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
