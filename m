From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: SRP initiator and iSER initiator performance
Date: Wed, 03 Mar 2010 23:23:02 +0300
Message-ID: <4B8EC526.4060006@vlnb.net>
References: <e2e108261002271127x253faa84lf6eb8aa77d3cf51a@mail.gmail.com>	 <4B8C1FBF.8060001@vlnb.net> <e2e108261003011238h331e473bge905b8ea695f7483@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261003011238h331e473bge905b8ea695f7483-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche, on 03/01/2010 11:38 PM wrote:
> On Mon, Mar 1, 2010 at 9:12 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org 
> <mailto:vst-d+Crzxg7Rs0@public.gmane.org>> wrote:
> 
>     [ ... ]
>     It's good if my impression was wrong. But you've got suspiciously
>     low IOPS numbers. On your hardware you should have much more. Seems
>     you experienced a bottleneck on the initiator somewhere above the
>     drivers level (fio? sg engine? IRQs or context switches count?), so
>     your results could be not really related to the topic. Oprofile and
>     lockstat output can shed more light on this.
> 
> 
> The number of IOPS I obtained is really high considering that I used the 
> sg I/O engine. This means that no buffering has been used and none of 
> the I/O requests were combined into larger requests. I chose the sg I/O 
> engine on purpose in order to bypass the block layer. I was not 
> interested in record IOPS numbers but in a test where most of the time 
> is spent in the SRP / iSER initiator instead of the block layer.

116K IOPS'es isn't high, it's pretty low for QDR IB. Even 4Gbps FC can 
overperform it. Remember, Microsoft has managed to get 1 million IOPS'es 
from 10GbE, but your card should be much faster. This is why I have 
strong suspicious that the test is incorrect.

Let's estimate how much your IB card can achieve. It has 1us latency on 
1 byte packets, so it can perform at least 1 millions op/sec. This is 
the upper bound estimation, because (1) if the card has multi-core 
setup, this number can be several times bigger, and (2) it includes data 
transfers. From other side, you can read data via your card on 2.9GB/s. 
If we consider that transferring a 512B packet has 100% overhead (this 
is upper bound estimation too, because I can't believe that such a low 
latency HPC interconnect has so huge data transfer overhead), this will 
give us that it can transfer 2.9 / (512 * 2) = 2.9 millions IOPS'es. So, 
your IB hardware should be capable to make at least 1 million I/O 
transfers per second, which is 10 times bigger than you have.

So, you definitely need to find out the bottleneck. I would start from 
checking:

1. fio implemented not too effectively. It can be checked using null 
ioengine.

2. You have only one outstanding command at time (queue depth 1). You 
can check it during the test either using iostat on the initiator, or 
(better) on the SCST target in /proc/scsi_tgt/sessions and 
/proc/scsi_tgt/sgv files.

3. sg engine used by fio in indirect mode, i.e. it transfers data 
between user and kernel spaces using data copy. Can be checked looking 
at the fio's sources or using oprofile.

Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
