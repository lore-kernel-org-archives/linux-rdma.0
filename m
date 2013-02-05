From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: infiniband: cxgb4: GCC warnings for 32 bit
Date: Tue, 05 Feb 2013 09:46:11 -0600
Message-ID: <51112943.3040003@opengridcomputing.com>
References: <1360059358.1343.37.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360059358.1343.37.camel-uMdlDhfIn7prKue/0VVhAg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/5/2013 4:15 AM, Paul Bolle wrote:
> 0) Compiling cm.o for 32 bit triggers these GCC warnings:
>      drivers/infiniband/hw/cxgb4/cm.c: In function =E2=80=98passive_o=
fld_conn_reply=E2=80=99:
>      drivers/infiniband/hw/cxgb4/cm.c:2803:12: warning: cast to point=
er from integer of different size [-Wint-to-pointer-cast]
>      drivers/infiniband/hw/cxgb4/cm.c: In function =E2=80=98send_fw_p=
ass_open_req=E2=80=99:
>      drivers/infiniband/hw/cxgb4/cm.c:2941:16: warning: cast from poi=
nter to integer of different size [-Wpointer-to-int-cast]
>      [last line repeated a number of times]
>
> 1) These two lines were added in commit
> 1cab775c3e75f1250c965feafd061d696df36e53 ("RDMA/cxgb4: Fix LE hash
> collision bug for passive open connection"). That commit was first
> released in v3.8-rc1. It's not obvious to me how to fix these warning=
s,
> since these lines are a bit puzzling.
>
> 2) These lines read:
>     rpl_skb =3D (struct sk_buff *)cpu_to_be64(req->cookie);
>
> and:
>     req->cookie =3D cpu_to_be64((u64)skb);
>
> 3) It is odd that both use cpu_to_be64(). It seems the first one shou=
ld
> have been be64_to_cpu().

True, the first one should be be64_to_cpu().

> But 'cookie' is of type __u64 (see struct
> cpl_fw6_msg_ofld_connection_wr_rpl in
> drivers/net/ethernet/chelsio/cxgb4/t4_msg.h). So the use of both that
> type and the cpu_to_be64() macro looks a bit odd too.
>
> And why is 'cookie' __u64? Is struct cpl_fw6_msg_ofld_connection_wr_r=
pl
> used in userspace code? Can't 'cookie' be of type "struct sk_buff *"?=
 Is
> there a requirement for it to be 64 bits wide on both 32 bit and 64 b=
it?

In general, these fields are __ types to highlight the fact that they=20
define an interface between the host driver and adapter firmware.  Thes=
e=20
"cookie" fields are opaque to the firmware.  They are passed to firmwar=
e=20
in a work request and then reflected back to the host in the reply to=20
the work request.  Given this, I think there are two issues:

1) no swapping is really needed.  The values are opaque to firmware, an=
d=20
thus can stay in host byte order.

2) to remove the warning, we need something like:

req->cookie =3D (unsigned long)skb;

and
 =20
rpl_skb =3D (struct sk_buff *)(unsigned long)req->cookie;


Steve.

>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
