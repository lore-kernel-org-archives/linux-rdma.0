From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CQEs in unreliable connection
Date: Fri, 29 Nov 2013 15:50:52 -0500
Message-ID: <CADPSxAjeU2u0nesuA=Go8WRufDcvztutR92dwuQyqgS1bcEeug@mail.gmail.com>
References: <CADPSxAhQKoKOQVbixMXvQRpp0_h1iQCtChrF0v1UUR1cZsPZvA@mail.gmail.com>
	<52979E37.3080000@gmail.com>
	<CADPSxAj-d+yP0=xs33bJPpXLv=8K0edJAvH6-ttdH2CvVcXtPQ@mail.gmail.com>
	<CAGUk2tHz6AE6WdmJAXnAj8Q=StaZ1V75i5ho0=kmRdSqOVd==g@mail.gmail.com>
	<CADPSxAjc-a0+icNH_MwVyCni9DkuyZvS_pcuWQ0x18mVDXWzvg@mail.gmail.com>
	<52982D04.70503@gmail.com>
	<CADPSxAh1_iea41miuYpv4dzvfud3AqxCgUDsr8jUeTSrxMfVpA@mail.gmail.com>
	<5298F97E.4030004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5298F97E.4030004-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hari Subramoni <subramoni.1-ZbGKxL/pcrQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Dotan,

Thanks for your reply again.

I just wanted to confirm about the order in which messages are sent
and received. I'm not worried about the memory policy.

--Anuj

On Fri, Nov 29, 2013 at 3:30 PM, Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 29/11/2013 16:53, Anuj Kalia wrote:
>>
>> Dotan,
>>
>> In the example that I asked about, the 5 packets do not form one
>> message - they are each individual messages. I assume this in the
>> following.
>>
>> I now understand that packet reordering cannot happen in IB - thanks!
>> Only packet loss can happen. From this, I can conclude the following
>> (please correct me if I'm wrong somewhere):
>>
>> "If the requester sends a sequence of single packet messages: {M_1,
>> M_2, ..., M_n}, then the sequence of packets at the responder will be
>> {M_i1, M_i2, ..., M_ik}, where i1 < i2 < ... < ik. Which is just
>> saying that messages can be lost, but not reordered."
>>
>> Is there a case where messages can be reordered in UC transport? i.e.
>> if the requester issues an RDMA write to buf[0] followed by an RDMA
>> write to buf[1], is it possible that at the responder the write to
>> buf[1] is done before the write to buf[0]? I don't think that this is
>> possible.
>
> I assume that we are talking about a single QP.
>
> The messages will be sent by the order they are sent:
> the message that access buf[0] will be sent (and received by the receiver)
> before the message that access buf[1].
>
> If you are talking about the way that the memory data is being written/seen
> in the remote side. I'm throwing a wild guess here, but *maybe* your process
> can see
> the new content in first buf[1] before buf[0] depends on the memory policy,
> NUMA location, etc...
> (this isn't a zone that I have a lot of knowledge in, but I think that this
> may have affect).
>
> Thanks
> Dotan
>
>
>
>>
>> Thanks again. Your comments and blog have been really useful.
>>
>> --Anuj.
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
