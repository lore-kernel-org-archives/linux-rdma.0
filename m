From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Wed, 8 Feb 2017 20:45:47 +0200
Message-ID: <efaec776-07dc-629c-0efc-ef395cec2407@grimberg.me>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <SN1PR07MB22070381E7566FA819E5F8F8F8400@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20170206114609.GK6005@mtr-leonro.local>
 <20170206163937.GB14714@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170206163937.GB14714-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Jason,

> To expound on that - the trade off we discussed in-person was we
> either do something like this or continually take endless
> vendor-specific patches to add 'common' core code for unstandardized
> chip-specific features.
>
> This seemed like the least bad trade off, if another vendor wants the
> same things then they could work together and make an actual
> multi-chip common API. I was expecting this interface to be used in
> only a few places, like the next level of middleware libraries
> (libfabric, mxm, etc) not for many end-users.

I think this is exactly the use-case. Something that looks like a
user-space driver on the back-side of a common API.

> I'm still not completely sure what this API is intended to do, if it is
> really just performance then I am less supportive and would rather see
> an approach like libfabric where a user can build a single provider verbs
> with the same source API, but optimized....

I'm also not in favor for having this code-path solely for performance
reasons, if the common stack is not good enough, let's fix it. What I
think this is trying to solve is the continuous inflation of
non-standard extensions to the common API.

These features raised constant complaints in code review before, which
in turn caused the vendors to place their extensions in an internal
packages (e.g. MLNX_OFED) and also educate their customers to use their
packaged drivers (which usually broke the rest of the world).

So I can understand Mellanox wanting to expose vendor specific
capabilities and move away from their in-house distribution of
user-space packages, and I think we should all encourage it.

And, this is also why I think that another set of a common API is
a good choice.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
