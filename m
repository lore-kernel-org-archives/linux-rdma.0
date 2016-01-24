From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 23:28:11 -0800 (PST)
Message-ID: <20160123.232811.1358888048550215679.davem@davemloft.net>
References: <56A42829.90401@redhat.com>
	<20160123.215835.869757738499817306.davem@davemloft.net>
	<CA+55aFw_-C5ek_bfw-2p=u38Ez5TN9=B_iBraUTF6jUQc2hSkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFw_-C5ek_bfw-2p=u38Ez5TN9=B_iBraUTF6jUQc2hSkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Date: Sat, 23 Jan 2016 22:51:34 -0800

> On Jan 23, 2016 9:58 PM, "David Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrote:
>>
>> Nothing prevents you from pulling from my tree Doug.
> 
> I really don't think that will fix the fundamental problem.
> 
> Namely the fact that Mellanox has two teams each working on the same driver
> and not talking to each other.

Yes that's a large part of the problem.

> They should sort out their own differences, not have other outside
> people have to sort out their mess.

I agree.

But if they put all of their mlx{4,5}_core changes into my tree, then
they have to coordinate.

Because obviously all the screaming and complaining we've done the past
two merge windows is not working.  They still suck at this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
