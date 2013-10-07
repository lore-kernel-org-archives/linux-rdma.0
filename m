From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: Mellanox VPI
Date: Mon, 7 Oct 2013 08:04:54 +0400
Message-ID: <CACaajQu5C-Vb5iLC4V1+E3YiWgOWJAgmsDV__r_ZGDmam7=jRw@mail.gmail.com>
References: <CACaajQtgK1OC1_2QwY_DK7nnxcxCJh0sbs-fM7vvYjvEF8b5Zg@mail.gmail.com>
 <CAJZOPZJYc83JRc61LPG=--9VaM4DRWojsUFrhbjAcaGN7anSuQ@mail.gmail.com>
 <CACaajQsgXQm=0q9uHWxXQfRfwoFZHRFDfyMDYbee72ohpcSfmA@mail.gmail.com>
 <52511E5E.8090802@mellanox.com> <CACaajQu=xNfvnNZShVsy_wYk3D7WJERk7Yofgf_YiJHHCK6W3Q@mail.gmail.com>
 <20131006160208.679c1c2c@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131006160208.679c1c2c@jpm-OptiPlex-GX620>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/10/6 Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:
> You cannot have ETH and IB link layers existing on the same port at the
> same time.
>
> However, you can run IB applications over an ETH link layer by using
> RoCE (RDMA over Converged Ethernet). If you do:
>
>         ibv_devinfo
>
> on a host where an HCA has a port configured to an ETH link layer,
> you should see an entry for the ETH layer port.  Under that port
> number, you will see:
>
>         ...
>         link_layer:     Ethernet


Thanks, Jack, for answer.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
