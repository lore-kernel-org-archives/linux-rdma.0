From: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Fri, 05 Apr 2013 16:51:20 -0400
Message-ID: <515F3948.40205@linux.vnet.ibm.com>
References: <20130324155153.GA8597@redhat.com> <515F3160.4020007@linux.vnet.ibm.com> <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry, I was wrong. ignore the comments about cgroups. That's still 
broken. (i.e. trying to register RDMA memory while using a cgroup swap 
limit cause the process get killed).

But the GIFT flag patch works (my understanding is that GIFT flag allows 
the adapter to transmit stale memory information, it does not have 
anything to do with cgroups specifically).

Am I missing something? I was only testing the GIFT flag patch.

Note: I only turned it on - I did not verify the (non) consitency of the 
memory that was transmitted.

- Michael


On 04/05/2013 04:43 PM, Roland Dreier wrote:
> On Fri, Apr 5, 2013 at 1:17 PM, Michael R. Hines
> <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>> I also removed the IBV_*_WRITE flags on the sender-side and activated
>> cgroups with the "memory.memsw.limit_in_bytes" activated and the migration
>> with RDMA also succeeded without any problems (both with *and* without GIFT
>> also worked).
> Not sure I'm interpreting this correctly.  Are you saying that things
> worked without actually setting the GIFT flag?   In which case why are
> we adding this flag?
>
>   - R.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
