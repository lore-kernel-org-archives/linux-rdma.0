From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/iser: fix connection teardown race condition
Date: Thu, 01 Jun 2017 16:22:22 -0400
Message-ID: <1496348542.7171.53.camel@redhat.com>
References: <1495113381-15564-1-git-send-email-vladimirn@mellanox.com>
         <1495113381-15564-2-git-send-email-vladimirn@mellanox.com>
         <18c0959d-af48-6db6-68df-ebbe2ef68731@intel.com>
         <20170519034836.GF3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170519034836.GF3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-05-19 at 06:48 +0300, Leon Romanovsky wrote:
> On Thu, May 18, 2017 at 04:12:33PM -0400, Dennis Dalessandro wrote:
> > 
> > On 5/18/2017 9:16 AM, Vladimir Neyelov wrote:
> > > 
> > > From: root <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > root? Might want to check your git config.
> 
> It is not the only one issue, I counted 6 violations of our internal
> policy/guidelines.

Is Mellanox planning to address the internal policy issues and
resubmit, or do you want me to munge out the root entry and take this
patch as it is?

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
