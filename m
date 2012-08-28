From: Gaetano Mendola <mendola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Writing RDMA applications on Linux
Date: Wed, 29 Aug 2012 00:23:35 +0200
Message-ID: <CAJycT5oNX5x32xnFg3eWqVyJEdFOT0R=psKB7PM+0Y7gZ-f+rg@mail.gmail.com>
References: <CAJycT5rf_SGPh2Gfg9C9aK2wm4uR6ZMsXeh1WD1gWGb-oqgnLg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8ACB1@ORSMSX101.amr.corp.intel.com>
	<CAJycT5rDA0E3q7uobZnQsDUQVpEn__UnuA61KkVrAyPFS+o9fg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8B686@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8B686-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm not sure if I have to say sorry for the noise or not but it seems
that the issue was just an NUMA issue!
My system is a 2 node NUMA system and the IB board is attached on NODE 0.
Not performing any cpu/mem affinity it seems the code runs on the
worst node, always!

Without affinity ( I did run this several time):

$ rstream -s 10.30.3.2
name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
64_lat    64      1       1m      122m        4.36s      0.23       2.18
4k_lat    4k      1       100k    781m        2.42s      2.70      12.12
64k_lat   64k     1       10k     1.2g        1.70s      6.17      84.92
1m_lat    1m      1       100     200m        0.26s      6.53    1284.81
64_bw     64      1m      1       122m        1.38s      0.74       0.69
4k_bw     4k      100k    1       781m        1.02s      6.44       5.09
64k_bw    64k     10k     1       1.2g        1.54s      6.82      76.93
1m_bw     1m      100     1       200m        0.25s      6.61    1268.28

Affinity on node 1 (the worst one):

$ numactl --membind=1 --cpunodebind=1 rstream -s 10.30.3.2
name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
64_lat    64      1       1m      122m        4.36s      0.23       2.18
4k_lat    4k      1       100k    781m        2.42s      2.70      12.11
64k_lat   64k     1       10k     1.2g        1.70s      6.18      84.90
1m_lat    1m      1       100     200m        0.26s      6.53    1284.71
64_bw     64      1m      1       122m        1.38s      0.74       0.69
4k_bw     4k      100k    1       781m        1.02s      6.44       5.09
64k_bw    64k     10k     1       1.2g        1.54s      6.82      76.91
1m_bw     1m      100     1       200m        0.25s      6.61    1269.56

Affinity on node 0:

$ numactl --membind=0 --cpunodebind=0 rstream -s 10.30.3.2
name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
64_lat    64      1       1m      122m        3.81s      0.27       1.90
4k_lat    4k      1       100k    781m        1.88s      3.49       9.39
64k_lat   64k     1       10k     1.2g        1.10s      9.56      54.82
1m_lat    1m      1       100     200m        0.15s     11.41     735.00
64_bw     64      1m      1       122m        0.92s      1.11       0.46
4k_bw     4k      100k    1       781m        0.59s     11.07       2.96
64k_bw    64k     10k     1       1.2g        0.89s     11.73      44.69
1m_bw     1m      100     1       200m        0.14s     11.70     716.98

Being an RDMA the most important affinity is the memory one.
And now doing the affinity even the custom test runs as expected:

$ numactl --membind=0 --cpunodebind=0 rstream -s 10.30.3.2 -S 6291456
name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
custom    6m      1k      1       11g         8.91s     11.29    4456.94

alias 1445.12 MB/sec using rstream

Now even my application reaches 1200 MB/sec that is not using rsocket (yet).
Is my OS to blame ?

What is strange is that ib_write_bw seems it's not affected by affinity,
doesn't matter on which node I do the affinity it still reports
1500MB/s. I had a
quick look at the code and it seems it doesn't perform any cpuaffinity
on his own.

May be rsocket has to do a memory affinity on the node with the IB
board attached on
before to allocate his own memory?

Gaetano


