From: Peng Tao <bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NFS over RDMA benchmark
Date: Fri, 19 Apr 2013 10:27:50 +0800
Message-ID: <CA+a=Yy7zruyGbjLyYXtPsYs12xs1uCwXo9BJtU1Fg6OMoC2z6g@mail.gmail.com>
References: <0EE9A1CDC8D6434DB00095CD7DB873462CF96C65@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0EE9A1CDC8D6434DB00095CD7DB873462CF96C65-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 17, 2013 at 10:36 PM, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi.
>
> I've been trying to do some benchmarks for NFS over RDMA and I seem to only get about half of the bandwidth that the HW can give me.
> My setup consists of 2 servers each with 16 cores, 32Gb of memory, and Mellanox ConnectX3 QDR card over PCI-e gen3.
> These servers are connected to a QDR IB switch. The backing storage on the server is tmpfs mounted with noatime.
> I am running kernel 3.5.7.
>
> When running ib_send_bw, I get 4.3-4.5 GB/sec for block sizes 4-512K.
> When I run fio over rdma mounted nfs, I get 260-2200MB/sec for the same block sizes (4-512K). running over IPoIB-CM, I get 200-980MB/sec.
> I got to these results after the following optimizations:
> 1. Setting IRQ affinity to the CPUs that are part of the NUMA node the card is on
> 2. Increasing /proc/sys/sunrpc/svc_rdma/max_outbound_read_requests and /proc/sys/sunrpc/svc_rdma/max_requests to 256 on server
> 3. Increasing RPCNFSDCOUNT to 32 on server
Did you try to affine nfsd to corresponding CPUs where your IB card
locates? Given that you see a bottleneck on CPU (as in your later
email), it might be worth trying.

> 4. FIO arguments: --rw=randread --bs=4k --numjobs=2 --iodepth=128 --ioengine=libaio --size=100000k --prioclass=1 --prio=0 --cpumask=255 --loops=25 --direct=1 --invalidate=1 --fsync_on_close=1 --randrepeat=1 --norandommap --group_reporting --exitall --buffered=0
>
On client side, it may be good to affine FIO processes and nfsiod to
CPUs where IB card locates as well, in case client is the bottleneck.

--
Thanks,
Tao
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
