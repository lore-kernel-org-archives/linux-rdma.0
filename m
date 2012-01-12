From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB/iSER major problems with Linux 3.0 and Solaris targets
Date: Thu, 12 Jan 2012 18:47:07 +0200
Message-ID: <4F0F0E8B.8090604@mellanox.com>
References: <4EEA0577.5030304@profitbricks.com> <CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com> <CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com> <4F0D987B.4060206@profitbricks.com> <CAJZOPZJOT4Mdyzg+Q06HevikqdA7Sy1KqD1V6Q5LjsiuFsYv5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJOT4Mdyzg+Q06HevikqdA7Sy1KqD1V6Q5LjsiuFsYv5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/11/2012 10:09 PM, Or Gerlitz wrote:
> [...] I'll give 3.0.15 a try tomorrow, however, the error you're 
> getting "iser_drain_tx_cq:tx id ffff88402391f898 status 4 vend_err 57" 
> means that iser got local protection error (=4) on the first buffer we 
> used with IB (the connection handshake buffers belong to the IB CM, 
> not to the ULP) which is the login request. Sounds like something is 
> broken maybe dma mapping wise, for this reason I think its likely that 
> the problem might not hit me on my testbed [...]

okay, I've tried 3.0.15 with your .config slightly changed for my local 
SATA disk, will send you copy of my .config , and, iser works for me... 
so you need to try a bit harder and send me your logs... I'm using 
iscsi-initiator-utils-6.2.0.872-21.el6.x86_64

Or.

My board ID is MT_0D81120009 which is a bit different but the HCA is 
ConnectX b0 as yours, I'm using non GA firmware, but I find it hard to 
believe this is the reason for your failure

> # ibstat
> CA 'mlx4_0'
>         CA type: MT26428
>         Number of ports: 2
>         Firmware version: 2.9.4270
>         Hardware version: b0
>         Node GUID: 0x0002c9030010c6e8
>         System image GUID: 0x0002c9030010c6eb
>         Port 1:
>                 State: Active
>                 Physical state: LinkUp
>                 Rate: 40
>                 Base lid: 10
>                 LMC: 0
>                 SM lid: 6
>                 Capability mask: 0x02510868
>                 Port GUID: 0x0002c9030010c6e9


> [  134.869036] iscsi: registered transport (tcp)
> [  134.987553] iscsi: registered transport (iser)
> [  136.075198] iser: iser_connect:connecting to: 192.168.20.19, port 
> 0xbc0c
> [  136.100162] iser: iser_cma_handler:event 0 status 0 conn 
> ffff88020eb7ba80 id ffff8802252aec00
> [  136.111158] iser: iser_cma_handler:event 2 status 0 conn 
> ffff88020eb7ba80 id ffff8802252aec00
> [  136.130923] iser: iser_create_ib_conn_res:setting conn 
> ffff88020eb7ba80 cma_id ffff8802252aec00: fmr_pool ffff880224c17880 qp 
> ffff8802154a4600
> [  136.150646] iser: iser_cma_handler:event 9 status 0 conn 
> ffff88020eb7ba80 id ffff8802252aec00
> [  136.332263] iser: iscsi_iser_ep_poll:ib conn ffff88020eb7ba80 rc = 1
> [  136.338710] scsi3 : iSCSI Initiator over iSER, v.0.1
> [  136.346240] iser: iscsi_iser_conn_bind:binding iscsi/iser conn 
> ffff880225294ab8 ffff880225294cc8 to ib_conn ffff88020eb7ba80
> [  136.609277] scsi 3:0:0:0: RAID              Mellanox 
> vsa              1    PQ: 0 ANSI: 5
> [  136.617604] scsi 3:0:0:0: Attached scsi generic sg3 type 12
> [  136.623454] scsi 3:0:0:1: Direct-Access     Mellanox 
> VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
> [  136.631820] sd 3:0:0:1: Attached scsi generic sg4 type 0
> [  136.631848] sd 3:0:0:1: [sdc] 2147483648 512-byte logical blocks: 
> (1.09 TB/1.00 TiB)
> [  136.645040] sd 3:0:0:1: [sdc] Write Protect is off
> [  136.649880] sd 3:0:0:1: [sdc] Mode Sense: 49 00 00 08
> [  136.649975] sd 3:0:0:1: [sdc] Write cache: enabled, read cache: 
> enabled, doesn't support DPO or FUA
> [  136.659680]  sdc: unknown partition table
> [  136.664071] sd 3:0:0:1: [sdc] Attached SCSI disk
> [  211.020096] sd 3:0:0:1: [sdc] Synchronizing SCSI cache
> [  211.526075] iser: iscsi_iser_ep_disconnect:ib conn ffff88020eb7ba80 
> state 2
> [  211.534048] iser: iser_cma_handler:event 10 status 0 conn 
> ffff88020eb7ba80 id ffff8802252aec00
> [  211.542750] iser: iser_free_ib_conn_res:freeing conn 
> ffff88020eb7ba80 cma_id ffff8802252aec00 fmr pool ffff880224c17880 qp 
> ffff8802154a4600
> [  211.556053] iser: iser_device_try_release:device ffff880225b30480 
> refcount 0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
