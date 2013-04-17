From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NFS over RDMA benchmark
Date: Wed, 17 Apr 2013 11:06:13 -0700
Message-ID: <CABgxfbGxhnKj2n0Z-w87rZ6fwCssO31G009gwej957gv1p8PQQ@mail.gmail.com>
References: <0EE9A1CDC8D6434DB00095CD7DB873462CF96C65@MTLDAG01.mtl.com>
	<CABgxfbF7c9ktSoMSPV21JU76V5J4iwbJQ257S91Y3z36WJbJVA@mail.gmail.com>
	<62745258-4F3B-4C05-BFFD-03EA604576E4@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <62745258-4F3B-4C05-BFFD-03EA604576E4-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 17, 2013 at 10:32 AM, Atchley, Scott <atchleyes-1Heg1YXhbW8@public.gmane.org> wrote:
> On Apr 17, 2013, at 1:15 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Wed, Apr 17, 2013 at 7:36 AM, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>> Hi.
>>>
>>> I've been trying to do some benchmarks for NFS over RDMA and I seem to only get about half of the bandwidth that the HW can give me.
>>> My setup consists of 2 servers each with 16 cores, 32Gb of memory, and Mellanox ConnectX3 QDR card over PCI-e gen3.
>>> These servers are connected to a QDR IB switch. The backing storage on the server is tmpfs mounted with noatime.
>>> I am running kernel 3.5.7.
>>>
>>> When running ib_send_bw, I get 4.3-4.5 GB/sec for block sizes 4-512K.
>>> When I run fio over rdma mounted nfs, I get 260-2200MB/sec for the same block sizes (4-512K). running over IPoIB-CM, I get 200-980MB/sec.
>
> Yan,
>
> Are you trying to optimize single client performance or server performance with multiple clients?
>
>
>> Remember there are always gaps between wire speed (that ib_send_bw
>> measures) and real world applications.
>>
>> That being said, does your server use default export (sync) option ?
>> Export the share with "async" option can bring you closer to wire
>> speed. However, the practice (async) is generally not recommended in a
>> real production system - as it can cause data integrity issues, e.g.
>> you have more chances to lose data when the boxes crash.
>>
>> -- Wendy
>
>
> Wendy,
>
> It has a been a few years since I looked at RPCRDMA, but I seem to remember that RPCs were limited to 32KB which means that you have to pipeline them to get linerate. In addition to requiring pipelining, the argument from the authors was that the goal was to maximize server performance and not single client performance.
>
> Scott
>

That (client count) brings up a good point ...

FIO is really not a good benchmark for NFS. Does anyone have SPECsfs
numbers on NFS over RDMA to share ?

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
