From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Is ib_mtu iboe_get_mtu() slightly off?
Date: Mon, 09 Oct 2017 12:14:12 -0400
Message-ID: <1507565652.46071.33.camel@redhat.com>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
         <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <1507556073.46071.27.camel@redhat.com>
         <20171009134131.GB1252@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009134131.GB1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-10-09 at 16:41 +0300, Leon Romanovsky wrote:
> On Mon, Oct 09, 2017 at 09:34:33AM -0400, Doug Ledford wrote:
> > 
> > Since no one rolled a patch for this, I did.
> > 
> 
> Doug,
> 
> Parav created, I waited for our shared code.
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/c
> ommit/?h=rdma-next&id=51ed6735dd59008aea4d7308416ed994b277f168

Ok, but if the issue has been sitting on the list a while, and I don't
know a fix is coming, then there is a not-0 percent chance I'll just
fix it myself.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
