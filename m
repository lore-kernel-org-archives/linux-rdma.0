From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Tue, 7 Jun 2016 15:02:26 +0300
Message-ID: <5756B7D2.5040009@mellanox.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 6/7/2016 1:36 AM, Robert LeBlanc wrote:
> I'm trying to understand why our Connect-IB card is not performing as
> well as our ConnectX-3 card. There are 3 ports between the two cards
> and 12 paths to the iSER target which is a RAM disk.

<snip>

>
> When I run fio against each path individually, I get:

What is the scenario (bs, numjobs, iodepth) for each run ?
Which target do you use ? backing store ?

>
> disk;target IP;bandwidth,IOPs,Execution time
> sdn;10.218.128.17;5053682;1263420;16599
> sde;10.218.202.17;5032158;1258039;16670
> sdh;10.218.203.17;4993516;1248379;16799
> sdk;10.218.204.17;5081848;1270462;16507
> sdc;10.219.128.17;3750942;937735;22364
> sdf;10.219.202.17;3746921;936730;22388
> sdi;10.219.203.17;3873929;968482;21654
> sdl;10.219.204.17;3841465;960366;21837
> sdd;10.220.128.17;3760358;940089;22308
> sdg;10.220.202.17;3866252;966563;21697
> sdj;10.220.203.17;3757495;939373;22325
> sdm;10.220.204.17;4064051;1016012;20641
>
> However, running ib_send_bw, I get:
>
> # ib_send_bw -d mlx4_0 -i 1 10.218.128.17 -F --report_gbits
> ---------------------------------------------------------------------------------------
>                     Send BW Test
> Dual-port       : OFF          Device         : mlx4_0
> Number of qps   : 1            Transport type : IB
> Connection type : RC           Using SRQ      : OFF
> TX depth        : 128
> CQ Moderation   : 100
> Mtu             : 2048[B]
> Link type       : IB
> Max inline data : 0[B]
> rdma_cm QPs     : OFF
> Data ex. method : Ethernet
> ---------------------------------------------------------------------------------------
> local address: LID 0x3f QPN 0x02b5 PSN 0x87274e
> remote address: LID 0x22 QPN 0x0213 PSN 0xaf9232
> ---------------------------------------------------------------------------------------
> #bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
> Conflicting CPU frequency values detected: 3219.835000 != 3063.531000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 2599.95 differs from nominal 3219.84 MHz
> 65536      1000             50.57              50.57              0.096461
> ---------------------------------------------------------------------------------------
> # ib_send_bw -d mlx5_0 -i 1 10.219.128.17 -F --report_gbits
> ---------------------------------------------------------------------------------------
>                     Send BW Test
> Dual-port       : OFF          Device         : mlx5_0
> Number of qps   : 1            Transport type : IB
> Connection type : RC           Using SRQ      : OFF
> TX depth        : 128
> CQ Moderation   : 100
> Mtu             : 4096[B]
> Link type       : IB
> Max inline data : 0[B]
> rdma_cm QPs     : OFF
> Data ex. method : Ethernet
> ---------------------------------------------------------------------------------------
> local address: LID 0x12 QPN 0x003e PSN 0x75f1a0
> remote address: LID 0x1d QPN 0x003e PSN 0x7f7f71
> ---------------------------------------------------------------------------------------
> #bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
> Conflicting CPU frequency values detected: 3399.906000 != 2747.773000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 2599.98 differs from nominal 3399.91 MHz
> 65536      1000             52.12              52.12              0.099414
> ---------------------------------------------------------------------------------------
> # ib_send_bw -d mlx5_0 -i 2 10.220.128.17 -F --report_gbits
> ---------------------------------------------------------------------------------------
>                     Send BW Test
> Dual-port       : OFF          Device         : mlx5_0
> Number of qps   : 1            Transport type : IB
> Connection type : RC           Using SRQ      : OFF
> TX depth        : 128
> CQ Moderation   : 100
> Mtu             : 4096[B]
> Link type       : IB
> Max inline data : 0[B]
> rdma_cm QPs     : OFF
> Data ex. method : Ethernet
> ---------------------------------------------------------------------------------------
> local address: LID 0x0f QPN 0x0041 PSN 0xb7203d
> remote address: LID 0x1c QPN 0x0041 PSN 0xf8b80a
> ---------------------------------------------------------------------------------------
> #bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
> Conflicting CPU frequency values detected: 3327.796000 != 1771.046000
> Test integrity may be harmed !
> Warning: measured timestamp frequency 2599.97 differs from nominal 3327.8 MHz
> 65536      1000             52.14              52.14              0.099441
> ---------------------------------------------------------------------------------------
>
> Here I see that the ConnectX-3 cards with iSER is matching the
> performance of the ib_send_bw. However, the Connect-IB performs better
> than the mlx4 with ib_send_bw, but performs much worse with iSER.
>
> This is running the 4.4.4 kernel. Is there some ideas of what I can do
> to get the iSER performance out of the Connect-IB cards?

did you see this regression in different kernel ?

>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
