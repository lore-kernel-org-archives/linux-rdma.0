From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/8] Introduce vector CALC support
Date: Thu, 17 Mar 2016 16:48:47 +0200
Message-ID: <20160317144847.GF25216@leon.nu>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
 <20160306104508.GB13396@leon.nu>
 <20160312101724.GB11383@leon.nu>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160312101724.GB11383-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 12, 2016 at 12:17:24PM +0200, Leon Romanovsky wrote:
> On Sun, Mar 06, 2016 at 12:45:08PM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 23, 2016 at 10:25:20AM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > 
> > > NET part (patches #1-3)
> > > * Patch #1 fixes ATOMIC capability mode. This change has  no impact on
> > > * the system, since MAX property is not in use for ATOMIC.
> > > * Patch #2 merges two device capability calls in one.
> > > * Patch #3 adds infrastructure to support vector CALC querying.
> > > 
> > > IB part (patches #4-8)
> > > * Patch #4 refactors device query code by eliminating the unnecessary zeroing
> > >   of variables
> > > * Patch #5 converts device capability mask from u32 to be u64 and support more
> > >   than 32 device capabilities.
> > 
> > Hi Doug,
> > Is it possible to accept the patches #1-5 which fix and refactor
> > code only?
> 
> Hi Doug,
> Your response will be greatly appreciated.

Hi Doug,
As a follow up to our phone conversation, the patches #1-5 has nothing
related to Vector CALC which is introduced in patch #6 only.

These patches perform simple refactoring and value extension which is
enough for Eli's SRIOV series.

The patches #6-8 will be respinned later with improved version of
Vector CALC.

Thanks.

> 
> > 
> > > * Patch #6 adds vector CALC device capability flag.
> > > * Patch #7 exports all possible supported operations.
> > > * Patch #8 advertises the mlx5 driver support of vector CALC.
> > 
> > Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
