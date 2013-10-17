From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V9 libmlx4 0/2] Add extension and XRC QP support
Date: Thu, 17 Oct 2013 12:03:37 +0300
Message-ID: <525FA7E9.3080906@mellanox.com>
References: <1375369555-11416-1-git-send-email-yishaih@mellanox.com> <CAJZOPZJ9gr=4Z-9XK0JRcojsXEwzXV9Hn+1h-vcu3fcvbWxM-Q@mail.gmail.com> <CAG4TOxP2CUgUsu-061XZpEgY89k0Xf4+jfTOmq=b_h0Q1Ccs0w@mail.gmail.com> <CAJZOPZKJzkiVqaHPx1Zvs0boxyy0P=KJSkq-7ZuA6FMJwbh-4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKJzkiVqaHPx1Zvs0boxyy0P=KJSkq-7ZuA6FMJwbh-4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/08/2013 23:32, Or Gerlitz wrote:
> On Tue, Aug 6, 2013 at 8:40 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> On Tue, Aug 6, 2013 at 8:03 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Could you finally-long-lastish post some comments on how you see this?
>>> any bugs or flames you find here, is this going to be accepted? when?
>>
>> Have you read the patches?  Any comments?
> The XRC patches, YES, I have looked on them and along the ..v9 trail I
> provided Yishai and earlier to Sean some comments that were fixed.
> Also Shlomo from our team tested the patches with iSER target (tgt,
> user space) and initiator (kernel) experimental code that uses XRC and
> we provided few patches to bugs in the IB core and mlx4 driver,
> stepped on the way. Also I posted earlier this week few more XRC
> patches to kernel bugs found by Yishai and team while they tested this
> series for the last round of submission.
>
> As for the user space verbs extensions framework/impl., I (&& Eli
> Cohen too) did go to some level through the design and architecture
> set by Tzahi, Jason and Sean, but you know what, one can't master it
> all. So I in that respect, OTOH I am OK with the proposed design and
> code, but if you wake me up in the middle of the night, I can't sing
> it out loud. But OTOH, I don't wear the maintainer hat, and you said
> no need for co-maintainer to libibverbs last time we talked, so after
> the folks worked on that for > year, its about time for you to do so
> too, makes sense?
>
>

Hi Roland, another two months elapsed and not a word from you here, how 
can we make progress?
do you need any further feedback from maybe Sean or Jason?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
