From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] debian: Update changelog to include Debian
 upload
Date: Tue, 14 Nov 2017 13:42:44 -0700
Message-ID: <20171114204244.GU4263@ziepe.ca>
References: <20171114113330.2715-1-benjamin.drung@profitbricks.com>
 <20171114113330.2715-4-benjamin.drung@profitbricks.com>
 <20171114202823.GQ4263@ziepe.ca>
 <1510691646.4026.50.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510691646.4026.50.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 09:34:06PM +0100, Benjamin Drung wrote:

> I can often find debian packaging from upstream projects that either
> use their complete own packaging or a very outdated fork of the
> packaging from Debian.

But it creates a technical problem, eg now that you are going to make
a -2, where will the changelog commit go?

Ideally the changelog commit should match the actual git tree that was
used to produce the debian source tar ball. Otherwise things start to
get very confusing :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
