From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Setting ACK timeout for QP's created using RDMA_CM.
Date: Fri, 29 Jan 2010 11:57:05 -0500
Message-ID: <f0e08f231001290857k37c5f891tbb730d22aabc3075@mail.gmail.com>
References: <Pine.GSO.4.40.1001290933060.4760-100000@kappa.cse.ohio-state.edu>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF12D589ABB6@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF12D589ABB6-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 29, 2010 at 11:43 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
>>uint8_t timeout; /* Local ack timeout for primary path (valid only fo=
r RC
>>QPs)*/
>>
>>I believe that this is the period of time (in seconds) that the IB HC=
A
>>will wait for the ACK for a packet it sent out before re-transmitting=
? I
>>was looking as to whether this field can be modified when creating a =
QP
>>using RDMA_CM.
>
> This field is set based on the packet lifetime carried in the path re=
cord. =C2=A0If you're using opensm, there's probably a configuration op=
tion that can adjust this (subnet timeout, maybe?).

Yes, OpenSM returns subnet_timeout as the SA PathRecord PacketLifeTime
assuming it's not loopback and no QoS set.

-- Hal

> =C2=A0The time given for the QP attribute is in 'IB time': 4.096 x 2 =
^ timeout micro-seconds.
>
> - Sean
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
