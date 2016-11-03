From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Problems trying to bridge/route RoCE
Date: Thu, 3 Nov 2016 11:38:19 -0600
Message-ID: <CAANLjFoqDxnPgQiJT6FBMFYLw+iGyN-2yDYJfSRnEi04AR_0Yg@mail.gmail.com>
References: <CAANLjFqXH+BbsGmH5=DQd-Btsd8kCsSWTNDKCAc89tuigCdbeg@mail.gmail.com>
 <CAG53R5VFmZsb1TzFbmLAGD=N_m_Kt8vk3fCKigS3CA6ACbq8fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5VFmZsb1TzFbmLAGD=N_m_Kt8vk3fCKigS3CA6ACbq8fA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

That box has a build-in ConnectX-3 card that we aren't using in this
test so the mlx4 modules are loaded. I unloaded mlx4_ib, no luck. I
also tried to unload the mlx5_ib driver and it also unloaded mlx5_core
and my interfaces were gone. It seems like I can't only unload
mlx5_ib.

With mlx4_ib unloaded I still can't rping or ib_read_bw (connects, but
get messages like:
ethernet_read_keys: Couldn't read remote address
Unable to read to socket/rdam_cm
Failed to exchange data between server and clients
Problems with warm up) same as before.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, Nov 3, 2016 at 11:16 AM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Robert,
>
> Can you please unload the mlx4_ib module in the bridge/router box and
> give it a quick try?
>
> Parav
>
> On Thu, Nov 3, 2016 at 10:32 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> I'm trying to do some testing of RoCE v2 and so I put a LInux box
>> between two RoCE  machines. I think the ConnectX-4 Lx card in the
>> bridge/router is intercepting the RoCE traffic and so it is not being
>> bridged/routed. I don't see any traffic using tcpdump which seems to
>> confirm this. I thought I could change the UDP port that the card is
>> looking for RoCE traffic to something not in use [0], but rr_proto is
>> not a valid parameter for the inbox mlx5_core module on 4.8.5. I can
>> ping across the bridge/router so I know that it is setup correctly,
>> just RDMA is not working.
>>
>> Any ideas on how to pass RoCE traffic like normal traffic? The reason
>> we are using a Linux box is that we can use netem to understand how
>> RoCE behaves in different situations.
>>
>> [0] https://community.mellanox.com/docs/DOC-1444
>>
>> Thank you
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
