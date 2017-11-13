From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Mon, 13 Nov 2017 11:47:56 -0600
Message-ID: <e985eec0-a820-114d-46c6-4a31cf6d891d@mellanox.com>
References: <20171030230156.GA4081@ziepe.ca>
 <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171031042435.GB7961@ziepe.ca>
 <e2a2aa84-71ce-36f0-91af-0854b24d4a6a@dev.mellanox.co.il>
 <60de3bab-f294-dd11-bcae-d179115f7c31@mellanox.com>
 <20171031150901.GA9852@ziepe.ca> <20171031151521.GK16127@mtr-leonro.local>
 <5ab2d58d-8af8-c075-86f0-7010b8316cba@mellanox.com>
 <CALpBJjorS-AK3Ua9UuUnWv33rYqBoeAXF9vsFALTff5Qv3hNSg@mail.gmail.com>
 <fa1abfd0-e9fc-e842-8a21-c214e9dc8e9e@mellanox.com>
 <20171031192340.GA18578@ziepe.ca>
 <799ce928-2e7c-7f60-951a-3a88544b7510@mellanox.com>
 <CALpBJjogf5ONOmMTr9Z8RQ_78aON=_zSSJ+K-_VQyRRXO6vkAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALpBJjogf5ONOmMTr9Z8RQ_78aON=_zSSJ+K-_VQyRRXO6vkAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/12/2017 5:38 PM, Chris Blake wrote:
> I will admit that I have little knowledge of apparmor, but from the
> above if "ib_post_send_mad error" is caused by apparmor as previously
> suggested, wouldn't disabling it resolve the issue?
>
> Let me know if you have any other things you would like me to test.

Hi Chris, I sent you a patch in a separate email that will isolate which check is failing. Can you try that and send me the output? Sorry to ask you to do this, I've still not been able to reproduce.

> Regards,
> Chris Blake


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
