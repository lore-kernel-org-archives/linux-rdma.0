From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 2/2] cxgb4/rdma: configure 0B MRs to match HW implementation
Date: Thu, 16 Oct 2014 09:17:33 -0500
Message-ID: <001e01cfe94b$ed6aeb60$c840c220$@opengridcomputing.com>
References: <1413452189-5427-1-git-send-email-pramod@chelsio.com> <1413452189-5427-3-git-send-email-pramod@chelsio.com> <543F9C7D.8010401@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <543F9C7D.8010401-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Pramod Kumar' <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Or Gerlitz [mailto:ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Thursday, October 16, 2014 5:23 AM
> To: Pramod Kumar
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> Subject: Re: [PATCH 2/2] cxgb4/rdma: configure 0B MRs to match HW implementation
> 
> 
> On 10/16/2014 12:36 PM, Pramod Kumar wrote:
> > 0B MRs need some tweaks to work correctly with HW.
> 
>   What's the use case?

The dapltest tool does this if you run the transaction test and do 0B IO. A customer discovered the issue.

Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
