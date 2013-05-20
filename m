From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: libibverbs / libmlx4 release
Date: Mon, 20 May 2013 14:30:40 -0400
Message-ID: <519A6BD0.7050105@redhat.com>
References: <519A1903.5010401@mellanox.com> <CAL1RGDXR+jqTMZ=3FmrK2yJeyp-0cwJmahDnz6PhwbOore2yZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXR+jqTMZ=3FmrK2yJeyp-0cwJmahDnz6PhwbOore2yZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/20/2013 12:49 PM, Roland Dreier wrote:
> On Mon, May 20, 2013 at 5:37 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Following what we discussed last week during the Linux Foundation EU summit, I think it would be good to follow what you said and have a point release for libibverbs and libmlx4 before we pull in the verbs extensions framework and features that use it (XRC, Flow-Steering, etc more fun).
>>
>> I mentioned to you that we have some more libmlx4 patches, but its totally OK for us to submit them after that release, makes sense?
> 
> That's fine, I'll do the releases this week.

If you haven't already done so, can you please update to the latest
autotools and reroll the autotools files when you do the release?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
