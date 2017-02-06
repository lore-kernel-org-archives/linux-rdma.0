From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Mon, 6 Feb 2017 09:39:37 -0700
Message-ID: <20170206163937.GB14714@obsidianresearch.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <SN1PR07MB22070381E7566FA819E5F8F8F8400@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20170206114609.GK6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170206114609.GK6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 06, 2017 at 01:46:09PM +0200, Leon Romanovsky wrote:
> On Mon, Feb 06, 2017 at 10:56:56AM +0000, Amrani, Ram wrote:
> > > This patchset from Leon adds direct access to mlx5 devices.
> > >
> > > The libibverbs API is an abstract API. It is agnostic to any underlying
> > > provider specific implementation. While this abstraction has the advantage of
> > > user applications portability it has a performance penalty. For some
> > > applications optimizing performance is more important than portability.
> > >
> > > The mlx5 direct verbs API introduced in this patchset is intended for such
> > > applications. It exposes mlx5 specific low level data path
> > > (send/receive/completion) operations, allowing the application to bypass the
> > > libibverbs data path API.
> > >
> > > The proposed interface consists from small number of hardware specific headers
> > > with relevant inline functions and conversion logic from ibverbs structures to
> > > mlx5 related structures.
> > >

> > While I'm always for better performance, I'm not sure driver specific APIs is the way.
> > This will hurt portability for users.
> 
> As it was expressed in cover letter, this feature is intended for
> users who want performance and understand the disadvantages of such
> direct approach.

To expound on that - the trade off we discussed in-person was we
either do something like this or continually take endless
vendor-specific patches to add 'common' core code for unstandardized
chip-specific features.

This seemed like the least bad trade off, if another vendor wants the
same things then they could work together and make an actual
multi-chip common API. I was expecting this interface to be used in
only a few places, like the next level of middleware libraries
(libfabric, mxm, etc) not for many end-users.

I'm still not completely sure what this API is intended to do, if it is
really just performance then I am less supportive and would rather see
an approach like libfabric where a user can build a single provider verbs
with the same source API, but optimized....

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
