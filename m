From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 9/9] IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX
Date: Wed, 2 Oct 2013 23:01:43 +0300
Message-ID: <CAJZOPZ+ZGD7g03Ms5c0Cgwng4nk5BH1C6FU2rpM9BQ7y=XAMuw@mail.gmail.com>
References: <CAJZOPZJ_F06xORoQyt-6_SK5P5Y7LXekQuNKHHYSt+oJ8sV1GA@mail.gmail.com>
	<52480568.8000801@mellanox.com>
	<CAGgPuS2791OXo9JrZ030qSn_4Yi777Vw5f8LP1-u2npNKppoKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGgPuS2791OXo9JrZ030qSn_4Yi777Vw5f8LP1-u2npNKppoKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 2, 2013 at 6:09 PM, Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> One more point I have is, since current application like
> perftest/qperf/rping/krping do not have code to receive ipv6 address,
> do you have plans to modify these?

rping supports ipv6, as for krping, yes, it needs to be enhanced to
support that too.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
