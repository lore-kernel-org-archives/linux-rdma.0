From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: NVMeoF Linux GIT repo
Date: Wed, 26 Oct 2016 13:00:42 +0300
Message-ID: <6f07770e-5b21-1c4f-9215-58f5821aae34@mellanox.com>
References: <f5eefaea1d4b4d24945fdfb12da5a6ab@bowex36e.micron.com>
 <2aeadd6a-0f5c-5c59-cafa-10116ccc91c0@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2aeadd6a-0f5c-5c59-cafa-10116ccc91c0-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Robert Randall (rrandall)" <rrandall-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/22/2016 1:19 AM, Sagi Grimberg wrote:
> Hey Robert,
> 
>> Sorry Keith, I'm back to the same question again.  I've tried using
>> the released 4.8.2 kernel and I'm seeing errors in the Linux RDMA
>> layer.  Log file is attached.  My guess is this may have been fixed
>> already but since I'm not writing code on Linux it is difficult to
>> keep up with which repo and which branch I should be using.
>>
>> It reports a syndrome 5 which appears to mean "work request flush error".
>>
>> Setup is stable 4.8.2 kernel with Mellanox RoCE v2.
>>
>> So, where do I grab the latest and greatest code these days?
> 
> So from a quick look at the log the FLUSH errors are
> just side effects. Once a queue-pair transitions to
> ERROR state it flushes all the pending work requests with
> a FLUSH syndrome, so we should look at the first error which
> is:
> 
> mlx5_1:poll_soft_wc:647:(pid 3422): polled software generated completion
> on CQ 0x14
> 
> This seems to come from the GSI QP completion emulation from
> Haggai (CC'd). CQ 0x14 is not nvmet-rdma completion queue (from
> the log it's 0x5d) so something went wrong but its does not
> seem to be nvmet-rdma's fault.
I'm not sure this line means anything wrong as happened. It just means
that the software emulated CQ has received a packet (a MAD), and that
debugging prints are on.

We did had a bug with that code, and it was fixed in [1] (kernel 4.8) so
you should have the fix.

> 
> Haggai, any tips for Robert?

I'll take another look at the logs and see if I think of anything.

[1] https://patchwork.kernel.org/patch/9211211/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
