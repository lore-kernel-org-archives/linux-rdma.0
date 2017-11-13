From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Mon, 13 Nov 2017 18:06:17 +0100
Message-ID: <2ee14e55-2998-0dbf-6367-ed6d7915c291@suse.de>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de>
 <20171113151437.GL18825@mtr-leonro.local>
 <f5e11706-5c7e-a79e-fcf3-4d3df5f35632@suse.de>
 <20171113163812.GN18825@mtr-leonro.local>
 <CANjDDBgqg_i53_pZW-ctiW2GUVc4nft4JQuHZLFEZYiJyzXdTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBgqg_i53_pZW-ctiW2GUVc4nft4JQuHZLFEZYiJyzXdTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 13/11/2017 à 18:02, Devesh Sharma a écrit :
> Hi Nicolas,
>
> Please include following patch as well along with the one you have
> listed already
>
> bnxt_re/lib: fix the memory barrier call during poll-cq
> commit-id: f4e67f1027011a6f9081b6239b866f27f750f678
>
> -Regards
> Devesh

Hi,

I saw some concern from Jason (didn't follow up the thread yet) about the barrier (even though it was in master already).
Did you come to an agreement on the current patch ?
If yes, I'll add it to the list.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
