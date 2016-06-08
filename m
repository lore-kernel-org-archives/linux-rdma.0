From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Wed, 8 Jun 2016 12:40:13 -0500
Message-ID: <010001d1c1ac$cfe397f0$6faac7d0$@opengridcomputing.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com> <00ef01d1c1a6$07784730$1668d590$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00ef01d1c1a6$07784730$1668d590$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Soft RoCE resources:
> >
> > [1] https://github.com/SoftRoCE/librxe-dev librxe - source code in Github
> >
> > [2] https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home - Soft RoCE Wiki
> page
> 
> Hey Moni,
> 
> I'm trying to build librxe and it cannot find <rdma/ib_rxe.h>  Where does this
> file come from?
> 

Never mind. I see it is in include/uapi/rdma/

I guess that needs to be copied to /usr/include/rdma to build librxe...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
