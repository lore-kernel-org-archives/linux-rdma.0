From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: v3.7: Unloading ib_ipoib triggers circular locking dependency complaint
Date: Mon, 26 Nov 2012 02:08:37 -0800
Message-ID: <CAL1RGDX0X_QwKL9_5r922++Aga7Umq6ch5Nik1=DCvr3jiyJWQ@mail.gmail.com>
References: <50AF67C5.7090200@acm.org> <CAJZOPZJ55dqpOsnP-jbgXRrLZpyRzD2v8pg7pAAWMtWWr-m1FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJ55dqpOsnP-jbgXRrLZpyRzD2v8pg7pAAWMtWWr-m1FA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Does anyone has an idea where the "s_active" lock is defined and what
> is its role?

Look in fs/sysfs/sysfs.h and how dep_map is used in fs/sysfs
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
