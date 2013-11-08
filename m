From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: linux-next: build warning after merge of the infiniband tree
Date: Fri, 8 Nov 2013 11:24:53 -0800
Message-ID: <CAG4TOxNvq0jxCJgLWZqdU39Bg968AUmBnd7nooJHy6ojw15=+Q@mail.gmail.com>
References: <20131104155526.10e5aed0cd9512c47a82529f@canb.auug.org.au> <32E1700B9017364D9B60AED9960492BC211C6448@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211C6448-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry about that, folded in the fix I missed and will push out the tree shortly.

On Mon, Nov 4, 2013 at 5:42 AM, Marciniszyn, Mike
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> This issue was caught by Tetsuo Handa and Acked on 10/30: http://marc.info/?t=138313364500008&r=1&w=2.
>
> Roland, I noticed that the Tetsuo's original message didn't cc the linux-rdma list?
>
> Mike
>
>> -----Original Message-----
>> From: Stephen Rothwell [mailto:sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org]
>> Sent: Sunday, November 03, 2013 11:55 PM
>> To: Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jan Kara;
>> Marciniszyn, Mike
>> Subject: linux-next: build warning after merge of the infiniband tree
>>
>> Hi all,
>>
>> After merging the infiniband tree, today's linux-next build (x86_64
>> allmodconfig) produced this warning:
>>
>> drivers/infiniband/hw/ipath/ipath_user_sdma.c: In function
>> 'ipath_user_sdma_pin_pages':
>> drivers/infiniband/hw/ipath/ipath_user_sdma.c:283:6: warning: 'j' is used
>> uninitialized in this function [-Wuninitialized]
>>   ret = get_user_pages_fast(addr, j, 0, pages);
>>       ^
>>
>> Introduced by commit 18fec3c6bdcb ("IB/ipath: Convert
>> ipath_user_sdma_pin_pages() to use get_user_pages_fast()").  How did that
>> pass review or testing?
>>
>> --
>> Cheers,
>> Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
