From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core] debian: Adding uploaders field
Date: Wed, 01 Mar 2017 20:41:00 +0100
Message-ID: <1488397260.3275.5.camel@profitbricks.com>
References: <20170301122349.22634-1-talatb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301122349.22634-1-talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bdrung-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Am Mittwoch, den 01.03.2017, 14:23 +0200 schrieb Talat Batheesh:
> Issue: None
> Change-Id: I4d5c5ab493974d7be537d83f3a8efa5cdb160679
> Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  debian/control | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/debian/control b/debian/control
> index 4033dd8..55f7f50 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -1,5 +1,9 @@
>  Source: rdma-core
>  Maintainer: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> +Uploaders:
> + Benjamin Drung <bdrung-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>,
> + Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
> + Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  Section: net
>  Priority: extra
>  Build-Depends: cmake (>= 2.8.11),

Please use my work email address here: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org

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
