From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] IB/mlx5: Add create_cq extended command
Date: Sun, 22 Nov 2015 02:15:20 -0800
Message-ID: <20151122101520.GA25187@infradead.org>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
 <1447086657-15358-2-git-send-email-matanb@mellanox.com>
 <20151119145457.GA1104@infradead.org>
 <CAAKD3BAOq+26vV1k5LKOXgOfdr2J92fBta31Pv9XHhEcFc3v6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BAOq+26vV1k5LKOXgOfdr2J92fBta31Pv9XHhEcFc3v6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Matan,

IB_CQ_FLAGS_TIMESTAMP_COMPLETION is _only_ used in the uverbs interface.

But other than that userspace ABIs really must go to the UAPI headers,
otherwise they will be broken sooner or later.  RDMA is an unfortunate
oddball under the kernel subsystems that's been ignoring the rule for
now.  Please ensure at least new interfaces follow this principle, and
old code will need to be fixed up as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
