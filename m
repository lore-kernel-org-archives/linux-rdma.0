From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Tue, 31 Oct 2017 13:23:40 -0600
Message-ID: <20171031192340.GA18578@ziepe.ca>
References: <20171030230156.GA4081@ziepe.ca>
 <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171031042435.GB7961@ziepe.ca>
 <e2a2aa84-71ce-36f0-91af-0854b24d4a6a@dev.mellanox.co.il>
 <60de3bab-f294-dd11-bcae-d179115f7c31@mellanox.com>
 <20171031150901.GA9852@ziepe.ca>
 <20171031151521.GK16127@mtr-leonro.local>
 <5ab2d58d-8af8-c075-86f0-7010b8316cba@mellanox.com>
 <CALpBJjorS-AK3Ua9UuUnWv33rYqBoeAXF9vsFALTff5Qv3hNSg@mail.gmail.com>
 <fa1abfd0-e9fc-e842-8a21-c214e9dc8e9e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fa1abfd0-e9fc-e842-8a21-c214e9dc8e9e-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Tue, Oct 31, 2017 at 12:22 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Sounds like the crash is resolved and now you're getting a denial
> from a security module.  I looked in the code, it looks like

If Chris was hitting that crash it means his security module failed the
mad action, as that is the only way to trigger it.

> AppArmor doesn't register any callbacks for the ib_* security hooks,
> and if no hook is registered it should return 0.  Can you tell me
> more about your setup so I can create a reproducer? What OS are you
> using? Can you double check that SELinux isn't enabled (see output
> of sestatus).

Which suggests to me that apparmour is not working properly with the
rdma selinux patches??

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
