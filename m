From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: NVMe over RDMA latency
Date: Wed, 13 Jul 2016 11:25:32 -0700
Message-ID: <1468434332.1869.8.camel@ssi>
References: <1467921342.24395.12.camel@ssi> <57860EBA.5010103@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57860EBA.5010103-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-07-13 at 12:49 +0300, Sagi Grimberg wrote:
> > Hi list,
> 
> Hey Ming,
> 
> > I'm trying to understand the NVMe over RDMA latency.
> >
> > Test hardware:
> > A real NVMe PCI drive on target
> > Host and target back-to-back connected by Mellanox ConnectX-3
> >
> > [global]
> > ioengine=libaio
> > direct=1
> > runtime=10
> > time_based
> > norandommap
> > group_reporting
> >
> > [job1]
> > filename=/dev/nvme0n1
> > rw=randread
> > bs=4k
> >
> >
> > fio latency data on host side(test nvmeof device)
> >      slat (usec): min=2, max=213, avg= 6.34, stdev= 3.47
> >      clat (usec): min=1, max=2470, avg=39.56, stdev=13.04
> >       lat (usec): min=30, max=2476, avg=46.14, stdev=15.50
> >
> > fio latency data on target side(test NVMe pci device locally)
> >      slat (usec): min=1, max=36, avg= 1.92, stdev= 0.42
> >      clat (usec): min=1, max=68, avg=20.35, stdev= 1.11
> >       lat (usec): min=19, max=101, avg=22.35, stdev= 1.21
> >
> > So I picked up this sample from blktrace which seems matches the fio avg latency data.
> >
> > Host(/dev/nvme0n1)
> > 259,0    0       86     0.015768739  3241  Q   R 1272199648 + 8 [fio]
> > 259,0    0       87     0.015769674  3241  G   R 1272199648 + 8 [fio]
> > 259,0    0       88     0.015771628  3241  U   N [fio] 1
> > 259,0    0       89     0.015771901  3241  I  RS 1272199648 + 8 (    2227) [fio]
> > 259,0    0       90     0.015772863  3241  D  RS 1272199648 + 8 (     962) [fio]
> > 259,0    1       85     0.015819257     0  C  RS 1272199648 + 8 (   46394) [0]
> >
> > Target(/dev/nvme0n1)
> > 259,0    0      141     0.015675637  2197  Q   R 1272199648 + 8 [kworker/u17:0]
> > 259,0    0      142     0.015676033  2197  G   R 1272199648 + 8 [kworker/u17:0]
> > 259,0    0      143     0.015676915  2197  D  RS 1272199648 + 8 (15676915) [kworker/u17:0]
> > 259,0    0      144     0.015694992     0  C  RS 1272199648 + 8 (   18077) [0]
> >
> > So host completed IO in about 50usec and target completed IO in about 20usec.
> > Does that mean the 30usec delta comes from RDMA write(host read means target RDMA write)?
> 
> 
> Couple of things that come to mind:
> 
> 0. Are you using iodepth=1 correct?

I didn't set it. It's 1 by default.
Now I set it.

root@host:~# cat t.job 
[global]
ioengine=libaio
direct=1
runtime=20
time_based
norandommap
group_reporting

[job1]
filename=/dev/nvme0n1
rw=randread
bs=4k
iodepth=1
numjobs=1


> 
> 1. I imagine you are not polling in the host but rather interrupt
>     driven correct? thats a latency source.

It's polling.

root@host:~# cat /sys/block/nvme0n1/queue/io_poll 
1

> 
> 2. the target code is polling if the block device supports it. can you
>     confirm that is indeed the case?

Yes.

> 
> 3. mlx4 has a strong fencing policy for memory registration, which we
>     always do. thats a latency source. can you try with
>     register_always=0?

root@host:~# cat /sys/module/nvme_rdma/parameters/register_always 
N


> 
> 4. IRQ affinity assignments. if the sqe is submitted on cpu core X and
>     the completion comes to cpu core Y, we will consume some latency
>     with the context-switch of waiking up fio on cpu core X. Is this
>     a possible case?

Only 1 CPU online on both host and target machine.

root@host:~# lscpu 
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0
Off-line CPU(s) list:  1-7

root@target:~# lscpu 
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0
Off-line CPU(s) list:  1-7


> 
> 5. What happens if you test against a null_blk (which has a latency of
>     < 1us)? back when I ran some tryouts I saw ~10-11us added latency
>     from the fabric under similar conditions.

With null_blk on target, latency about 12us.

root@host:~# fio t.job 
job1: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.9-3-g2078c
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [305.1MB/0KB/0KB /s] [78.4K/0/0 iops] [eta 00m:00s]
job1: (groupid=0, jobs=1): err= 0: pid=3067: Wed Jul 13 11:20:19 2016
  read : io=6096.9MB, bw=312142KB/s, iops=78035, runt= 20001msec
    slat (usec): min=1, max=207, avg= 2.01, stdev= 0.34
    clat (usec): min=0, max=8020, avg= 9.99, stdev= 9.06
     lat (usec): min=10, max=8022, avg=12.10, stdev= 9.07


With real NVMe device on target, host see latency about 33us.

root@host:~# fio t.job 
job1: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.9-3-g2078c
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [113.1MB/0KB/0KB /s] [28.1K/0/0 iops] [eta 00m:00s]
job1: (groupid=0, jobs=1): err= 0: pid=3139: Wed Jul 13 11:22:15 2016
  read : io=2259.5MB, bw=115680KB/s, iops=28920, runt= 20001msec
    slat (usec): min=1, max=195, avg= 2.62, stdev= 1.24
    clat (usec): min=0, max=7962, avg=30.97, stdev=14.50
     lat (usec): min=27, max=7968, avg=33.70, stdev=14.69

And tested NVMe device locally on target, about 23us.
So nvmeof added only about ~10us.

That's nice!

root@target:~# fio t.job 
job1: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.8-26-g603e
Starting 1 process
Jobs: 1 (f=1): [r(1)] [100.0% done] [161.2MB/0KB/0KB /s] [41.3K/0/0 iops] [eta 00m:00s]
job1: (groupid=0, jobs=1): err= 0: pid=2725: Wed Jul 13 11:23:46 2016
  read : io=1605.3MB, bw=164380KB/s, iops=41095, runt= 10000msec
    slat (usec): min=1, max=60, avg= 1.88, stdev= 0.63
    clat (usec): min=1, max=144, avg=21.61, stdev= 8.96
     lat (usec): min=19, max=162, avg=23.59, stdev= 9.00



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
