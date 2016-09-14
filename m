From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC rdma-next 0/3] Move mlx5 vendor specific to UAPI directory
Date: Wed, 14 Sep 2016 15:46:07 -0400 (EDT)
Message-ID: <1495514480.6044744.1473882367077.JavaMail.zimbra@redhat.com>
References: <1473841649-8923-1-git-send-email-leon@kernel.org> <20160914172145.GI16014@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160914172145.GI16014-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Jason Gunthorpe" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Wednesday, September 14, 2016 1:21:45 PM
> Subject: Re: [RFC rdma-next 0/3] Move mlx5 vendor specific to UAPI directory
> 
> On Wed, Sep 14, 2016 at 11:27:26AM +0300, Leon Romanovsky wrote:
> > The consolidate library revealed the fact that vendor specific
> > structures and defines are copy/pasted between kernel and user-space,
> > instead of sharing.
> > 
> > This RFC was tested by compilation only and not-ready for merge yet.
> 
> Yah, this is exactly what I had in mind. We need to give this
> treatment to all the drivers :|
> 
> > Leon Romanovsky (3):
> >   IB/mlx5: Move and decouple user vendor structures
> >   IB/core: Export mlx5 vendor specific strucutres
> >   MAINTAINERS: Add mlx5 uapi file
> 
> One patch is probably enough, 3 patches per driver is going to be
> alot.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Leon, I have not kept up with testing all the mlx5 changes and latest patches.
Going to wait until this settles then will take snapshot and start testing.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
