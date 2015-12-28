From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Mon, 28 Dec 2015 15:32:51 -0500
Message-ID: <20151228203249.GA4213@phlsvsds.ph.intel.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com> <20151222181905.GA742@phlsvsds.ph.intel.com> <CAG9sBKNOu+d-5f6FYTXCyTGjJU-md4dW3MFMB2-UDgRFafRdBw@mail.gmail.com> <20151223200727.GA6886@phlsvsds.ph.intel.com> <CAG9sBKNkeA2Op-OTJ_MQ=pC3BQ7=_tB4g6oV=fwDOJ7gs_y+fQ@mail.gmail.com> <20151224161415.GA674@phlsvsds.ph.intel.com> <CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNBDC=YymoYMLjW+RceChQXfNMXcc8UzJJVhqBuW5jGAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 27, 2015 at 07:54:46PM +0200, Moni Shoua wrote:
>>
>> Point is others have looked at the code. No issues have been called out to
>> date as to why what is there won't work for everyone.
>>
>http://marc.info/?l=linux-rdma&m=144968107508268&w=2
>Your answer to the send() issue is first an agreement with the comment
>and later says that it can't be done because of how PIO and SDMA
>(Intel specific implementation)
>This is an example for a discussion that never ended with an agreement.

No. PIO and SDMA is driver specific and lives in the driver. Rdmavt has no 
concept of this. I'm agreeing that the send will be generic and have no hw 
specific stuff.

>> Yes it is specific to Intel *now*, that doesn't mean it should stay that
>> way. Rdmavt could, and in my opinion should, be extended to support
>> soft-roce. I don't think replicating the same thing is a great idea.
>>
>But you post *now* a so called generic driver so it must now fit any
>possible driver (including Soft RoCE)

As I've stated a number of times across multiple threads: It must not do 
anything that would prevent another driver from using it.

>> As to the location, where do you think it should go. drivers/infiniband/sw
>> makes the most sense to me, but open to suggestions.
>>
>> And for the question of why publish when it's not ready, the better question
>> is why not?  Is it not good to see the work in progress as it evolves so the
>> community can provide feedback?
>>
>What kind of a feedback you expect when I don't have an idea about
>your plans for rdmavt
>Interfaces, flows, data structures... all is missing from the
>documentation to rdmavt.

I expect feedback based on the code submissions. More will be coming 
shortly. I have taken all the feedback from the first post and will be 
sending a v2 shortly.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
