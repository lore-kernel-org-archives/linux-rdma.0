From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: Mellanox implementation for atomic operations
Date: Wed, 16 Jun 2010 09:41:57 -0700
Message-ID: <1276706517.32179.450.camel@chromite.mv.qlogic.com>
References: <201005101435267348378@inspur.com>
	 <201005101442273436938@inspur.com>  <4C17E790.2020900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C17E790.2020900-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, shipr <shipr-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ib_qib driver supports atomic IB operations and
they are global since it does it in the host software
instead of PCIe bus transactions which don't have
global atomic support (yet).

On Tue, 2010-06-15 at 13:50 -0700, Dotan Barak wrote:
> Hi.
> 
> On 10/05/2010 08:42, lihaidong wrote:
> > Hi,
> >    I have a question about atomic operations.
> >    According to IB specification o10-48, all atomic operation request made to the same HCA, referencing the same physical memory are serialized with respect to each other.  I know this should be complied with if HCA supports atomic operations, right?
> >   
> Right.
> >    According to  IB specification o10-49, all atomic operations requests that referencing the same physical memory are serialized with respect to each other. This means that atomic operations performed by processors should serialized with atomic operations performed by HCAs, too, if they were referencing the same physical memory.
> >   
> So far so good.
> >   I want to know whether Mellanox implementation for atomic operations comply with o10-49 or not.
> >   if not ,to what extent it comply with the rule? 
> >   I also was intrested in how this rule is complied with by others vendors?
> >
> >   
> Let give you a general answer:
> The struct ibv_device_attr contains the atomic_cap attribute, this
> attribute defines the atomicity
> level that the HCA support (None, only within the HCA, between all HCAs
> (global)).
> 
> I think that your code should check this attribute
> (This way your code will support all vendors HCAs).
> 
> As much as i know, atomic operations are only supported within one HCA.
> 
> I hope that this answer helped you ..
> Dotan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
