From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Remove Red Hat-ism.
Date: Tue, 4 Dec 2012 11:11:31 -0700
Message-ID: <20121204181131.GC21196@obsidianresearch.com>
References: <1354566498-8364-1-git-send-email-jonstanley@gmail.com>
 <20121203223547.GA3410@obsidianresearch.com>
 <CALY6xnj_OYpQFiCSC4T3cY3yup6ZXXJR=QDDCaJN96gEyvFP5w@mail.gmail.com>
 <CAGH67wTvYvvgzYGggab4XDyHtT-3M3KFoojth64kLyJDeCk8=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGH67wTvYvvgzYGggab4XDyHtT-3M3KFoojth64kLyJDeCk8=w@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 04, 2012 at 08:31:19AM -0800, Garrett Cooper wrote:

> Calling ``newname=$(hostname)`` would be better (assuming that the
> network was setup enough where one could get this information).

Calling hostname is always preferred to mucking about with files in
/etc/. hostname never requires the network, hostname -f might
sometimes.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
