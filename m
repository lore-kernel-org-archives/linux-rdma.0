From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] nvmet-rdma: SRQ per completion vector
Date: Sat, 18 Nov 2017 14:52:29 +0200
Message-ID: <20171118125229.GT18825@mtr-leonro.local>
References: <1510852885-25519-1-git-send-email-maxg@mellanox.com>
 <263c6c9d-0dd2-da4f-12a9-efefd361e592@grimberg.me>
 <a8e2be0b-deb7-8cc1-92ce-fc5dea3e241a@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a8e2be0b-deb7-8cc1-92ce-fc5dea3e241a-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 17, 2017 at 09:32:42PM +0200, Max Gurtovoy wrote:
>
>
> On 11/16/2017 8:36 PM, Sagi Grimberg wrote:
> >
> > > Since there is an active discussion regarding the CQ pool
> > > architecture, I decided to push
> > > this feature (maybe it can be pushed before CQ pool).
> > >
> > > This is a new feature for NVMEoF RDMA target,
> >
> > Any chance having this for the rest? isert, srpt, svcrdma?
> >
>
> We can implement it for isert, but I think it's better to see how the CQ
> pool will be defined first.
> It can bring a big benefit and improvement for ib_srpt (similar to NVMEoF
> target) but I'm not sure if I can commit for that one soon..

Too bad, but I don't see inclusion of generic SRQ pool code in RDMA
subsystem without actual conversion of existing ULP clients.

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
