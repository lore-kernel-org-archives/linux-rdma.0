From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 16 Jul 2015 05:45:07 -0700
Message-ID: <20150716124507.GA5943@infradead.org>
References: <55A56640.2000206@redhat.com>
 <CA+55aFzdE94JcGT3aF0+rp-ym6UdMCAcQD2LSCBeedv9dLRfhQ@mail.gmail.com>
 <20150716075542.GA9093@infradead.org>
 <55A7A6CD.4080900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A7A6CD.4080900-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

the point is that there is no driver that even set the is_switch
flag in-tree and I can't find a publicly available one elsewhere
either.

So it's plain and simple dead code.  I'll send a patch to kill this
untestable code off once I find a little spare time.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
