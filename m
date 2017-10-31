From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Tue, 31 Oct 2017 13:22:29 -0500
Message-ID: <fa1abfd0-e9fc-e842-8a21-c214e9dc8e9e@mellanox.com>
References: <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
 <20171030071956.GU16127@mtr-leonro.local>
 <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A@mail.gmail.com>
 <20171030230156.GA4081@ziepe.ca>
 <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171031042435.GB7961@ziepe.ca>
 <e2a2aa84-71ce-36f0-91af-0854b24d4a6a@dev.mellanox.co.il>
 <60de3bab-f294-dd11-bcae-d179115f7c31@mellanox.com>
 <20171031150901.GA9852@ziepe.ca> <20171031151521.GK16127@mtr-leonro.local>
 <5ab2d58d-8af8-c075-86f0-7010b8316cba@mellanox.com>
 <CALpBJjorS-AK3Ua9UuUnWv33rYqBoeAXF9vsFALTff5Qv3hNSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALpBJjorS-AK3Ua9UuUnWv33rYqBoeAXF9vsFALTff5Qv3hNSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/31/2017 12:49 PM, Chris Blake wrote:
> Hello All,
>
> I have installed the kernel with the mentioned patch, as well as
> CONFIG_SECURITY_INFINIBAND enabled. Sadly I am back to the issue where
> my compute node is reporting:
>
> kernel: infiniband mthca0: ib_post_send_mad error
>
> As soon as I roll back to a kernel with CONFIG_SECURITY_INFINIBAND
> disabled, the issue goes away and things work as expected.
>
> Regards,
> Chris Blake

Sounds like the crash is resolved and now you're getting a denial from a security module.  I looked in the code, it looks like AppArmor doesn't register any callbacks for the ib_* security hooks, and if no hook is registered it should return 0.  Can you tell me more about your setup so I can create a reproducer? What OS are you using? Can you double check that SELinux isn't enabled (see output of sestatus).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
