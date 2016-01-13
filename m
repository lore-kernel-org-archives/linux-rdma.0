From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-4.5] iw_cxgb4: Take clip reference first, before creating IPv6 listening servers
Date: Wed, 13 Jan 2016 08:45:28 -0600
Message-ID: <006501d14e11$0b5315a0$21f940e0$@opengridcomputing.com>
References: <1452659594-7875-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452659594-7875-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hariprasad Shenai
> Sent: Tuesday, January 12, 2016 10:33 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; Hariprasad Shenai
> Subject: [PATCH for-4.5] iw_cxgb4: Take clip reference first, before creating IPv6 listening servers
> 
> The h/w is designed in such a way that, if you do anything IPv6
> related, a valid clip entry must be there. So take clip reference
> before creating IPv6 listening servers, and then if we fail to
> create server, release the clip entry.
> 
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
