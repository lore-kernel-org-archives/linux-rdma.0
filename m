From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/core: Fix build warnings
Date: Sun, 3 Nov 2013 10:22:02 +0200
Message-ID: <527607AA.1010309@mellanox.com>
References: <1383236511-4337-1-git-send-email-ogerlitz@mellanox.com>	 <1383236511-4337-2-git-send-email-ogerlitz@mellanox.com>	 <52728D2F.4020301@acm.org> <1383247739.2110.7.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383247739.2110.7.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/10/2013 21:28, David Dillow wrote:
> We want to know about those comparisons, because they often indicate a
> bug -- either in one's thinking, or in the code they've written.
> Changing attr.state from unsigned to signed is unlikely to ever happen,
> as a massive audit would be needed -- this is not an uncommon pattern in
> the kernel.
I agree with Dave.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
