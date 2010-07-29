From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rds-tools issue starting with OFED-1.5.2-20100718-0600.tgz
Date: Thu, 29 Jul 2010 10:08:48 +0300
Message-ID: <4C512900.2050107@dev.mellanox.co.il>
References: <1280264327.4816.18.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280264327.4816.18.camel-mgfCWIlwujvg4c9jKm7R2O1ftBKYq+Ku@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jim Schutt wrote:
snip
>  rds-tools:
> -http://www.openfabrics.org/~vlad/ofed_1_5/rds-tools/rds-tools-1.5-1.src.rpm
> +http://www.openfabrics.org/downloads/rds-tools/rds-tools-2.0.3.tar.gz
>  
> 
> 
> It also looks like, from 
>   http://oss.oracle.com/git/?p=agrover/rds-tools.git;a=summary
> 
> that rds-tools now builds into two RPMs, rds-tools and rds-devel,
> but the OFED build scripts don't seem to know about that change.
> 
> I'd like to learn how to write apps that use RDS, so I thought
> I needed rds.h to compile against, in hopes of running against the
> latest upstream kernel RDS.  But, I can't seem to get it from
> the 1.5.2 daily snapshot, as a rds-devel rpm isn't getting installed.
> 
> Is there somewhere else to get the appropriate rds.h from?
> 
> Thanks -- Jim
> 

Hi Jim,
Thank you for reporting this issue.
I added rds-devel support to OFED-1.5.2. It will be available in today's daily build.

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
