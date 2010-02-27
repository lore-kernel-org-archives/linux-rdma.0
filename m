From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: SRP initiator and iSER initiator performance
Date: Sat, 27 Feb 2010 20:27:50 +0100
Message-ID: <e2e108261002271127x253faa84lf6eb8aa77d3cf51a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 11, 2010 at 7:44 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> w=
rote:
>
> [ ... ]
>
> SRP initiator seems to be not too well optimized for the best perform=
ance. ISER initiator is noticeably better in this area.

(replying to an e-mail of one month ago)

I'm not sure the above statement makes sense. Below you can find the
performance results for 512-byte reads with a varying number of
threads and a NULLIO target. With a sufficiently high number of
threads this test saturated the two CPU cores of the initiator system
but not the CPU core of the target system. So one can conclude from
the numbers below that for the initiator and target software
combinations used for this test that although the difference is small,
the latency for the SRP traffic is slightly lower than that of the
iSER traffic and also that the CPU usage of the SRP traffic is
slightly lower than that of the iSER traffic. These numbers are quite
impressive since one can conclude from the numbers below that for both
protocols one I/O operation is completed by the initiator system in
about 17 microseconds or 44000 clock cycles.

iSER:
=A01=A0=A0 read : io=3D128MB, bw=3D13,755KB/s, iops=3D27,510, runt=3D=A0=
 9529msec
=A02=A0=A0 read : io=3D256MB, bw=3D26,118KB/s, iops=3D52,235, runt=3D 1=
0037msec
=A04=A0=A0 read : io=3D512MB, bw=3D48,985KB/s, iops=3D97,970, runt=3D 1=
0703msec
=A08=A0=A0 read : io=3D1,024MB, bw=3D57,519KB/s, iops=3D115K, runt=3D 1=
8230msec
16=A0=A0 read : io=3D2,048MB, bw=3D57,880KB/s, iops=3D116K, runt=3D 362=
33msec
32=A0=A0 read : io=3D4,096MB, bw=3D57,990KB/s, iops=3D116K, runt=3D 723=
28msec
64=A0=A0 read : io=3D8,192MB, bw=3D58,066KB/s, iops=3D116K, runt=3D1444=
68msec
CPU load for 64 threads (according to vmstat 2): 20% us + 80% sy on
the initiator and 40% us + 20% sy + 40% id on the target.

SRP:
=A01=A0=A0 read : io=3D128MB, bw=3D14,211KB/s, iops=3D28,422, runt=3D=A0=
 9223msec
=A02=A0=A0 read : io=3D256MB, bw=3D26,275KB/s, iops=3D52,549, runt=3D=A0=
 9977msec
=A04=A0=A0 read : io=3D512MB, bw=3D49,257KB/s, iops=3D98,513, runt=3D 1=
0644msec
=A08=A0=A0 read : io=3D1,024MB, bw=3D60,322KB/s, iops=3D121K, runt=3D 1=
7383msec
16=A0=A0 read : io=3D2,048MB, bw=3D61,272KB/s, iops=3D123K, runt=3D 342=
27msec
32=A0=A0 read : io=3D4,096MB, bw=3D61,176KB/s, iops=3D122K, runt=3D 685=
61msec
64=A0=A0 read : io=3D8,192MB, bw=3D60,963KB/s, iops=3D122K, runt=3D1376=
02msec
CPU load for 64 threads (according to vmstat 2): 20% us + 80% sy on
the initiator and 0% us + 50% sy + 50% id on the target.

Setup details:
* The above output was generated with the following command:
for i in 1 2 4 8 16 32 64; do printf "%2d " $i; io-load 512 $i
${initiator_device} | grep runt; done
* The io-load script is as follows:
#!/bin/sh
blocksize=3D"${1:-512}"
threads=3D"${2:-1}"
dev=3D"${3:-sdj}"
fio --bs=3D"${blocksize}" --buffered=3D0 --size=3D128M --ioengine=3Dsg
--rw=3Dread --invalidate=3D1 --end_fsync=3D1 --thread --numjobs=3D"${th=
reads}"
--loops=3D1 --group_reporting --name=3Dnullio --filename=3D/dev/${dev}

* SRP target software: SCST r1522 compiled in release mode.
* iSER target software: tgt 1.0.2.

* InfiniBand hardware: QDR PCIe 2.0 HCA's.

* Initiator system:
2.6.33-rc7 kernel (for-next branch of Rolands InfiniBand repository
without the recently posted iSER and SRP performance improvement
patches).
SRP initiator was loaded with parameter srp_sg_tablesize=3D128
=46requency scaling was disabled.
Runlevel: 3.
CPU: E6750 @ 2.66GHz.

* Target system:
2.6.30.7 kernel + SCST patches.
=46requency scaling was disabled.
Runlevel: 3.
CPU: E8400 @ 3.00GHz booted with maxcpus=3D1.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
