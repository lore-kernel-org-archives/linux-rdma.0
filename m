From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Tue, 6 Oct 2015 00:59:06 +0300
Message-ID: <CAJ3xEMiuPEJZ5EQueC=8wQyok2QbEaywQ3gRYVpqOwSaFQcj0A@mail.gmail.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
	<CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng@mail.gmail.com>
	<560AD75A.7080700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560AD75A.7080700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 29, 2015 at 9:24 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I'm getting ready to tackle the for-next backlog.

Sounds, good, rc4 is here... so lets get things going. I see that
there is a 4.4 branch @ your kernel.org tree with the checksum bits,
is there anything else which you've already picked into your github
branches or this is all for now?

Re the backlog, we have Eran's multicast loopback prevention patches
(this thread, Haggai's work to actually add name spaces support [1] on
top of his effort for demuxing requests which landed in 4.3 and
Matan's subsequent RoCE work, where these all stand?

Or.

[1] http://marc.info/?l=linux-rdma&m=144068579319679&w=2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
