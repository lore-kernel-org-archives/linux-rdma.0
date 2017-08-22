From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple user
 verbs
Date: Tue, 22 Aug 2017 14:11:27 -0400
Message-ID: <1503425487.78641.1.camel@redhat.com>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
         <1498572282-22370-2-git-send-email-Ram.Amrani@cavium.com>
         <20170628095422.GA1248@mtr-leonro.local>
         <BN3PR07MB25788193EFA21CEB5C430201F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <20170628101124.GD1248@mtr-leonro.local>
         <CY1PR0701MB1337A8E7B1E40CC4C1EC230A90DD0@CY1PR0701MB1337.namprd07.prod.outlook.com>
         <1503068404.2598.9.camel@redhat.com>
         <20170818155808.GN23648@mtr-leonro.local>
         <1503072465.2598.19.camel@redhat.com>
         <20170822124012.GY1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822124012.GY1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-22 at 15:40 +0300, Leon Romanovsky wrote:
> > > Yes, let's me recheck/rerun the patch and post results.
> > > If for any reasons you don't hear from me till Wednesday, take
> it.
> > >
> > > Thanks
> >
> > Works for me, thanks.
> 
> The series worked for us and we didn't encounter unknown failures.
> 
> Thanks

Patch applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
