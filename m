From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/2] IB/ipoib: Add cleanup to sendonly multicast objects
Date: Thu, 17 Sep 2015 14:19:30 +0300
Message-ID: <CAJ3xEMg28H0DBoO9t-2dopSLWjGs8S0e=eh0KbiXsRNPXwg_2Q@mail.gmail.com>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
	<1442486283-9699-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442486283-9699-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 17, 2015 at 1:38 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Sendonly multicast group entries are potentially created by the driver during
> the xmit flow. Their objects remain in the driver memory, plus the related group
> existing in the SM and the fabric till the driver goes down, even if no one
> uses that multicast entry anymore.
>
> Since this is sendonly, they are also not part of the kernel decvice multicast
> list and hence invocation of the set_rx_mode ndo will not cleam them up either.

oops, Doug, I see few typos here... need to s/decvice/device/ and s/cleam/clean/
-- just in case you are to pick V0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
