From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 5/6] IB/core: Take into account optional
 UDR, XRC headers and mandatory ICRC for RoCE MTU
Date: Wed, 18 Oct 2017 11:13:14 -0400
Message-ID: <1508339594.46071.73.camel@redhat.com>
References: <20171016054517.30643-1-leon@kernel.org>
         <20171016054517.30643-6-leon@kernel.org>
         <20171017111228.GO2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017111228.GO2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-17 at 14:12 +0300, Leon Romanovsky wrote:
> On Mon, Oct 16, 2017 at 08:45:16AM +0300, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > This fix considers optional UDP, XRC header sizes and mandatory
> > ICRC 4 bytes in
> > calculation of path MTU, by considering additional 8 bytes, path
> > MTU calculation
> > is more accurate.
> > 
> > Link: https://www.spinics.net/lists/linux-rdma/msg54558.html
> > Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE
> > devices")
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  include/rdma/ib_addr.h |  7 ++++---
> >  include/rdma/ib_pack.h | 19 +++++++++++--------
> >  2 files changed, 15 insertions(+), 11 deletions(-)
> > 
> 
> Doug,
> 
> The title should be "... optional UDP .." and not as I wrote.
> 
> Resubmit one patch/whole series/do nothing?

I'll fix it up.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
