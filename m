From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 3/6] IB/mlx5: Add support for QP with a given
 source QPN
Date: Tue, 13 Jun 2017 18:58:39 +0300
Message-ID: <CAFgAxU88cfMu7fe9J4Tu=8OFwnND6UfCKF=xi7ZaNHStFpQJog@mail.gmail.com>
References: <20170608131511.21040-1-leon@kernel.org> <20170608131511.21040-4-leon@kernel.org>
 <20170608163020.GA16857@obsidianresearch.com> <0ee2641a-4308-6b35-cd0a-e1a5b8b84a6a@dev.mellanox.co.il>
 <20170612160257.GA24829@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612160257.GA24829-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 7:02 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Jun 11, 2017 at 09:51:49AM +0300, Yishai Hadas wrote:
>> On 6/8/2017 7:30 PM, Jason Gunthorpe wrote:
>>
>
> That doesn't even make sense. An API is an API, if the API does not
> require linkage then the hardware can't either.

The API is well defined now and doesn't require the linkage.
But our current HW implementation requires creation of the internal
underlay object in order to support this.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
