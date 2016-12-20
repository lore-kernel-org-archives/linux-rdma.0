From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Add Connect-X5 device ID to device white
 lists
Date: Tue, 20 Dec 2016 11:40:38 -0500
Message-ID: <9625766b-9c87-3905-d35c-e14e3ddc3653@dev.mellanox.co.il>
References: <cb54fa49-84fb-3d2f-6431-e6b513b6fb46@dev.mellanox.co.il>
 <CAJ3xEMif-e63QZsJ025+O8T=ow6Rq-5sO9QvK8cC9wXYy7pnRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMif-e63QZsJ025+O8T=ow6Rq-5sO9QvK8cC9wXYy7pnRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/20/2016 2:25 AM, Or Gerlitz wrote:
> What is the semantics of the white-list?

The white lists control the issuing/checking of several Mellanox vendor
specific MADs such as SM class MLNX ExtendedPortInfo (MEPI) which
handles FDR10 and vendor class 0x0A GeneralInfo interpretation as to
whether extended version fields are supported.

> What happens if you see a device which is not there?

It will affect FDR10 reporting or version reporting done via Mellanox
vendor specific MADs.

Do you see any that you think are missing ?

> Why do we need this list?

To know whether MEPI can be issued or not without timeout and to
properly interpret the version fields in the GeneralInfo response.

-- Hal

> Or.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
