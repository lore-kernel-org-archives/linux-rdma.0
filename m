From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Thu, 29 Sep 2016 16:41:46 -0600
Message-ID: <20160929224146.GE27229@obsidianresearch.com>
References: <20160830184633.GE7586@obsidianresearch.com>
 <VI1PR0501MB2429992B1165DFADC6A6C35AC4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <20160830185548.GA9768@obsidianresearch.com>
 <VI1PR0501MB242974DEE5E0BF2FFE3A5DA0C4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <20160901163418.GA6479@obsidianresearch.com>
 <CAHC9VhR-u-ZXMeLkZL7y3=DJP5XaH7CxcZ=b5z67wVwhaPcUhQ@mail.gmail.com>
 <20160906200221.GE28416@obsidianresearch.com>
 <CAHC9VhRXDMiK5V0rOQTvtZB0Q8jTX7XecGmAfRhm8oqF9aBaiw@mail.gmail.com>
 <VI1PR0501MB24299E036F1FCD335A2C2049C4C80@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <CAHC9VhShCgxonV1rN-J7LyezamzZtKNZ1SR7ywnTB9Kgia_u1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhShCgxonV1rN-J7LyezamzZtKNZ1SR7ywnTB9Kgia_u1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 06:16:03PM -0400, Paul Moore wrote:
> The queue pair (QP) concept lives in the RDMA layer and isn't tied to
> any particular transport.  They appear to be somewhat analogous to
> network sockets, although I'm guessing they can't be shared/passed
> between process like a network socket, yes?

Yes

> The IB partition is similar to a ethernet VLAN in that it providedes
> enforced separation across the network; IB uses partition keys, VLANs
> use tags/IDs.  IB partition keys are a 16 bit number,

> GIDs appear to be a 16 byte number created from some combination of
> IP address, MAC address, and VLAN ID.

There are several gid formats

IB/OPA: 128 bit IPv6 address
RoCEv1: Sort of a link local IPv6 (?), vlan is specified directly
        by apps
RoCEv2: Some sort of label that also implies a vlan tag

We also have iwarp vs rocee where AFAIK iwarp should get the vlan tag
from the IP socket that is allocated against the eth interface.

> In the case of RDMA over IB, we want to control QP access to
> partitions/pkeys; in the case of RDMA over ethernet we want to control
> QP access to VLANs/GIDs.

Broadly, yes, and I don't know what restriction iwarp would
need. Probably restrict access based on the eth device, but that will
probably need additional selinux checking in the rdma core.

There are also UD QPs which are like UDP sockets, so every address
handle creation will need a security check too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
