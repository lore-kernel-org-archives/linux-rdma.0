From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Old SDR IB HBA
Date: Tue, 15 May 2012 22:27:14 +0300
Message-ID: <CAJZOPZL0MuNnjP8=CyQqL+GC7RDyMGTt_ng+iYbFDOpdrv3ZWA@mail.gmail.com>
References: <d004e56b0a274ba55134840a93060de4@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d004e56b0a274ba55134840a93060de4-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 15, 2012 at 10:16 PM, Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> w=
rote:

> Is it normal that kenrnel reports 8.5G speed on old SDR mellanox HBA?

yes, there used to be a bug that could cause that, what kernel
produced this output?

> c-2-1 1 # ibstatus
> Infiniband device 'mthca0' port 1 status:
> =A0 =A0 =A0 =A0default gid: =A0 =A0 fe80:0000:0000:0000:0002:c902:002=
3:05a1
> =A0 =A0 =A0 =A0base lid: =A0 =A0 =A0 =A00x2f
> =A0 =A0 =A0 =A0sm lid: =A0 =A0 =A0 =A0 =A00xf
> =A0 =A0 =A0 =A0state: =A0 =A0 =A0 =A0 =A0 4: ACTIVE
> =A0 =A0 =A0 =A0phys state: =A0 =A0 =A05: LinkUp
> =A0 =A0 =A0 =A0rate: =A0 =A0 =A0 =A0 =A0 =A08.5 Gb/sec (4X)
> =A0 =A0 =A0 =A0link_layer: =A0 =A0 =A0InfiniBand

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
