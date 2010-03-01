From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: SRP initiator and iSER initiator performance
Date: Mon, 01 Mar 2010 23:12:47 +0300
Message-ID: <4B8C1FBF.8060001@vlnb.net>
References: <e2e108261002271127x253faa84lf6eb8aa77d3cf51a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261002271127x253faa84lf6eb8aa77d3cf51a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche, on 02/27/2010 10:27 PM wrote:
> On Mon, Jan 11, 2010 at 7:44 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
>> [ ... ]
>>
>> SRP initiator seems to be not too well optimized for the best performance. ISER initiator is noticeably better in this area.
> 
> (replying to an e-mail of one month ago)
> 
> I'm not sure the above statement makes sense. Below you can find the
> performance results for 512-byte reads with a varying number of
> threads and a NULLIO target. With a sufficiently high number of
> threads this test saturated the two CPU cores of the initiator system
> but not the CPU core of the target system. So one can conclude from
> the numbers below that for the initiator and target software
> combinations used for this test that although the difference is small,
> the latency for the SRP traffic is slightly lower than that of the
> iSER traffic and also that the CPU usage of the SRP traffic is
> slightly lower than that of the iSER traffic. These numbers are quite
> impressive since one can conclude from the numbers below that for both
> protocols one I/O operation is completed by the initiator system in
> about 17 microseconds or 44000 clock cycles.
> 
> iSER:
>  1   read : io=128MB, bw=13,755KB/s, iops=27,510, runt=  9529msec
>  2   read : io=256MB, bw=26,118KB/s, iops=52,235, runt= 10037msec
>  4   read : io=512MB, bw=48,985KB/s, iops=97,970, runt= 10703msec
>  8   read : io=1,024MB, bw=57,519KB/s, iops=115K, runt= 18230msec
> 16   read : io=2,048MB, bw=57,880KB/s, iops=116K, runt= 36233msec
> 32   read : io=4,096MB, bw=57,990KB/s, iops=116K, runt= 72328msec
> 64   read : io=8,192MB, bw=58,066KB/s, iops=116K, runt=144468msec
> CPU load for 64 threads (according to vmstat 2): 20% us + 80% sy on
> the initiator and 40% us + 20% sy + 40% id on the target.
> 
> SRP:
>  1   read : io=128MB, bw=14,211KB/s, iops=28,422, runt=  9223msec
>  2   read : io=256MB, bw=26,275KB/s, iops=52,549, runt=  9977msec
>  4   read : io=512MB, bw=49,257KB/s, iops=98,513, runt= 10644msec
>  8   read : io=1,024MB, bw=60,322KB/s, iops=121K, runt= 17383msec
> 16   read : io=2,048MB, bw=61,272KB/s, iops=123K, runt= 34227msec
> 32   read : io=4,096MB, bw=61,176KB/s, iops=122K, runt= 68561msec
> 64   read : io=8,192MB, bw=60,963KB/s, iops=122K, runt=137602msec
> CPU load for 64 threads (according to vmstat 2): 20% us + 80% sy on
> the initiator and 0% us + 50% sy + 50% id on the target.
> 
> Setup details:
> * The above output was generated with the following command:
> for i in 1 2 4 8 16 32 64; do printf "%2d " $i; io-load 512 $i
> ${initiator_device} | grep runt; done
> * The io-load script is as follows:
> #!/bin/sh
> blocksize="${1:-512}"
> threads="${2:-1}"
> dev="${3:-sdj}"
> fio --bs="${blocksize}" --buffered=0 --size=128M --ioengine=sg
> --rw=read --invalidate=1 --end_fsync=1 --thread --numjobs="${threads}"
> --loops=1 --group_reporting --name=nullio --filename=/dev/${dev}
> 
> * SRP target software: SCST r1522 compiled in release mode.
> * iSER target software: tgt 1.0.2.
> 
> * InfiniBand hardware: QDR PCIe 2.0 HCA's.
> 
> * Initiator system:
> 2.6.33-rc7 kernel (for-next branch of Rolands InfiniBand repository
> without the recently posted iSER and SRP performance improvement
> patches).
> SRP initiator was loaded with parameter srp_sg_tablesize=128
> Frequency scaling was disabled.
> Runlevel: 3.
> CPU: E6750 @ 2.66GHz.
> 
> * Target system:
> 2.6.30.7 kernel + SCST patches.
> Frequency scaling was disabled.
> Runlevel: 3.
> CPU: E8400 @ 3.00GHz booted with maxcpus=1.

It's good if my impression was wrong. But you've got suspiciously low 
IOPS numbers. On your hardware you should have much more. Seems you 
experienced a bottleneck on the initiator somewhere above the drivers 
level (fio? sg engine? IRQs or context switches count?), so your results 
could be not really related to the topic. Oprofile and lockstat output 
can shed more light on this.

Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
