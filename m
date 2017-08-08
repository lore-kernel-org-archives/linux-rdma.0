From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 0/7] Automatic affinity settings for nvme-rdma
Date: Tue, 08 Aug 2017 15:14:36 -0400
Message-ID: <1502219676.3002.11.camel@redhat.com>
References: <1499933384-17407-1-git-send-email-sagi@grimberg.me>
         <20170713082041.GK1528@mtr-leonro.local>
         <d3e93dfa-79c0-22c5-eacd-a8699b924de8@grimberg.me>
         <20170713085700.GL1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713085700.GL1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-13 at 11:57 +0300, Leon Romanovsky wrote:
> On Thu, Jul 13, 2017 at 11:28:22AM +0300, Sagi Grimberg wrote:
> > 
> > > > Doug, please consider this patch set for inclusion.
> > > 
> > > On which branch did you base your code?
> > 
> > Linus 4.12 + block tree updates.
> 
> Thanks

Hi Sagi,

I've pulled this into a branch and pushed it to my github for 0day
testing.  There were a number of conflicts, so please double check that
my branch is resolved out the way you want.  Thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
