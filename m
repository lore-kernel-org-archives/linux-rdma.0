From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is
 unloaded while IO is in progress
Date: Wed, 1 Feb 2017 10:47:34 -0700
Message-ID: <CAANLjFpB8AgF_LdYMa5kqz2_RwjfSKMptQuBrb5TmOHBMXqDtA@mail.gmail.com>
References: <CY1PR12MB077405C1FA5279D200AD3089BC4D0@CY1PR12MB0774.namprd12.prod.outlook.com>
 <49223bb6-e2a1-eee7-cf4e-701957e6727f@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49223bb6-e2a1-eee7-cf4e-701957e6727f-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 1, 2017 at 8:17 AM, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> hi Raju,
> please apply the attached patch I want to push soon (still haven't find the
> chance to test it).
> I'm not sure it will solve your problem but let's try it.
>
> thanks,
> Max.

I tried this to see if it would help with my iser D state problem, but no luck.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
