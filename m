From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Fix race between uverbs_close
 and remove_one
Date: Tue, 2 Aug 2016 13:26:47 -0600
Message-ID: <20160802192647.GB20709@obsidianresearch.com>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
 <1467548899-21923-2-git-send-email-leon@kernel.org>
 <1470162706.18081.27.camel@redhat.com>
 <CALq1K=LUb+bvx5+3JYLQw+OnhzP5MuqmuydMS8G7eS8Kvyb9Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALq1K=LUb+bvx5+3JYLQw+OnhzP5MuqmuydMS8G7eS8Kvyb9Ow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 02, 2016 at 09:50:14PM +0300, Leon Romanovsky wrote:
> > The only reason I hadn't taken this patch before is because Jason said
> > it was totally untested and someone (Devesh in this case) needed to
> > test it to make sure it resolved their problem.  I don't see a test-by
> > line here, so has this happened?
> 
> I can't say about Devesh, but we verified it as part of our verification phase.
> Do you need anything special except Yishai's SOB?

I was hoping to see Devesh confirm that the race he was able to
reproduce is in fact closed, unless Mellanox did the reproduction?

At least your testing shows it doesn't make things worse, so it is
probably OK to go ahead if Devesh does not respond soon.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
