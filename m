From: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMA reads/writes per second
Date: Wed, 30 Oct 2013 18:01:31 +0200
Message-ID: <52712D5B.4010209@dev.mellanox.co.il>
References: <CADPSxAiDtn+2JR_q=HAEi8ezEKvn8JBT4VUcKomA4PX=vM5s=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAiDtn+2JR_q=HAEi8ezEKvn8JBT4VUcKomA4PX=vM5s=Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

With ConnectX3 the maximum IOs is around 35M at most.
137M refers to Connect-IB HCA (and not ConnectX3).

Anyway, If you are using 1 process in this test, then 9M is highest you 
can get.
This limitation comes from the SW layer (post_send function for single 
IO takes ~ 100 ns , so posting per processes is bounded to 10M at most)
Above it (and up to the max) can be achieved with multiple parallel 
process or using post list to issue several IOs in parallel in the a 
single post send.
Perftest has a nice demonstration for how to achieve it - 
https://openfabrics.org/downloads/perftest/

As for the second issue,if you randomize each IO address access, as big 
as the buffer the larger chance for a HCA TLB miss.
You can optimize the IO rate using 64B aligned accesses (for both ways) 
for each IO transaction.
I believe you can get around 5M that way, even if every transaction will 
cause a HCA TLB miss.

How do not see a reason WRITE should be different in READ in terms of 
IOs, assuming you randomize both sides in either scenario.
Also, I don't see a reason for different sizes of region to affect here.
If you are using a Sandy Bridge (Xeon E5 series) then data is written to 
L3 cache, regardless of the registered area.

Ido

On 10/29/2013 2:28 AM, Anuj Kalia wrote:
> Hi.
>
> I'm measuring the number of RDMA reads and writes per second. In my
> experimental setup I have one server connected to several clients and
> I want to extract the maximum IOs from the server. I had two questions
> regarding this:
>
> 1. What is the expected number of small (16 byte values) RDMA reads
> for ConnectX 3 cards? Currently, I've seen a maximum of 9 million
> reads per second with my code. However, several websites report much
> higher messages per second. For
> example,http://www.marketwatch.com/story/mellanox-fdr-56gbs-infiniband-solutions-deliver-leading-application-performance-and-scalability-2013-06-17talks
> about 137 messages per second.
> http://www.mellanox.com/pdf/products/oem/RG_HP.pdf reports 40 million
> MPI messages per second. What sort optimizations could I do to reach
> similar numbers?
>
> 2. The number of IOPS drops when the size of the registered region
> increases. For a 1 KB registered region, the maximum random reads per
> second that the server can provide is around 9 million. It drops to 2
> million when I increase the registered size to 1 GB.
> What is the reason behind this? Does the HCA perform caching for
> reads? That could be a possible explanation. Another possible reason
> is TLB misses in the HCA.
> Further, I'm seeing even greater variation with writes. I can think of
> 2 possible explanations for that:
> a. As my writes are to random locations, there could be more TLB
> misses for larger registered regions.
> b. The HCA buffers writes locally and does not transfer them into the
> CPU memory immediately (this can be done only for small registered
> regions).
>
> Thanks for your time!
> I'm sorry if the list receives more than one copy of this email. I've
> been running into a HTML rejection error.
>
> Anuj Kalia,
> Carnegie Mellon University
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
