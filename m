From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: Don't include command header size in uverbs
 create_flow
Date: Thu, 17 Oct 2013 12:19:30 +0300
Message-ID: <525FABA2.6000507@mellanox.com>
References: <cover.1381510045.git.ydroneaud@opteya.com> <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com> <525C0BF2.2060201@mellanox.com> <72b95284386dc57dfa1c7c883b4f45af@meuh.org> <CAL1RGDWarJPu_6u5oaL6NgZZJXBuB09vTi9xhxHALfiY_W9Sgg@mail.gmail.com> <122f1a29d6fe45449a6a153a3a9ba8b1@meuh.org> <CAL1RGDXP3+X=go4GiW_SsvSvC_VS-B7uacJN0u5wVtU3NWfvQA@mail.gmail.com> <CAJZOPZLr41MGb7qPHcFVQxNcwwAB8i4vnGQhEcu0oZ-BOiMBcg@mail.gmail.com> <CAL1RGDW7KwSOmmsRxDokUHR-Mh1OzaQvDege5Rq7JsSU8AgEHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDW7KwSOmmsRxDokUHR-Mh1OzaQvDege5Rq7JsSU8AgEHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16/10/2013 03:04, Roland Dreier wrote:
> On Tue, Oct 15, 2013 at 2:34 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Roland, after applying a small fix which was sent to you by Matan on
>> Sep 22nd + another tiny fix by Yann to Matan's patch (the two can be
>> surely squashed into one small patch), things are working OK. Yann is
>> suggesting to enhance them to work and look even better and for some
>> reasons (life) he didn't get to do that on the 3-4 months the patches
>> spent on the list and went through review of Sean/Jason/Shawn and you
>> (RD). I don't see how/why you use the term half-baked here.
> Unless I'm misunderstanding, Yann's suggestion for enhancement is not
> user/kernel ABI compatible with what is in the tree now.  Given that
> we should really try to find an ABI that lasts for a long time, and
> that we already have a proposal to improve things, shouldn't we hold
> off on freezing the new ABI for one more kernel cycle?
>
>

Roland,  Yann, the uverbs extensions + flow-steering  patches spent many 
months on the list, once the review started
we did quick fixes for all the comments and made it for 3.12-rc1 which 
was delay or two kernel cycles vs. what
could happen if the feedback was on time (*).

Indeed since we do want to have ABI that lasts for long, deferring the 
uverbs support for extensions to 3.13 along with
flow-steering support to user space is something we can live with, 
conditioned on commitment of Yann to quickly submit
his fixed patches that addresses the issues Matan raised and of you (RD) 
to pick them once Yann and Matan agree
its done into for-next so they are safe for 3.13

Just to double check, by no means we are talking on reverting the whole 
series, flow-steering will be in
3.12 in the IB core and mlx4_ib

OK?!

Or.

(*) ~Ditto for the IP based addressing series, I sent you detailed reply 
to your comments > month ago and not
a word from you, so another kernel cycles is going to be wasted there too.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
