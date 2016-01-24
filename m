From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 21:58:35 -0800 (PST)
Message-ID: <20160123.215835.869757738499817306.davem@davemloft.net>
References: <56A3FE6F.4000800@redhat.com>
	<CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
	<56A42829.90401@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56A42829.90401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Sat, 23 Jan 2016 20:26:01 -0500

> Can I get some specifics of what you are talking about here?  The reason
> I ask is that I know in this merge cycle there was a function modified
> in the mlx4 driver (I think, or maybe mlx5) where it was first modified
> by a patch series that went through Dave's tree, then further modified
> by a series in my tree.  In both cases, the modification was part of a
> larger series that was specific either to the network tree or the rdma
> tree.  If that's the sort of thing you are talking about, I'm not sure
> how we can resolve that.  The fact that the mlx4_core and mlx5_core
> modules essentially straddle the networking and rdma trees presents a
> unique situation with its own difficulties.  If the problem I listed is
> what you are referring to, the only way I know to fix that is to have
> Mellanox send all of their patches through one tree, and that means
> either Dave or myself is going to have to deal with stuff they wouldn't
> normally deal with.  Of course, if I'm wrong about what you are
> referring to, then enlightenment would be appreciated ;-)

Nothing prevents you from pulling from my tree Doug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