On Tue, Aug 28, 2012 at 8:42 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> $ ./examples/rstream -s 10.30.3.2 -S all
>> name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
>> 16k_lat   16k     1       10k     312m        0.52s      5.06      25.93
>> 24k_lat   24k     1       10k     468m        0.82s      4.79      41.08
>> 32k_lat   32k     1       10k     625m        0.91s      5.76      45.51
>> 48k_lat   48k     1       10k     937m        1.50s      5.26      74.82
>> 64k_lat   64k     1       10k     1.2g        1.74s      6.04      86.77
>> 96k_lat   96k     1       10k     1.8g        2.45s      6.42     122.52
>> 128k_lat  128k    1       1k      250m        0.33s      6.38     164.35
>> 192k_lat  192k    1       1k      375m        0.56s      5.66     277.78
>> 256k_lat  256k    1       1k      500m        0.65s      6.42     326.71
>> 384k_lat  384k    1       1k      750m        0.85s      7.43     423.59
>> 512k_lat  512k    1       1k      1000m       1.28s      6.55     640.76
>> 768k_lat  768k    1       1k      1.4g        2.15s      5.86    1072.87
>> 1m_lat    1m      1       100     200m        0.30s      5.54    1514.93
>> 1.5m_lat  1.5m    1       100     300m        0.26s      9.54    1319.66
>> 2m_lat    2m      1       100     400m        0.60s      5.60    2993.67
>> 3m_lat    3m      1       100     600m        0.90s      5.58    4509.93
>> 4m_lat    4m      1       100     800m        1.20s      5.57    6023.30
>> 6m_lat    6m      1       100     1.1g        1.00s     10.10    4982.83
>> 16k_bw    16k     10k     1       312m        0.39s      6.74      19.45
>> 24k_bw    24k     10k     1       468m        0.71s      5.53      35.56
>> 32k_bw    32k     10k     1       625m        0.95s      5.53      47.42
>> 48k_bw    48k     10k     1       937m        1.42s      5.55      70.91
>> 64k_bw    64k     10k     1       1.2g        1.89s      5.55      94.44
>> 96k_bw    96k     10k     1       1.8g        2.83s      5.56     141.43
>> 128k_bw   128k    1k      1       250m        0.38s      5.56     188.60
>> 192k_bw   192k    1k      1       375m        0.57s      5.57     282.62
>> 256k_bw   256k    1k      1       500m        0.65s      6.50     322.76
>> 384k_bw   384k    1k      1       750m        1.13s      5.58     563.75
>> 512k_bw   512k    1k      1       1000m       1.50s      5.58     751.58
>> 768k_bw   768k    1k      1       1.4g        2.26s      5.57    1129.26
>> 1m_bw     1m      100     1       200m        0.16s     10.24     819.18
>
> I think there's something else going on.  There really shouldn't be huge jumps in the bandwidth like this.
>
> I don't know if this indicates a problem with the HCA (is the firmware up to date?), the switch, the PCI bus, the chipset, or what.  What is your performance running the client and server on the same system?
>
>> 1.5m_bw   1.5m    100     1       300m        0.45s      5.61    2241.51
>> 2m_bw     2m      100     1       400m        0.60s      5.59    3001.57
>> 3m_bw     3m      100     1       600m        0.90s      5.57    4515.06
>> 4m_bw     4m      100     1       800m        0.65s     10.34    3245.21
>> 6m_bw     6m      100     1       1.1g        1.81s      5.56    9046.91
>>
>> starting with 48k test then it seems that maxim (~10Gb/sec) is obtained at 3m:
>>
>> $ ./examples/rstream -b 10.30.3.2 -S all
>> name      bytes   xfers   iters   total       time     Gb/sec    usec/xfer
>> 48k_lat   48k     1       10k     937m        1.40s      5.62      69.96
>> 64k_lat   64k     1       10k     1.2g        1.93s      5.44      96.43
>> 96k_lat   96k     1       10k     1.8g        2.62s      6.01     130.87
>> 128k_lat  128k    1       1k      250m        0.37s      5.62     186.71
>> 192k_lat  192k    1       1k      375m        0.50s      6.33     248.64
>> 256k_lat  256k    1       1k      500m        0.58s      7.22     290.45
>> 384k_lat  384k    1       1k      750m        0.95s      6.62     475.05
>> 512k_lat  512k    1       1k      1000m       1.44s      5.82     721.16
>> 768k_lat  768k    1       1k      1.4g        1.97s      6.38     986.84
>> 1m_lat    1m      1       100     200m        0.19s      8.74     959.41
>> 1.5m_lat  1.5m    1       100     300m        0.44s      5.69    2212.52
>> 2m_lat    2m      1       100     400m        0.60s      5.62    2986.33
>> 3m_lat    3m      1       100     600m        0.90s      5.58    4506.85
>> 4m_lat    4m      1       100     800m        0.68s      9.81    3419.98
>> 6m_lat    6m      1       100     1.1g        1.55s      6.49    7758.06
>> 48k_bw    48k     10k     1       937m        1.16s      6.75      58.22
>> 64k_bw    64k     10k     1       1.2g        1.89s      5.55      94.39
>> 96k_bw    96k     10k     1       1.8g        2.83s      5.56     141.41
>> 128k_bw   128k    1k      1       250m        0.38s      5.58     188.04
>> 192k_bw   192k    1k      1       375m        0.52s      6.01     261.88
>> 256k_bw   256k    1k      1       500m        0.75s      5.57     376.28
>> 384k_bw   384k    1k      1       750m        1.13s      5.58     564.04
>> 512k_bw   512k    1k      1       1000m       1.50s      5.58     752.06
>> 768k_bw   768k    1k      1       1.4g        1.61s      7.80     807.06
>> 1m_bw     1m      100     1       200m        0.30s      5.63    1490.35
>> 1.5m_bw   1.5m    100     1       300m        0.45s      5.60    2248.11
>> 2m_bw     2m      100     1       400m        0.60s      5.58    3005.60
>> 3m_bw     3m      100     1       600m        0.50s      9.98    2522.82
>> 4m_bw     4m      100     1       800m        1.19s      5.62    5971.85
>> 6m_bw     6m      100     1       1.1g        1.80s      5.59    8998.39
>>
>>
>> I don't know what there is behind exactly but it seems that each test depends
>> on what was done in the past.
>
> The alignment of the data along cache lines would be different.  I'll be surprised if that makes this large of a difference.
>
> For bandwidth testing, you want a large QP size (sqsize_default and rqsize_default set to 512 or 1024), large send/receive buffers (mem_default and wmem_default set to 1M+), and a small inline data size (inline_default of 16 or 32).  rstream should configure some of these manually, depending on the testing options.  But the performance you're seeing is varying so greatly that I don't think the software is the issue.
>
> - Sean



-- 
cpp-today.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
