From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ConnectX saquery question
Date: Wed, 14 Oct 2009 09:37:06 -0400
Message-ID: <f0e08f230910140637g5049658cy8b3481c06b0865af@mail.gmail.com>
References: <eafd71280910140630w2ca6a802s9ef98362d0fecb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <eafd71280910140630w2ca6a802s9ef98362d0fecb6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2009 at 9:30 AM, Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
> I searched the lists and can't really find an answer to my question-
>
> When I run saquery -s on my cluster with ConnectX HCAs (fw ver
> 2.6.648) all I get is the following output
>
> IsSM ports
>
> IsSMdisabled ports
>
> I thought this should show ports that are running a subnet manager
> (there are 2 running on the cluster) or am I incorrect?

That means that the IsSM bit in PortInfo:CapabilityMask is not being
set. Maybe that's not supported by the firmware.

-- Hal

>
> Thanks!
>
> -Aaron
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
