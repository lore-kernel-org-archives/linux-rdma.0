From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core] debian: Squash changelog to be one entry
Date: Wed, 29 Mar 2017 23:13:15 +0200
Message-ID: <1490821995.2798.7.camel@profitbricks.com>
References: <20170329135304.11764-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329135304.11764-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Am Mittwoch, den 29.03.2017, 16:53 +0300 schrieb Leon Romanovsky:
> The debian's changelog is managed outside of rdma-core upstream
> package
> and hence there is no need to add entry to it, just update version
> only.

Exactly.

> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  debian/changelog | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 5a323cef..37cd5b51 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,10 +1,4 @@
>  rdma-core (14-1) unstable; urgency=low
> -
> -  * Bump version.
> -
> - -- Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  Sat, 25 Mar 2017 14:29:00
> -0600
> -
> -rdma-core (13-1) unstable; urgency=low
>    * New version.
>    * Adding debian/copyright.
>    * Close ITP (Closes: #848971).

Please add a newline between the first line and the first bullet point.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:  http://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
