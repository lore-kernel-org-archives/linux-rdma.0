From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC] [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Mon, 06 Jun 2011 13:28:40 -0500
Message-ID: <4DED1C58.5050507@opengridcomputing.com>
References: <1828884A29C6694DAF28B7E6B8A82373012B5B@ORSMSX101.amr.corp.intel.com> <4DED00A6.4010201@opengridcomputing.com> <BANLkTikvz7grX-7qaovTpgDb+0B1zwQPJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikvz7grX-7qaovTpgDb+0B1zwQPJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/06/2011 01:07 PM, Roland Dreier wrote:
> On Mon, Jun 6, 2011 at 9:30 AM, Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>  wrote:
>> Will this mechanism allow an RDMA provider driver to export a new qp-related
>> operation for use internally bit the supporting provider library?  IE Not
>> exposes to the RDMA application, but an internal interface between the
>> library and driver.  I have need for this with the T4 driver.
> Not sure I follow this... how specifically would this work?  Why does the
> userspace library need help to talk to the kernel driver?
>
>   - R.

I'm investigating ways to support a kernel mode "ring the QP doorbell" for user mode QPs.  This can allow optimization 
and coalescing of db-credits to improve the ring rate for large amounts of qps.  Currently for experimentation, I hacked 
this by posting a special send WR (with opcode 0xdeadbeef :) ) which ends up calling my db ring function, but I need to 
come up with an acceptable solution.   I was thinking about maybe enhancing the modify_qp verb, but perhaps this new 
extension proposal is a better way? I was also pondering some sort of provider-specific ioctl.  But this is really 
internal to the provider lib and driver.  I just don't want to have to implement a full character device interface for 
this since the uverbs interface provides this already.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
