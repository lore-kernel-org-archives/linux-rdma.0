From: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: NFSoRDMA developers bi-weekly meeting minutes (6/25)
Date: Thu, 3 Jul 2014 12:14:38 +0000
Message-ID: <d3d3fd3f6f1c44159f0e6b9d19a622eb@DB4PR05MB461.eurprd05.prod.outlook.com>
References: <53B42F2A.9060205@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B42F2A.9060205-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Shirley,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Shirley Ma
> Sent: Wednesday, July 02, 2014 19:11
> To: linux-rdma; Linux NFS Mailing List; Rupert Dance; Chuck Lever; Doug
> Ledford; Anna Schumaker; Steve Wise; Steve Dickson
> Subject: NFSoRDMA developers bi-weekly meeting minutes (6/25)
> 
> 
> 6. NFSoRDMA virtualization doesn't work. Shirley found that VF FRMR
> reported port error after a successful post_send on connextX-2. It didn't seem
> an NFSoRDMA issue. Questions are whether VF FRMR is fully tested. Later Yan
> confirmed VF FRMR doesn't work for NFSoRDMA on connectX-3 either.
> 

Apparently there has been a misunderstanding. I did not confirm that VF FRMR does not work.
Actually I use FRMR on VF all the time (not with NFSoRDMA apparently). You can check if FRMR works for you by running krping.

Regards,
Yan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
