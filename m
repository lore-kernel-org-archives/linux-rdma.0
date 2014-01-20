From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Mon, 20 Jan 2014 13:40:55 +0100
Message-ID: <52DD1957.90108@acm.org>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com> <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/08/14 01:51, Roland Dreier wrote:
> On Tue, Jan 7, 2014 at 1:02 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Currently there is single patch for 3.14 on your for-next branch, the
>> usnic driver. With 3.13 being on rc7 and likely to be released next
>> week, are you planning any other merges for 3.14? we have patches
>> waiting for weeks and months without any comment from you.
> 
> I am definitely planning on merging the new IBoE IP addressing stuff,
> since we seem to have solved the ABI issues.
> 
> The UD flow steering patches seem good and I will take a closer look soon.
> 
> And there are quite a few usnic patches still to pick up.
> 
> I'm confident that will all make it.
> 
> 
> The data integrity stuff I'm not so sure about.  Sean raised some I
> think legitimate questions about whether all this should be added to
> the verbs API and I want to see more discussion or at least have a
> deep think about this myself before comitting.

Hi Roland,

In his role as SRP maintainer Dave Dillow had acked a few SRP initiator
patches three weeks ago (see also
http://thread.gmane.org/gmane.linux.scsi/86532/focus=87013). As far as I
can see these patches are not yet in your for-next branch ? Do you see
any chance to get these included in kernel 3.14 ?

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
