From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: 4.4's rdma plate
Date: Sun, 11 Oct 2015 23:58:59 +0300
Message-ID: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

As we're soon on 4.3-rc5, could you please update how things look for 4.4?

The mutlicast loopback prevention patches from Eran were intially
posted ~two months ago and went through testing by Christoph and Co.

The patches do have one new uverb entry (extended form for
ib_uverbs_create_qp) and other than that no real sensitive piece. If
you feel you need help to review that one (patch 1), I guess there
should be people on this list who can do that, and anyway, I don't
think it makes sense to delay a feature which is (1) small in volume
(2) critical to latency sensitive application for another kernel
release. The patch set also adds nice usage of the feature to the mlx4
EN driver (patches 2,3,4) and we don't want another kernel cycle to
get lost w.r.t this feature, so?

Haggai has posted the follow up patches to the demux series, which
adds name spaces support for the RDMA-CM [1] -- this is a strict
follow up which by itself went through a detailed review -- the break
up for a pre-series that does the demux refactoring didn't leave much
in the name space series, so I would say this should be ready to go
to, agree?

Matan has posted the next steps of his RoCE work, two patch series.
Please let us know where you see this standing too.

The SW-RoCE driver was posted to staging, V1 is fully operable, do you
see it as ready to be picked there?

Or.

[1] http://marc.info/?l=linux-rdma&m=144068579319679&w=2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
