From: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 9 Sep 2015 08:41:23 +0200
Message-ID: <20150909064123.GA2122@nanopsycho.orion>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
 <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
 <CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
 <55EFA2BF.7060006@redhat.com>
 <CA+55aFwg+QCM=xaoK4ic+4AymqCYrF4Ny8WO9iY2hHFBLNT3VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwg+QCM=xaoK4ic+4AymqCYrF4Ny8WO9iY2hHFBLNT3VQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Wed, Sep 09, 2015 at 05:33:28AM CEST, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
>On Tue, Sep 8, 2015 at 8:08 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> With a comment that said "I can carry this merge forward, no further
>> action is necessary on your part".  That combined with my lack of deep
>> internal knowledge of what it is that Stephen is doing made me go "Ok,
>> he says don't do anything, so I won't change it."
>
>So quite frankly, Stephen does a really good job at merging and most
>of his merges are very on point. He's been doing a lot of them as part
>of linux-next, and has seen more conflicts than just about anybody
>else.
>
>But I think to him it's mostly just an issue of "get the right end
>result". I don't think he goes: "this merge conflict is a result of a
>breakdown of the development process".
>
>Conversely, to me, one of the main reasons I want to do those merges
>is exactly because I think conflicts are more about the development
>process issues than about "just getting the right end result". Yes,
>obviously I want to get the rigth end result too, but I very much
>react to how/why the conflict happened in the first place. The end
>result is _almost_ secondary, although 99% of the time the primary
>issue doesn't really even raise its head.
>
>So I'm upset not because the conflict is hard to resolve (it isn't),
>but because I feel this was really badly handled.
>
>Yes, the fact that Mellanox people sent two different patches to two
>different maintainers that did the same thing in two different ways is
>odd. Matan and Jiri are cc'd, and I think that whole thing just smells
>really bad.

It's not that odd. I'm not checking rdma tree. I work with net-next/net
tree only when I do net patches. I wasn't aware of Matan's patches,
different group.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
