From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core V1 2/2] travis: Upload assets to github release
Date: Mon, 30 Jan 2017 14:16:58 -0700
Message-ID: <20170130211658.GC27111@obsidianresearch.com>
References: <20170130062316.16268-1-leon@kernel.org>
 <20170130062316.16268-3-leon@kernel.org>
 <20170130170956.GC29502@obsidianresearch.com>
 <20170130201953.GM6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170130201953.GM6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 30, 2017 at 10:19:53PM +0200, Leon Romanovsky wrote:

> > > +if [[ $TRAVIS_TAG == v* ]] && [ "$TRAVIS_OS_NAME" = "linux" ]; then
> > > +	# Let's create release for vX tags only.
> > > +	git archive --prefix rdma-core/ --output rdma-core-$TRAVIS_TAG.tar.gz HEAD
> >
> > Should be
> >
> >
> > I think..
> 
> I have no opinion about that, because I'm not going to use this tar.gz file.

Including the version in the directory is standard practice.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
