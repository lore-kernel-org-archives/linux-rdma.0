From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Problems trying to bridge/route RoCE
Date: Fri, 11 Nov 2016 13:45:06 -0700
Message-ID: <CAANLjFpeccfWtWO+imezO0Nr=xwOpkS9=e9ggxmEYYS8GePi6w@mail.gmail.com>
References: <CAANLjFqXH+BbsGmH5=DQd-Btsd8kCsSWTNDKCAc89tuigCdbeg@mail.gmail.com>
 <CAG53R5VFmZsb1TzFbmLAGD=N_m_Kt8vk3fCKigS3CA6ACbq8fA@mail.gmail.com>
 <CAANLjFoqDxnPgQiJT6FBMFYLw+iGyN-2yDYJfSRnEi04AR_0Yg@mail.gmail.com>
 <CAANLjFq7s88B1_Zza8GGjAcjK+=mBZ6rR20wSPberpm2LNKCPw@mail.gmail.com> <45EBC19B-6779-4AA6-BEC6-A61103A2C501@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <45EBC19B-6779-4AA6-BEC6-A61103A2C501-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

How do you add GRH for iSER? Does it happen automatically? I thought
that is what default_roce_mode would do. What am I missing here?

My testbed had to be torn down today, so I've got to set it up again
on different hardware. So I won't be able to really test things until
next week, until then I'll try to understand it as much as I can.

