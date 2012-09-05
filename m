From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 5 Sep 2012 13:59:23 -0400
Message-ID: <64A9A0CD-00E0-4455-A641-324FA9BB8BC2@ornl.gov>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
 <504790D8.7010307@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504790D8.7010307-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Reeted <reeted-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sep 5, 2012, at 1:50 PM, Reeted wrote:

> On 08/29/12 21:35, Atchley, Scott wrote:
>> Hi all,
>> 
>> I am benchmarking a sockets based application and I want a sanity check on IPoIB performance expectations when using connected mode (65520 MTU).....
> 
> I have read that with newer cards the datagram (unconnected) mode is 
> faster at IPoIB than connected mode. Do you want to check?

I have read that the latency is lower (better) but the bandwidth is lower.

Using datagram mode limits the MTU to 2044 and the throughput to ~3 Gb/s on these machines/cards. Connected mode at the same MTU performs roughly the same. The win in connected mode comes with larger MTUs. With a 9000 MTU, I see ~6 Gb/s. Pushing the MTU to 655120 (the maximum for ipoib), I can get ~13 Gb/s.

> What benchmark program are you using?

netperf with process binding (-T). I tune sysctl per the DOE FasterData specs:

http://fasterdata.es.net/host-tuning/linux/

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
