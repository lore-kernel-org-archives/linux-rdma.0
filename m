From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core 11/21] debian: Remove infiniband-diags Depends
 from iwpmd
Date: Thu, 27 Jul 2017 15:37:11 +0200
Message-ID: <1501162631.4572.26.camel@profitbricks.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1500926429-31822-12-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-12-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Montag, den 24.07.2017, 14:00 -0600 schrieb Jason Gunthorpe:
> This was a copy and paste error.
> 
> Fixes: bba93a9ce37 ("Debian Packaging")
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  debian/control | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/debian/control b/debian/control
> index 34b275dfeb8c62..8434bbb23693f8 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -47,8 +47,7 @@ Description: InfiniBand Communication Manager
> Assistant (ACM)
>  
>  Package: iwpmd
>  Architecture: linux-any
> -Depends: infiniband-diags,
> -         lsb-base (>= 3.2-14~),
> +Depends: lsb-base (>= 3.2-14~),
>           ${misc:Depends},
>           ${shlibs:Depends}
>  Description: Userspace component for iWarp RDMA services

These reduced dependencies can go into one line now (you could run
'wrap-and-sort' to do it for you).

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
