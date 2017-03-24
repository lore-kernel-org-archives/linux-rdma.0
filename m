From: Vlad Tsyrklevich <vlad-NIZqynvkaCU43zv7NVfAiQ@public.gmane.org>
Subject: Re: [PATCH v2] infiniband/uverbs: Fix integer overflows
Date: Fri, 24 Mar 2017 16:45:44 -0400
Message-ID: <CAH0z3hM8a4Hra3+gvz5HeFBcmkqmP0KhFQsFQh30SActK+p7mg@mail.gmail.com>
References: <1490385317-35641-1-git-send-email-vlad@tsyrklevich.net> <1490385702.3312.18.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490385702.3312.18.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[replying again to the list with HTML e-mails turned off]

I doubt it. I chose to implement a naive integer overflow check here
instead of checking against some device-specific value since I'm
unfamiliar with the infiniband internals and don't have appropriate
hardware to test such a change against.

On Fri, Mar 24, 2017 at 4:02 PM, Bart Van Assche
<Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On Fri, 2017-03-24 at 15:55 -0400, Vlad Tsyrklevich wrote:
>> The 'num_sge' variable is verfied to be smaller than the 'sge_count'
>> variable; however, since both are user-controlled it's possible to cause
>> an integer overflow for the kmalloc multiply on 32-bit platforms
>> (num_sge and sge_count are both defined u32). By crafting an input that
>> causes a smaller-than-expected allocation it's possible to write
>> controlled data out-of-bounds.
>
> Hello Vlad,
>
> Do you think that an RDMA driver exists that supports a max_sge value that
> is large enough to cause this multiplication to overflow?
>
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
