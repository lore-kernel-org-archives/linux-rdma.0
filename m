From: Jonathan Perkins <perkinjo-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Re: Issue with RDMA_CM on systems with multiple IB HCA's.
Date: Thu, 22 Jul 2010 12:41:08 -0400
Message-ID: <AANLkTinco6znrHkoE9vL1n7KrrZ68zPExPUPQeDHD64i@mail.gmail.com>
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

On Thu, Jul 22, 2010 at 3:15 AM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wro=
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
>
> Basically, I would suggest that you first use rping(1) provided by li=
brdmacm-utils to make
> sure things are working well in your configuration and then move to t=
he perftest utils.

Thanks for the response Or.  I'm posting some information below.

Here is the output I get when running rping...

[perkinjo@amd5 ~]$ rping -v -s -a 172.16.1.5

[perkinjo@amd6 ~]$ rping -v -c -a 172.16.1.5
cq completion failed status 5
cma event RDMA_CM_EVENT_REJECTED, error 8
wait for CONNECTED state 10
connect error -1
[perkinjo@amd6 ~]$ ping 172.16.1.5
PING 172.16.1.5 (172.16.1.5) 56(84) bytes of data.
64 bytes from 172.16.1.5: icmp_seq=3D1 ttl=3D64 time=3D3.45 ms
64 bytes from 172.16.1.5: icmp_seq=3D2 ttl=3D64 time=3D1.00 ms

We are able to ping the addresses but you can see that rping results
in a failure.

We have two interfaces exposed on each machine both on different
subnets (172.16.1.0/24 and 172.16.2.0/24).  We're using ofed-1.5.1 on
these systems.  Any idea of what could be going on?

--=20
Jonathan Perkins
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
