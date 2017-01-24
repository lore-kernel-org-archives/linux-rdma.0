From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next V1 5/5] IB: Query port through the core instead of directly calling the driver handler
Date: Tue, 24 Jan 2017 09:35:31 -0600
Message-ID: <00ed01d27657$7f431220$7dc93660$@opengridcomputing.com>
References: <20170124110239.31555-1-leon@kernel.org> <20170124110239.31555-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170124110239.31555-6-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Parav Pandit' <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Shiraz Saleem' <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Adit Ranadive' <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, 'Michal Kalderon' <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Rajesh Borundia' <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH rdma-next V1 5/5] IB: Query port through the core instead of
> directly calling the driver handler
> 
> From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Change the drivers to call ib_query_port in their get port
> immutable handler instead of their own query port handler.
> 
> Doing this required to set the core cap flags of this device
> before the ib_query_port call is made, since the IB core might
> need these caps to serve the port query.
> 
> Drivers are ensured by the IB core that the port attributes passed
> to the port query verb implementation are zero, and hence we
> removed the zeroing from the drivers.
> 
> This patch doesn't add any new functionality.
> 
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cxgb* parts look fine.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
