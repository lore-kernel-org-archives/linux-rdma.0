From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB driver
Date: Sun, 26 Mar 2017 19:17:13 +0300
Message-ID: <CAAk-MO_7LVUQS_8+h9shFEXkjT6NHkzXeYRH+_8Wcjr0P+dHAw@mail.gmail.com>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
 <20170320205927.GA17225@obsidianresearch.com> <20170321114955.GB2079@mtr-leonro.local>
 <20170321161530.GB22216@obsidianresearch.com> <20170321164952.GE2079@mtr-leonro.local>
 <CAAk-MO_KEV9MA5Dcaz8SZagMeC4hQX456Cu8To-YRBNMeNu3pg@mail.gmail.com> <20170322165238.GA26589@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170322165238.GA26589-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 22, 2017 at 7:52 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Mar 22, 2017 at 01:18:30PM +0200, Erez Shitrit wrote:
>
>> 1. The qkey is not assigned at the initialization stage and the value
>> in ah struct is not correct. It looks like, there is no way to avoid
>> forwarding qkey (the item #6 - =E2=80=9Cno need to pass qkey, it is in t=
he ah
>> struct=E2=80=9D).
>
> It does make some sense that the qkey in the AH is not right, but it
> still does not really make sense to forward it..
>
> Just have the driver capture the qkey during 'attach_mcast'..

I agree, will move it via the attach over the broadcast mcast.

>
> Looking at it more, there is something wrong with the implementation
> in mlx5 since attach_mcast does not even use the qkey. I have no idea
> how this works since the rx side must use a filter that only allows
> packets that match the qkey for security.

It works since the sm only generates 0xb1b  q_key value, and the mlx5 used =
that.
This was for the RFC only, I will update the q_key in the qp after the
join to the broadcast.

>
> Likely you will want to add a qkey argument to 'attach_mcast' to sort
> this out..

Yes. I will. thanks.

>
>> 2. In order to use the send from the ndo, there is need to pass the
>> pointer to ib_av struct. The immediate solution is to embed it into
>> the skb->data (we have 20 bytes free from the pseudo header).
>
> Well, there are two solutions, one is to encode the ah in the pseudo
> header during ipoib_hard_header. This is actually an optimization
> because ipoib_hard_header is called bfore GSO splitting, so the ah can
> be computed once instead of computed for every split packet. The
> downside here is that it may be very complicated to store a kref in a
> skb pseudo header and properly unref it at all the right times..

It is an optimization, and still we need to get the ah even at the
middle of GSO, for each skb, or to keep it somewhere, also will need
to keep more space in the skb, more processing.

>
> The other is to factor out the AH extraction from ipoib_start_xmit
> into a helper function and have all the rn drivers call it to get the
> AH.

We will pay with performance degradation for each send.

I think that right thing to do is to keep it that way, specific call
for send and not via the ndo.
All the others that we can do doesn't feel right.

>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
