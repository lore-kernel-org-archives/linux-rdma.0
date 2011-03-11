From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2] osmtest/SA client: Only set attribute offset for
 RMPPoperations
Date: Fri, 11 Mar 2011 12:08:52 +0200
Message-ID: <20110311100852.GX5577@calypso.voltaire.com>
References: <20100901214702.GA23755@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100901214702.GA23755-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: Sasha Khapyorsky <IMCEAEX-_O=VOLTAIRE+20ADVANCED+20DATA+20SECURITY_OU=VOLTAIRE_CN=RECIPIENTS_CN=SASHAK-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 00:47 Thu 02 Sep     , Hal Rosenstock wrote:
> 
> Most of what the osmtest SA client is doing is not RMPP.
> For example, any SA GetTable request is not an RMPP operation
> but is requesting an RMPP response.
> 
> SA AttributeOffset only needs to be set in an RMPP DATA packet
> so this is not needed on the requesting side.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes from v1:
> Added verbose description
> 

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
