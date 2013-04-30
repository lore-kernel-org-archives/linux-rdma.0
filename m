From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFS over RDMA benchmark
Date: Tue, 30 Apr 2013 10:44:50 -0400
Message-ID: <517FD8E2.8050401@talpey.com>
References: <0EE9A1CDC8D6434DB00095CD7DB873462CF96C65@MTLDAG01.mtl.com> <CABgxfbF7c9ktSoMSPV21JU76V5J4iwbJQ257S91Y3z36WJbJVA@mail.gmail.com> <62745258-4F3B-4C05-BFFD-03EA604576E4@ornl.gov> <CABgxfbGxhnKj2n0Z-w87rZ6fwCssO31G009gwej957gv1p8PQQ@mail.gmail.com> <0EE9A1CDC8D6434DB00095CD7DB873462CF9715B@MTLDAG01.mtl.com> <20130423210607.GJ3676@fieldses.org> <0EE9A1CDC8D6434DB00095CD7DB873462CF988C9@MTLDAG01.mtl.com> <20130424150540.GB20275@fieldses.org> <20130424152631.GC20275@fieldses.org> <0EE9A1CDC8D6434DB00095CD7DB873462CF9A820@MTLDAG01.mtl.com> <20130428144248.GA2037@fieldses.org> <0EE9A1CDC8D6434DB00095CD7DB873462CF9C90C@MTLDAG01.mtl.com> <517FC182.3030703@talpey.com> <0EE9A1CDC8D6434DB00095CD7DB873462CF9CBA7@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0EE9A1CDC8D6434DB00095CD7DB873462CF9CBA7-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/30/2013 10:23 AM, Yan Burman wrote:
>> -----Original Message-----
>> From: Tom Talpey [mailto:tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org]
>>>> On Sun, Apr 28, 2013 at 06:28:16AM +0000, Yan Burman wrote:
>>> I finally got up to 4.1GB/sec bandwidth with RDMA (ipoib-CM bandwidth is
>> also way higher now).
>>> For some reason when I had intel IOMMU enabled, the performance
>> dropped significantly.
>>> I now get up to ~95K IOPS and 4.1GB/sec bandwidth.
>>
>> Excellent, but is that 95K IOPS a typo? At 4KB, that's less than 400MBps.
>>
>
> That is not a typo. I get 95K IOPS with randrw test with block size 4K.
> I get 4.1GBps with block size 256K randread test.

Well, then I suggest you focus on whether you are satisfied with a
high bandwidth goal or a high IOPS goal. They are two very different
things, and clearly there are still significant issues to track down
in the server.

>> What is the client CPU percentage you see under this workload, and how
>> different are the NFS/RDMA and NFS/IPoIB overheads?
>
> NFS/RDMA has about more 20-30% CPU usage than NFS/IPoIB, but RDMA has almost twice the bandwidth of IPoIB.

So, for 125% of the CPU, RDMA is delivering 200% of the bandwidth.
A common reporting approach is to calculate cycles per Byte (roughly,
CPU/MB/sec), and you'll find this can be a great tool for comparison
when overhead is a consideration.

> Overall, CPU usage gets up to about 20% for randread and 50% for randwrite.

This is *client* CPU? Writes require the server to take additional
overhead to make RDMA Read requests, but the client side is doing
practically the same thing for the read vs write path. Again, you
may want to profile more deeply to track that difference down.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
