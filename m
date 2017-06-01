From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/iser: fix connection teardown race condition
Date: Thu, 01 Jun 2017 19:00:38 -0400
Message-ID: <1496358038.7171.77.camel@redhat.com>
References: <1495113381-15564-1-git-send-email-vladimirn@mellanox.com>
         <1495113381-15564-2-git-send-email-vladimirn@mellanox.com>
         <18c0959d-af48-6db6-68df-ebbe2ef68731@intel.com>
         <20170519034836.GF3616@mtr-leonro.local>
         <1496348542.7171.53.camel@redhat.com>
         <20170601205727.GW5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170601205727.GW5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-01 at 23:57 +0300, Leon Romanovsky wrote:
> On Thu, Jun 01, 2017 at 04:22:22PM -0400, Doug Ledford wrote:
> > 
> > On Fri, 2017-05-19 at 06:48 +0300, Leon Romanovsky wrote:
> > > 
> > > On Thu, May 18, 2017 at 04:12:33PM -0400, Dennis Dalessandro
> > > wrote:
> > > > 
> > > > 
> > > > On 5/18/2017 9:16 AM, Vladimir Neyelov wrote:
> > > > > 
> > > > > 
> > > > > From: root <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > 
> > > > root? Might want to check your git config.
> > > 
> > > It is not the only one issue, I counted 6 violations of our
> > > internal
> > > policy/guidelines.
> > 
> > Is Mellanox planning to address the internal policy issues and
> > resubmit, or do you want me to munge out the root entry and take
> > this
> > patch as it is?
> 
> Doug,
> 
> I resubmitted it a long time ago. It was already reviewed by Sagi and
> Max.
> https://patchwork.kernel.org/patch/9739179/

Ah, I see.  You submitted it as rdma-next while the original was being
reviewed under -rc fixes.  That kept me from matching up the resubmit
with the original.  I'll drop the original.  Thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
