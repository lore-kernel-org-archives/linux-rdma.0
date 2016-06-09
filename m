From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 00/10] IB mlx5 fixes for 4.7
Date: Wed, 8 Jun 2016 21:49:57 -0400 (EDT)
Message-ID: <1859126386.41283730.1465436997407.JavaMail.zimbra@redhat.com>
References: <1465042537-26129-1-git-send-email-leon@kernel.org> <20160607081845.GF3663@leon.nu> <1915944393.40937640.1465309481061.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1915944393.40937640.1465309481061.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, June 7, 2016 10:24:41 AM
> Subject: Re: [PATCH rdma-rc 00/10] IB mlx5 fixes for 4.7
> 
> 
> 
> ----- Original Message -----
> > From: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Tuesday, June 7, 2016 4:18:45 AM
> > Subject: Re: [PATCH rdma-rc 00/10] IB mlx5 fixes for 4.7
> > 
> > On Sat, Jun 04, 2016 at 03:15:27PM +0300, Leon Romanovsky wrote:
> > > Hi Doug,
> > 
> > Hi Doug,
> > Can you please take this series together with core fixes? It will
> > allow us to base our rdma-next submissions on already merged code
> > without possible merge conflicts in mlx5.
> > 
> > Thanks
> > 
> I am also pulling these to test them
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Replying to my own email.

Applied all 10 to 4.7.0-rc1 and stress tested IB/srp over ConnectX-4 (mlx5) running at EDR 100.

For the series - IB mlx5 fixes for 4.7
Tested-by Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
