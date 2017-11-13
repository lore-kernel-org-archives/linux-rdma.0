From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Mon, 13 Nov 2017 12:34:25 -0700
Message-ID: <20171113193425.GO6918@ziepe.ca>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de>
 <20171113151437.GL18825@mtr-leonro.local>
 <f5e11706-5c7e-a79e-fcf3-4d3df5f35632@suse.de>
 <20171113163812.GN18825@mtr-leonro.local>
 <CANjDDBgqg_i53_pZW-ctiW2GUVc4nft4JQuHZLFEZYiJyzXdTQ@mail.gmail.com>
 <2ee14e55-2998-0dbf-6367-ed6d7915c291@suse.de>
 <CANjDDBgiB4tFmyGeQwEk53Czs1iJzKLvF6mwSmOZeNm0cUo-8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBgiB4tFmyGeQwEk53Czs1iJzKLvF6mwSmOZeNm0cUo-8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 13, 2017 at 10:56:44PM +0530, Devesh Sharma wrote:
> Yeah,
> 
> Jason is asking for further amendments to the barrier mechanism we
> have today in rdma-core. That can be handled in a separate patch
> series.  For now this should be good to go unless Jason suggests
> otherwise.

It should be fine as is. This is just something we should fix in
mainline to ensure we don't get burned by a newer compiler or
something.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
