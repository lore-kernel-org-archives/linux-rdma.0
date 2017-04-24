From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 03/12] IB/ocrdma: Improve size determinations in ten
 functions
Date: Mon, 24 Apr 2017 12:38:22 -0400
Message-ID: <1493051902.3041.51.camel@redhat.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
         <1492720999.3041.18.camel@redhat.com>
         <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
         <755f6c2c-03a2-7248-a5e3-9190d119cdaf@users.sourceforge.net>
         <20170423073311.GA14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170423073311.GA14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-04-23 at 10:33 +0300, Leon Romanovsky wrote:
> On Sat, Apr 22, 2017 at 04:36:19PM +0200, SF Markus Elfring wrote:
> > 
> > From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> > Date: Sat, 22 Apr 2017 13:26:49 +0200
> > 
> > Replace the specification of data types by pointer dereferences
> > as the parameter for the operator "sizeof" to make the
> > corresponding size
> > determinations a bit safer according to the Linux coding style
> > convention.
> > 
> > Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> > ---
> > 
> > v2:
> > Changes were rebased on source files from Linux next-20170421.
> > These were recombined as requested by Doug Ledford.
> 
> Hi Doug,
> 
> I recommend you to be extra cautious with this blind automatic
> conversions. It requires inspection that every size before and after
> match each other.
> 
> I already asked it and would be like to repeat it. Please DON'T take
> any
> patches from Markus, which are related to mlx4/mlx5/rxe without our
> explicit
> review of them.

OK, the easiest way to make sure that only the things you want from his
patches get through is to have you pull them into a branch and submit
them yourself.  I'll only take the ones you submit to me, that way
there is no confusion about whether or not you have checked them and
approved them.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
