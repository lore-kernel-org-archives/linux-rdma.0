From: "Vipul Pandya" <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: RE: Query regarding which tree to use to create upstream patches
Date: Sat, 15 Oct 2011 08:07:43 -0700
Message-ID: <8A71B368A89016469F72CD08050AD3340A3D2A2B@maui.asicdesigners.com>
References: <8A71B368A89016469F72CD08050AD3340A3D28AE@maui.asicdesigners.com> <CAL1RGDVWCmSb5JMZEssAQ8Y_OQSiy-OgRmc1mkk9NRgz2XPDhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Kumar A S <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dimitrios Michailidis <dm-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Please see my response inline.

Thanks,
Vipul

-----Original Message-----
From: Roland Dreier [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] 
Sent: 14 October 2011 23:06
To: Vipul Pandya
Cc: Steve Wise; Kumar A S; Dimitrios Michailidis; Divy Le Ray;
linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Query regarding which tree to use to create upstream
patches

On Fri, Oct 14, 2011 at 8:54 AM, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:
> 1) We make our patch series against 'linux-next' tree (which has
> 'drivers/net' directory changes and latest changes from 'infiniband'
tree)
> and submit them to you and you can accordingly decide when to merge
them in
> your tree.

This seems fine.  I can review the patches, and then merge them for
upstream once net-next hits Linus's tree.

(I assume the cxgb4 net driver changes are already in net-next for 3.2?)

[VIPUL] Cxgb4 net driver changes are not already there in net-next for
3.2. We are thinking to submit iw_cxgb4 and cxgb4 driver changes to you
since cxgb4 driver changes are required to build iw_cxgb4 driver.
Probably then you would like to submit cxgb4 net driver changes to Dev
Miller for review and inclusion in his net-next tree.  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
