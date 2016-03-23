From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 23 Mar 2016 12:57:08 +0200
Message-ID: <20160323105708.GP25216@leon.nu>
References: <56EAE9D6.2030908@redhat.com>
 <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg@mail.gmail.com>
 <20160318173748.GL25216@leon.nu>
 <CA+55aFwNcyywn3gYQ=H_+6WMt=s+xZ5bgpX3O9z8b2o5EhDMGQ@mail.gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwNcyywn3gYQ=H_+6WMt=s+xZ5bgpX3O9z8b2o5EhDMGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 19, 2016 at 02:37:08PM -0700, Linus Torvalds wrote:
> So the *best* situation would be:
> 
>  - your two groups talk it over, and figure out what the common commits are
> 
>  - you put those common commits as a "base" branch in git
> 
>  - you ask the two upper-level maintainers to both pull that base branch
> 
>  - you then make sure that you send the later patches (whether as
> emailed patches or as pull requests) based on top of that base branch.

Hi David and Doug,

Are you OK with the approach suggested by Linus?
We are eager to know it, so we will adopt it as soon
as possible in our development flow.

The original thread [1].

[1] http://thread.gmane.org/gmane.linux.drivers.rdma/34907

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
