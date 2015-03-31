From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Mon, 30 Mar 2015 23:36:02 -0400 (EDT)
Message-ID: <20150330.233602.155832546277570456.davem@davemloft.net>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
	<CAJ3xEMj0T8QXBQdVHmfEFMXwjAFVD-O6ywAwyyVY+M3oRLzAVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMj0T8QXBQdVHmfEFMXwjAFVD-O6ywAwyyVY+M3oRLzAVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Mon, 30 Mar 2015 19:17:01 +0300

> On Sun, Mar 29, 2015 at 4:51 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Under the existing implementation for virtual GIDs, if the SM is not
>> reachable or incurs a delayed response, or if the VF is probed into a
>> VM before their GUID is registered with the SM, there exists a window
>> in time in which the VF sees an incorrect GID, i.e., not the GID that
>> was intended by the admin. This results in exposing a temporal identity
>> to the VF.
> 
> Hi Roland, so your for-next branch is again way behind, still on 3.19
> and while 4.0 is soon @ rc6, we couldn't even rebase this series on
> it. It's really hard where your tree is really active once every nine
> weeks or so, e.g only few days before/after rc1's. I'm not sure what
> you expect us to do, kernel development simply needs not be like this.
> 
> April 3rd-12th is holiday here, and we would like to really really
> know early this week what you intend to pull for 4.1 out of the
> pending things in linux-rdma.

Roland, I have to genuinely agree with Or, that your handling of
patch integration is sub-par and really painful for anyone actually
trying to get real work done here.

If you simply don't have the time to devote to constantly reviewing
patches as they come in, and doing so in a timely manner, please let
someone who is actually interested and has the time to take over.

Only integrating peoples work right before the merge window, and then
disappearing for a long time really isn't acceptable.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
