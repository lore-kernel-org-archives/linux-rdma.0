From: Vlad Weinbaum <vlad.weinbaum-adSD+vzF2QdBDgjK7y7TUQ@public.gmane.org>
Subject: Re: cq error timeout issue
Date: Mon, 31 Oct 2011 09:08:00 +0200
Message-ID: <CAFAcbYNJFH0n=gFwki0uLUzDd6cu7MxuHR99x9i9wUY3xp+Hdg@mail.gmail.com>
References: <CAFAcbYPXqcOc79fcWHK7iHkfEX0ecmg4CBSUgUk=C=xiScSRRw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E8B236@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E8B236-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thank you Sean,

I have an access to OpenSM configuration on the switch in my testing
environment. I tried to reduce the timout there (subnet_timeout,
packet_life_time), but unsuccessfully.
Btw, I found detail that I cannot explain. I query the QP after
connect and get timeout value 16, that must be 4 us * 2^ 16 =3D 256 ms,
but I get about 800 ms.

Thanks,
Vlad

On Mon, Oct 31, 2011 at 8:51 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> I try to use ibv_poll_cq to identify connectivity problems. The
>> scenario is following, based on modified rping example:
>>
>> 1) preliminary steps done and rdma connection established between
>> Client and Server, retry_count in rdma_conn_param is set 1;
>> 2) Server lost its link (corresponding switch port disabled), Client
>> is still connected to the switch;
>> 3) Client calls ibv_post_send
>> 4) Client polls cq with ibv_poll_cq and gets expected
>> IBV_WC_RETRY_EXC_ERR after about 1 second.
>>
>> Can this timeout be decreased? If it is impossible, can you suggest
>> something else?
>
> I don't believe easily. =A0The timeout is based on the path record re=
turned by the SM, which is really what an app should use. =A0If you can=
 adjust the timeout at the SM, that would be best.
>
> If you can use a newer kernel, another alternative is to use rdma_set=
_option to provide your own path record as input in place of calling rd=
ma_resolve_route.
>
> Btw, with a small timeout and few retries, if you're not using QoS, y=
ou may want to enable that to prevent false timeouts.
>
> - Sean
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
