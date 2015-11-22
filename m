From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] IB/mlx5: Add create_cq extended command
Date: Sun, 22 Nov 2015 16:04:50 +0200
Message-ID: <CAAKD3BAGsZpbTSnghe6cbJRbrjufe6OZuJmm40u6Vdt1EPEq+Q@mail.gmail.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
	<1447086657-15358-2-git-send-email-matanb@mellanox.com>
	<20151119145457.GA1104@infradead.org>
	<CAAKD3BAOq+26vV1k5LKOXgOfdr2J92fBta31Pv9XHhEcFc3v6g@mail.gmail.com>
	<20151122101520.GA25187@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151122101520.GA25187-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2015 at 12:15 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> Hi Matan,
>
> IB_CQ_FLAGS_TIMESTAMP_COMPLETION is _only_ used in the uverbs interface.
>

Currently this is used only for uverbs interface. The reason for that
is that we've only pushed completion timestamping for user-space
support.
However, there's no reason not to add support for completion
timestamping for ULPs. Therefore, the same flag could be relevant for
ULPs as well.

> But other than that userspace ABIs really must go to the UAPI headers,
> otherwise they will be broken sooner or later.  RDMA is an unfortunate
> oddball under the kernel subsystems that's been ignoring the rule for

So do you imply ib_verbs.h should include ib_user_verbs.h?

> now.  Please ensure at least new interfaces follow this principle, and
> old code will need to be fixed up as well.

Ok, I'll follow this principle for new features.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
