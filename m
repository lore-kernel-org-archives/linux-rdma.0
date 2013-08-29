From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Thu, 29 Aug 2013 09:35:49 -0700
Message-ID: <CAL1RGDWsWQojev-t5ko0ppijCc11EAwant0D=ceOs7VZ1a4syg@mail.gmail.com>
References: <1376477911-13828-1-git-send-email-ogerlitz@mellanox.com>
 <1376477911-13828-4-git-send-email-ogerlitz@mellanox.com> <CAL1RGDX=ppDWfzVmcFyKOSqYJ-JecPpmdxj+unzL4gWBEKS1vg@mail.gmail.com>
 <521C9D7D.5010304@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521C9D7D.5010304-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> You are correct. We'll fix it in V6.

I'm going to go ahead and merge the existing code now so that we can
get it in before the next merge window opens, but please send
incremental patches fixing these holes where we don't validate
userspace input as soon as you can.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
