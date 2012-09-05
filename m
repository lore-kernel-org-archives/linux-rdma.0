From: Reeted <reeted-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 05 Sep 2012 21:04:19 +0200
Message-ID: <5047A233.2040602@shiftmail.org>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
 <504790D8.7010307@shiftmail.org>
 <64A9A0CD-00E0-4455-A641-324FA9BB8BC2@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <64A9A0CD-00E0-4455-A641-324FA9BB8BC2-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/05/12 19:59, Atchley, Scott wrote:
> On Sep 5, 2012, at 1:50 PM, Reeted wrote:
>
>>
>> I have read that with newer cards the datagram (unconnected) mode is
>> faster at IPoIB than connected mode. Do you want to check?
> I have read that the latency is lower (better) but the bandwidth is lower.
>
> Using datagram mode limits the MTU to 2044 and the throughput to ~3 Gb/s on these machines/cards. Connected mode at the same MTU performs roughly the same. The win in connected mode comes with larger MTUs. With a 9000 MTU, I see ~6 Gb/s. Pushing the MTU to 655120 (the maximum for ipoib), I can get ~13 Gb/s.
>

Have a look at an old thread in this ML by Sebastien Dugue "IPoIB to 
Ethernet routing performance"
He had numbers much higher than yours on similar hardware, and was 
suggested to use datagram to achieve offloading and even higher speeds.
Keep me informed if you can fix this, I am interested but can't test 
infiniband myself right now.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
