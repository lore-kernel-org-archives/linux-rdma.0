From: Larry <tsrjzq-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Issue with RDMA_CM on systems with multiple IB HCA's.
Date: Fri, 23 Jul 2010 17:32:59 +0800
Message-ID: <AANLkTinPRAPDZi8xn5zOr5k26-=040N45vVWk1usf8H5@mail.gmail.com>
References: <Pine.GSO.4.40.1007212046022.17-100000@kappa.cse.ohio-state.edu>
	<4C47EFFB.1040808@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C47EFFB.1040808-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 22, 2010 at 3:15 PM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wro=
te:
> Hari Subramoni wrote:
>> [subramon@amd6 perftest]$ ./ib_rdma_bw -c 172.16.1.5
>> 11928: | port=3D18515 | ib_port=3D1 | size=3D65536 | tx_depth=3D100 =
| iters=3D1000 | duplex=3D0 | cma=3D1 |
>> 11928: Local address: =A0LID 0000, QPN 000000, PSN 0x5bfbba RKey 0x9=
0042602 VAddr 0x002b27feabe000
>> 11928: Remote address: LID 0000, QPN 000000, PSN 0x392fe6, RKey 0xf8=
042605 VAddr 0x002b9d5c93b000
>
>
> you can see the lid and qp numbers are zero, something is broken... w=
hen you use the rdma-cm,
> the address to be provided to the utility should be on an IPoIB subne=
t, is that what you're doing?
  The address may not have to be IPoIB interface, any interface which
can find the other side will be OK.
>
> Basically, I would suggest that you first use rping(1) provided by li=
brdmacm-utils to make
> sure things are working well in your configuration and then move to t=
he perftest utils.
>
> Or.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
