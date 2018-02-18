From: Bairen Yi <yibairen1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Loopback with RXE?
Date: Sun, 18 Feb 2018 18:47:07 +0800
Message-ID: <77260D56-AFD3-4B4B-B80D-8103DE752009@gmail.com>
References: <2145E340-3297-4ED2-BEC9-09E4CD582D24@rbird.tech>
 <20180214192559.GC8800@yuvallap>
 <F17D72E0-CBBE-4315-A576-91EA43EAB388@rbird.tech>
 <37E490E3-75A6-4C2B-B82D-6ED11031EA09@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <37E490E3-75A6-4C2B-B82D-6ED11031EA09-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi folks,

Just a quick update, upgrading to kernel v4.14 solves my issue.

It looks like rdma-core 16 in Debian stretch-backports does not work =
with kernel v4.9 in Debian stretch.

And yep, matching is important :P

Best,
Bairen

> On 18 Feb 2018, at 05:23, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
>>=20
>> On Feb 17, 2018, at 3:03 PM, Yi Bairen <byron-DzDj5FMp9MpyDzI6CaY1VQ@public.gmane.org> wrote:
>>=20
>> Hi,
>>=20
>>> On 15 Feb 2018, at 03:25, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =
wrote:
>>>=20
>>> On Wed, Feb 14, 2018 at 05:13:07PM +0000, Yi Bairen wrote:
>>>> Hi folks,
>>>>=20
>>>> Seems I can=E2=80=99t get a Linux 4.9 (Debian 9.3) VM working with =
single box SoftRoCE loopback. I installed rdma-core 16. The rdma_client =
& rdma_server in the same box seems working. However, when I use =
ib_write_bw in the same box, the QPs can=E2=80=99t be connected through =
the same rxe device.
>>>=20
>>> If the QPs connection is problematic then how come rdma_* is =
working?
>>=20
>> The rdma_client and rdma_server do work with `end 0`.=20
>>=20
>> The ib_write_bw seems to hang. If I kill the server side, the client =
does not respond. If I kill the client side, it shows the following log:
>>=20
>> $ ib_write_bw
> Did you try to specify a gid index with -x param? For example =
ib_write_bw -x 0.
>=20
> Without gid I would expect init2rtr to fail.. which doesn=E2=80=99t =
seem the case though ..
>>=20
>> ************************************
>> * Waiting for client to connect... *
>> ************************************
>> =
--------------------------------------------------------------------------=
-------------
>>                   RDMA_Write BW Test
>> Dual-port       : OFF        Device         : rxe0
>> Number of qps   : 1        Transport type : IB
>> Connection type : RC        Using SRQ      : OFF
>> CQ Moderation   : 100
>> Mtu             : 1024[B]
>> Link type       : Ethernet
>> GID index       : 1
>> Max inline data : 0[B]
>> rdma_cm QPs     : OFF
>> Data ex. method : Ethernet
>> =
--------------------------------------------------------------------------=
-------------
>> local address: LID 0000 QPN 0x0014 PSN 0x3787ca RKey 0x00052c VAddr =
0x007f3dd4c42000
>> GID: 00:00:00:00:00:00:00:00:00:00:255:255:159:65:13:34
>> remote address: LID 0000 QPN 0x0015 PSN 0x5c8ba9 RKey 0x000658 VAddr =
0x007f30e74b3000
>> GID: 00:00:00:00:00:00:00:00:00:00:255:255:159:65:13:34
>> =
--------------------------------------------------------------------------=
-------------
>> #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]   =
MsgRate[Mpps]
>> ethernet_read_keys: Couldn't read remote address
>> Unable to read to socket/rdam_cm
>> Failed to exchange data between server and clients
>>=20
>> #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]   =
MsgRate[Mpps]
>> ethernet_read_keys: Couldn't read remote address
>> Unable to read to socket/rdam_cm
>> Failed to exchange data between server and clients
>>=20
>> My RXE config:
>>=20
>> $ sudo rxe_cfg start
>> Name     Link  Driver      Speed  NMTU  IPv4_addr  RDEV  RMTU
>> docker0  no    bridge
>> eth0     yes   virtio_net                          rxe0  1024  (3)
>> eth1     yes   virtio_net                          rxe1  1024  (3)
>>=20
>> dmesg:
>>=20
>> [14441.336707] rdma_rxe: loaded
>> [14441.375108] Loading iSCSI transport class v2.0-870.
>> [14441.380930] rdma_rxe: set rxe0 active
>> [14441.381824] rdma_rxe: added rxe0 to eth0
>> [14441.389567] iscsi: registered transport (iser)
>> [14441.403595] RPC: Registered named UNIX socket transport module.
>> [14441.404618] RPC: Registered udp transport module.
>> [14441.405390] RPC: Registered tcp transport module.
>> [14441.406057] RPC: Registered tcp NFSv4.1 backchannel transport =
module.
>> [14441.415816] RPC: Registered rdma transport module.
>> [14441.416689] RPC: Registered rdma backchannel transport module.
>> [14441.419979] rdma_rxe: set rxe1 active
>> [14441.420657] rdma_rxe: added rxe1 to eth1
>> [14470.422836] detected loopback device
>> [14484.278022] rdma_rxe: qp#18 moved to error state
>>=20
>>>=20
>>>>=20
>>>> I=E2=80=99d like to know if rxe loopback is known to be broken, and =
how to fix it.
>>>>=20
>>>> Best,
>>>> Bairen Yi
>>=20
>> Bairen Yi
>>=20
>> =
N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=BF=BD=
=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=BF=BD)=
=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=EF=BF=BD=
=D9=9A=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=BF=BD=EF=BF=BD=
f=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=1E=EF=BF=
=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=
=EF=BF=BD=EF=BF=BD=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=
=BDm=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BDzZ+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=
=BD!=EF=BF=BDi

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
