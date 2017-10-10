From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Is ib_mtu iboe_get_mtu() slightly off?
Date: Tue, 10 Oct 2017 12:13:03 -0400
Message-ID: <1507651983.46071.59.camel@redhat.com>
References: <CAL1RGDX33tBR=x2sOp_F1605SY5nu_6YALr-XYE_LiuvsHQ1ng@mail.gmail.com>
         <VI1PR0502MB300886CB47BB3DFDE098A26AD1660@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <1507556073.46071.27.camel@redhat.com>
         <20171009134131.GB1252@mtr-leonro.local>
         <1507565652.46071.33.camel@redhat.com>
         <VI1PR0502MB3008900E038DEF6EEAB719DFD1740@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <c27ee8b9-a011-9b0b-b20a-433d9f74d4b1@redhat.com>
         <20171010153312.GD2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010153312.GD2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-10 at 18:33 +0300, Leon Romanovsky wrote:
> On Tue, Oct 10, 2017 at 10:48:01AM -0400, Doug Ledford wrote:
> > On 10/9/2017 4:47 PM, Parav Pandit wrote:
> > 
> > > Sorry for not ACKing that I was doing it last week.
> > > If possible, please pick the one that Leon is sending because
> > > instead of doing calculation in half comment based and half
> > > defined based code,
> > > my patch defines all necessary header sizes in calculation,
> > > little clean way.
> > 
> > In this instance we are lucky that 0day testing was being slow
> > yesterday
> > or else this would already be pushed to k.o.  Since it's not, I can
> > drop
> > my patch and take yours.
> 
> Did you post your patch for review and gave enough time to
> participants
> to provide the feedback, before pushing it to your k.o.?

I posted it proir to pushing it to k.o, and it was based on the thread
as it stood with about a weeks worth of time for people to comment.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
