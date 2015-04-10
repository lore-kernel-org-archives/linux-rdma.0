From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: RDMA Multicasting
Date: Fri, 10 Apr 2015 16:54:46 +0000
Message-ID: <DFD3BCD4-5D18-4F32-AB29-5543AED4E107@ornl.gov>
References: <A1EC1DB6D8AEAF4CB8006B3653F61C5471F997F9@CMEXMB1.ad.emulex.com>
 <alpine.DEB.2.11.1504090955080.19714@gentwo.org>
 <5526c0f8.2116430a.28f7.ffffd059SMTPIN_ADDED_BROKEN@mx.google.com>
 <alpine.DEB.2.11.1504091329180.24028@gentwo.org>
 <5526e18b.a50c450a.4b9f.77beSMTPIN_ADDED_BROKEN@mx.google.com>
 <alpine.DEB.2.11.1504101011300.30374@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1504101011300.30374-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <EFC247A6D29B454D8D9D3B7768DAD063-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>, Allen Andrews <Allen.Andrews-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 10, 2015, at 11:14 AM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, 9 Apr 2015, Caitlin Bestler wrote:
> 
>>> Infiniband is lossless and thus what "unreliable" means is also quite
>>> foggy.
>> 
>> InfiniBand is not lossless. It does a superb job of avoiding drops caused
>> by congestion. But applications should not assume that all UD messages
>> have been received, but should add their own checking. That is why the
>> U stands for Unreliable.
> 
> Well applications can screw up yes but the fabric *IS* lossless.

On a very rare bit flip, the switches or HCAs can drop a UD packet. Lossless, but not guaranteed.

> 
>>>> You are probably better off using RDMA ideas over UDP/UD, and doing the
>>>> direct memory placement from your own code, instead.
>>> 
>>> So send the memory transfer info via multicast datagram to the
>>> endpoints and then run the transfer from the endpoint.
>> 
>> Yes, possibly in a kermel module.
> 
> Why? You can simply do this already from userspace with verbs messaging
> and RDMA tranfers.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
