From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [rdma-core v2 0/9] Broadcom User Space RoCE Driver
Date: Tue, 21 Feb 2017 22:08:04 -0700
Message-ID: <20170222050804.GA29755@obsidianresearch.com>
References: <1487432638-19607-1-git-send-email-devesh.sharma@broadcom.com>
 <20170221195053.GG13138@obsidianresearch.com>
 <CANjDDBi7bvYMvnjgsdSXzj6ot2wJS+w1nRCp-26TgEEpE38vfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBi7bvYMvnjgsdSXzj6ot2wJS+w1nRCp-26TgEEpE38vfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 22, 2017 at 08:52:17AM +0530, Devesh Sharma wrote:
> > It still doesn't compile, please make sure everything is travis clean
> > before submitting..
> 
> I could not find travis package, thus could not gave it try before
> submitting v2. I will give it a shot again.

To run travis you need to install docker and run

$ buildlib/cbuild build-images travis

Then you can run:

> > $ buildlib/cbuild pkg travis

Which emulates travis locally.

Real travis only runs once you create a PR in github.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