Thank you,
Robert LeBlanc
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Fri, Nov 11, 2016 at 1:34 AM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> On Nov 11, 2016, at 12:33 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>
> I found a ConnectX-3 (non-pro) and wired it up. So in bridge mode, it
> seems like I can get ib_read_bw to work (still with a warm-up error
> message), but as router, I'm still having trouble.
>
> 192.168.21.17 ----- Linux bridge ------ 192.168.21.18
>
> # ib_read_bw -d mlx5_0 -F -a 192.168.21.17
>
> Hi Robert,
>
> You should provide the gid index parameter which adds GRH to the packet in
> order to work with RoCE.
>
> In the perftest suite it's -x parameter.
>
> If you are trying to pass traffic between different subnets, then you need
> to run routable roce traffic and thus using RoCE v2 gid index.
>
> Also, if you are using rdma-cm, you need to configure the rdma-cm default
> gid type to v2 as well using configfs.
>
> ---------------------------------------------------------------------------------------
> Device not recognized to implement inline feature. Disabling it
> ------I
> ---------------------------------------------------------------------------------
>
>                    RDMA_Read BW Test
> Dual-port       : OFF          Device         : mlx5_0
> Number of qps   : 1            Transport type : IB
> Connection type : RC           Using SRQ      : OFF
> TX depth        : 128
> CQ Moderation   : 100
> Mtu             : 1024[B]
> Link type       : Ethernet
> Gid index       : 0
> Outstand reads  : 16
> rdma_cm QPs     : OFF
> Data ex. method : Ethernet
> ---------------------------------------------------------------------------------------
> local address: LID 0000 QPN 0x0135 PSN 0x12f108 OUT 0x10 RKey
> 0x009f79 VAddr 0x007f1c82d1f000
> GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:21:18
> remote address: LID 0000 QPN 0x0175 PSN 0x37982e OUT 0x10 RKey
> 0x00eac9 VAddr 0x007f54c1405000
> GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:21:17
> ---------------------------------------------------------------------------------------
> #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]
> MsgRate[Mpps]
> Conflicting CPU frequency values detected: 3698.669000 != 3102.661000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.86 differs from nominal 3698.67
> MHz
> 2          1000             0.65               0.65               0.341088
> Conflicting CPU frequency values detected: 3699.310000 != 1199.920000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3500.01 differs from nominal 3699.31
> MHz
> 4          1000             0.10               0.10               0.025750
> Conflicting CPU frequency values detected: 3681.579000 != 1199.920000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.99 differs from nominal 3681.58
> MHz
> 8          1000             2.77               2.77               0.363689
> Conflicting CPU frequency values detected: 3602.325000 != 3265.655000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.99 differs from nominal 3602.32
> MHz
> 16         1000             5.37               5.36               0.351569
> Conflicting CPU frequency values detected: 3600.830000 != 3265.655000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.97 differs from nominal 3600.83
> MHz
> 32         1000             11.30              11.29              0.370062
> Conflicting CPU frequency values detected: 3599.761000 != 3265.655000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3500.01 differs from nominal 3599.76
> MHz
> 64         1000             22.39              22.28              0.365108
> Conflicting CPU frequency values detected: 3599.975000 != 3265.655000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3500.01 differs from nominal 3599.97
> MHz
> 128        1000             45.09              45.08              0.369316
> Conflicting CPU frequency values detected: 3599.761000 != 3265.655000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.99 differs from nominal 3599.76
> MHz
> 256        1000             89.55              89.54              0.366765
> Conflicting CPU frequency values detected: 3599.761000 != 2280.212000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3500 differs from nominal 3599.76 MHz
> 512        1000             179.65             179.64             0.367907
> Conflicting CPU frequency values detected: 3599.761000 != 1200.347000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.99 differs from nominal 3599.76
> MHz
> 1024       1000             361.00             360.98             0.369639
> Conflicting CPU frequency values detected: 3601.043000 != 1751.495000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3500.01 differs from nominal 3601.04
> MHz
> 2048       1000             492.15             491.42             0.251606
> Conflicting CPU frequency values detected: 3698.028000 != 3601.470000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3500.01 differs from nominal 3698.03
> MHz
> 4096       1000             617.10             615.00             0.157440
> Conflicting CPU frequency values detected: 3684.356000 != 3600.189000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3500 differs from nominal 3684.36 MHz
> 8192       1000             679.31             679.30             0.086951
> Conflicting CPU frequency values detected: 3646.759000 != 1877.532000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.98 differs from nominal 3646.76
> MHz
> 16384      1000             722.86             722.85             0.046262
> Conflicting CPU frequency values detected: 3599.975000 != 2271.881000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.99 differs from nominal 3599.97
> MHz
> 32768      1000             742.08             742.08             0.023746
> Conflicting CPU frequency values detected: 3602.966000 != 1933.929000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 3499.97 differs from nominal 3602.97
> MHz
> 65536      1000             763.25             762.52             0.012200
> mlx5: prv-0-18-roberttest.betterservers.com: got completion with error:
> 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000 00000000
> 00000000 00008813 10000135 4680fcd2
> Problems with warm up
>
>
> === Router config ===
> 192.168.21.17 ------ 192.168.21.11 (Linux router) 192.168.22.11 ------
> 192.168.21.18
>
> #192.168.22.18
> # ping 192.168.21.17
> PING 192.168.21.17 (192.168.21.17) 56(84) bytes of data.
> 64 bytes from 192.168.21.17: icmp_seq=1 ttl=63 time=0.191 ms
> ^C
> --- 192.168.21.17 ping statistics ---
> 1 packets transmitted, 1 received, 0% packet loss, time 0ms
> rtt min/avg/max/mdev = 0.191/0.191/0.191/0.000 ms
>
> #192.168.21.17
> # route -n | grep 168
> 192.168.21.0    0.0.0.0         255.255.255.0   U     0      0        0 eth2
> 192.168.22.0    192.168.21.11   255.255.255.0   UG    0      0        0 eth2
>
> #192.168.22.18
> # route -n | grep 168
> 192.168.21.0    192.168.22.11   255.255.255.0   UG    0      0        0 eth2
> 192.168.22.0    0.0.0.0         255.255.255.0   U     0      0        0 eth2
>
> #192.168.22.18
> # ib_read_bw -d mlx5_0 -F -a 192.168.21.17
> ---------------------------------------------------------------------------------------
> Device not recognized to implement inline feature. Disabling it
> ---------------------------------------------------------------------------------------
>                    RDMA_Read BW Test
> Dual-port       : OFF          Device         : mlx5_0
> Number of qps   : 1            Transport type : IB
> Connection type : RC           Using SRQ      : OFF
> TX depth        : 128
> CQ Moderation   : 100
> Mtu             : 1024[B]
> Link type       : Ethernet
> Gid index       : 0
> Outstand reads  : 16
> rdma_cm QPs     : OFF
> Data ex. method : Ethernet
> ---------------------------------------------------------------------------------------
> local address: LID 0000 QPN 0x013a PSN 0x676912 OUT 0x10 RKey
> 0x00dfd3 VAddr 0x007fe67aee8000
> GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:22:18
> remote address: LID 0000 QPN 0x017a PSN 0x4256ce OUT 0x10 RKey
> 0x012985 VAddr 0x007f59de5bf000
> GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:21:17
> ---------------------------------------------------------------------------------------
> #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]
> MsgRate[Mpps]
> Problems with warm up
>
>
> #192.168.21.17
> # cat /sys/kernel/config/rdma_cm/mlx5_0/ports/1/default_roce_mode
> RoCE v2
>
> #192.168.22.18
> # cat /sys/kernel/config/rdma_cm/mlx5_0/ports/1/default_roce_mode
> RoCE v2
>
> With routing, I'm not seeing any RoCE traffic with tcpdump on the
> interfaces. With bridge mode, I do see the RoCE traffic, but it looks
> like RoCE v1 traffic.
>
> [snip]
> 14:55:06.010682 0c:c4:7a:89:f7:06 > 0c:c4:7a:89:f6:f6, ethertype
> Unknown (0x8915), length 78:
>        0x0000:  6010 0000 0018 1b40 0000 0000 0000 0000  `......@........
>        0x0010:  0000 ffff c0a8 1511 0000 0000 0000 0000  ................
>        0x0020:  0000 ffff c0a8 1512 1060 ffff 0000 013e  .........`.....>
>        0x0030:  00e5 7b6c 0000 0411 0000 0000 60bb 6a87  ..{l........`.j.
> [snip]
>
> I can get iSER to kind of work...
>
> In bridge mode and running fio on the iSER target, I'm getting
> messages in dmesg:
> [Thu Nov 10 15:14:17 2016] mlx5_0:dump_cqe:263:(pid 0): dump error cqe
> [Thu Nov 10 15:14:17 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:14:17 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:14:17 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:14:17 2016] 00000000 08007806 2500014f a7a758d2
> [Thu Nov 10 15:14:17 2016] iser: iser_err_comp: memreg failure: memory
> management operation error (6) vend_err 78
> [Thu Nov 10 15:14:17 2016]  connection82:0: detected conn error (1011)
> [Thu Nov 10 15:14:24 2016] mlx5_0:dump_cqe:263:(pid 0): dump error cqe
> [Thu Nov 10 15:14:24 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:14:24 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:14:24 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:14:24 2016] 00000000 08007806 25000150 3471eed2
> ...
>
> In routed mode I also get the same messages, but the device goes
> offline and crashes fio
>
> [Thu Nov 10 15:09:13 2016] mlx5_0:dump_cqe:263:(pid 0): dump error cqe
> [Thu Nov 10 15:09:13 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:09:13 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:09:13 2016] 00000000 00000000 00000000 00000000
> [Thu Nov 10 15:09:13 2016] 00000000 08007806 25000149 5a524ad2
> [Thu Nov 10 15:09:13 2016] iser: iser_err_comp: memreg failure: memory
> management operation error (6) vend_err 78
> [Thu Nov 10 15:09:13 2016]  connection80:0: detected conn error (1011)
> [Thu Nov 10 15:09:18 2016]  session80: session recovery timed out after 5
> secs
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: rejecting I/O to offline device
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: [sdab] killing request
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: rejecting I/O to offline device
> [Thu Nov 10 15:09:18 2016] scsi_io_completion: 23 callbacks suppressed
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: [sdab] FAILED Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: [sdab] CDB: Read(10) 28 00 09
> 9f 97 18 00 01 48 00
> [Thu Nov 10 15:09:18 2016] blk_update_request: 23 callbacks suppressed
> [Thu Nov 10 15:09:18 2016] blk_update_request: I/O error, dev sdab,
> sector 161453848
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: [sdab] killing request
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: rejecting I/O to offline device
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: [sdab] FAILED Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: [sdab] CDB: Read(10) 28 00 07
> bf 98 60 00 00 a8 00
> [Thu Nov 10 15:09:18 2016] blk_update_request: I/O error, dev sdab,
> sector 129996896
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: [sdab] killing request
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: rejecting I/O to offline device
> [Thu Nov 10 15:09:18 2016] sd 13:0:0:0: [sdab] killing request
> ...
>
> This is all using ConnectX-4 LX cards on the target and initiator and
> the 3.8.5 kernel.
>
> Any ideas of what may be causing these issues?
>
> Thank you,
> Robert LeBlanc
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Thu, Nov 3, 2016 at 11:38 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
> wrote:
>
> That box has a build-in ConnectX-3 card that we aren't using in this
>
> test so the mlx4 modules are loaded. I unloaded mlx4_ib, no luck. I
>
> also tried to unload the mlx5_ib driver and it also unloaded mlx5_core
>
> and my interfaces were gone. It seems like I can't only unload
>
> mlx5_ib.
>
>
> With mlx4_ib unloaded I still can't rping or ib_read_bw (connects, but
>
> get messages like:
>
> ethernet_read_keys: Couldn't read remote address
>
> Unable to read to socket/rdam_cm
>
> Failed to exchange data between server and clients
>
> Problems with warm up) same as before.
>
> ----------------
>
> Robert LeBlanc
>
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
>
> On Thu, Nov 3, 2016 at 11:16 AM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
>
> Hi Robert,
>
>
> Can you please unload the mlx4_ib module in the bridge/router box and
>
> give it a quick try?
>
>
> Parav
>
>
> On Thu, Nov 3, 2016 at 10:32 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
> wrote:
>
> I'm trying to do some testing of RoCE v2 and so I put a LInux box
>
> between two RoCE  machines. I think the ConnectX-4 Lx card in the
>
> bridge/router is intercepting the RoCE traffic and so it is not being
>
> bridged/routed. I don't see any traffic using tcpdump which seems to
>
> confirm this. I thought I could change the UDP port that the card is
>
> looking for RoCE traffic to something not in use [0], but rr_proto is
>
> not a valid parameter for the inbox mlx5_core module on 4.8.5. I can
>
> ping across the bridge/router so I know that it is setup correctly,
>
> just RDMA is not working.
>
>
> Any ideas on how to pass RoCE traffic like normal traffic? The reason
>
> we are using a Linux box is that we can use netem to understand how
>
> RoCE behaves in different situations.
>
>
> [0] https://community.mellanox.com/docs/DOC-1444
>
>
> Thank you
>
> ----------------
>
> Robert LeBlanc
>
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
> --
>
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
