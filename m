From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: more partition questions
Date: Wed, 21 Jul 2010 16:45:02 -0400
Message-ID: <AANLkTikDh5Em28cj9WSy2nNC-vrcZe4MwFHOYt9OmeuU@mail.gmail.com>
References: <4C448DCD.80809@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C448DCD.80809-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Tom,

On 7/19/10, Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org> wrote:
> I'm trying to set up partitions in a little test environment, and I'm
> having trouble.
>
> I have opensm running on a machine attached to the fabric, and sminfo on
> the other machines confirm that this is indeed the master SM. Here's my
> /etc/opensm/partitions.conf:
>
> Default=0xffff , ipoib : ALL, SELF=full ;
> PartitionBlue=0x8004, ipoib : 0x0002c9030009cb3f=full,
> 0x0002c90200252841=full, 0x0002c90200243471=full ;
> PartitionRed=0x8005, ipoib : 0x0002c90200252841=full,
> 0x0002c90200243591=full, 0x0002c9030009cb2b=full ;

You don't really need the 0x8000 bit on in the pkeys but I don't think
it does any harm.

> But when I go to the machine with port GUID 0x0002c90200243471, it
> doesn't appear that it's getting the pkey I wanted:
>
> [root@stagnate ~]# ibstat
> CA 'mthca0'
>          CA type: MT23108
>          Number of ports: 2
>          Firmware version: 3.3.5
>          Hardware version: a1
>          Node GUID: 0x0002c90200243470
>          System image GUID: 0x0002c90200243473
>          Port 1:
>                  State: Active
>                  Physical state: LinkUp
>                  Rate: 10
>                  Base lid: 10
>                  LMC: 0
>                  SM lid: 4
>                  Capability mask: 0x02510a68
>                  Port GUID: 0x0002c90200243471
>          Port 2:
>                  State: Down
>                  Physical state: Polling
>                  Rate: 2
>                  Base lid: 0
>                  LMC: 0
>                  SM lid: 0
>                  Capability mask: 0x02510a68
>                  Port GUID: 0x0002c90200243472
>
> [root@stagnate ~]# cat /sys/class/net/ib0/pkey
> 0xffff

What does:

smpquery pkeys 10 1

say ? Do you see the other pkey(s) on that port ?

The pkey you are seeing is the only one for ib0 interface.

If you want to have IPoIB interfaces on the other partitions too, you
need to set this up by creating a child interface on those nodes; you
had asked about that in a previous email
(http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04728.html).

-- Hal

>
> I'm trying to run one ipoib subnet in each partition, and then
> eventually the goal is to have a different server that has 2 child
> interfaces, one on each subnet. But it doesn't appear that my partition
> configuration is even correct. Is there a syntax error, or something
> else I am missing?
>
> Thanks,
>
> Tom
>
>
>
> --
> Tom Ammon
> Network Engineer
> Office: 801.587.0976
> Mobile: 801.674.9273
>
> Center for High Performance Computing
> University of Utah
> http://www.chpc.utah.edu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
