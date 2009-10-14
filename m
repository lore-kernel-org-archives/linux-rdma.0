From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Wed, 14 Oct 2009 15:47:26 -0700
Message-ID: <adahbu18uf5.fsf@cisco.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>
	<4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>
	<4AD63DB1.3060906@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD63DB1.3060906-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (Vu Pham's message of "Wed, 14
	Oct 2009 14:08:01 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > >  > First it does not make sense for user to set it below 60; therefore,
 > >  > it is forced to have 60 and above

 > > Why not?  A minute seems to be a really long time given the point of
 > > these patches is supposed to be failing over faster.  Surely we can tell
 > > if a path really failed sooner than 60 seconds on an IB fabric.

 > When we fail-over, it will cause the luns ownership transfer in
 > target/storage. It's undesirable op unless necessary
 > Target/storage most likely can reboot and come back within 60 seconds
 > We don't want to create the situation of path bouncing

OK, I can see why in some (many) situations it makes sense to wait a
while before reporting a target as gone.  But why do we hard code the
policy of a minimum timeout of 60 seconds in the kernel?  Why not a
minimum of 120 seconds?  What if I know my storage is guaranteed to
reboot in 2 seconds -- why can't I have a timeout of 5 seconds?

You haven't really explained where the magic number of 60 seconds comes from.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
