From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Tue, 6 Sep 2016 20:35:56 +0000
Message-ID: <VI1PR0501MB24290102DD3246F0CA965746C4F90@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <CAHC9VhTEOvZ76dNJp35WEhr+r84eZZ6_ZmuaznGLakzZGcXhUw@mail.gmail.com>
 <20160830074607.GN594@leon.nu>
 <CAHC9VhRUmbsuV40rRpG+LeNUgY7rVqOkt-fxTMAFDRRdLvEkug@mail.gmail.com>
 <VI1PR0501MB242949202A1DA23E5C8E1E8AC4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <20160830184633.GE7586@obsidianresearch.com>
 <VI1PR0501MB2429992B1165DFADC6A6C35AC4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <20160830185548.GA9768@obsidianresearch.com>
 <VI1PR0501MB242974DEE5E0BF2FFE3A5DA0C4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <20160901163418.GA6479@obsidianresearch.com>
 <CAHC9VhR-u-ZXMeLkZL7y3=DJP5XaH7CxcZ=b5z67wVwhaPcUhQ@mail.gmail.com>
 <20160906200221.GE28416@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/6/2016 3:02 PM, Jason Gunthorpe wrote:
> On Thu, Sep 01, 2016 at 02:06:46PM -0400, Paul Moore wrote:
>
>> Jason and/or Daniel, I think it would be helpful if you could explain
>> both the InifiniBand and IP based approaches for those of us who know
>> SELinux, but not necessarily the RDMA and InfiniBand portions of this
>> discussion.  Be verbose and explain it as if we were idiots (I get
>> called that enough, it must be true).
> Well, I'm not really familiar with SELinux, I know a little bit about
> how labels are applied in the netstack, but not that much...
>
> The RDMA subsystem supports 4 different networking standards, and they
> each have their own objects..
>
> Just focusing on the pkey/vlan ideas. Every packet placed on the
> network has either a pkey or vlan label, the networking switches and
> receivers use these labels to create strong access control.
>
> The labels are not-global, they are isolated to a site, or even a
> single network within a site.
>
> ipoib also uses pkey&vlan in the same way netdev does (with these
> patches it looks like a userspace can still access a pkey via ipoib
> even if selinux is restricting access to it).
>
> Daniel's patch also touched on the QP1 and QP0 concepts. Packets can
> be labeled as being for QP0/1 and the recievers process them under the
> assumption they were sent by something with privilege (eg like the low
> port numbers in IP)
>
> So, from my perspective, we shouldn't be talking about doing pkey
> without also addressing vlan. It sounds like Daniel's concern is how to
> identify the number space (eg he is using a GID prefix for IB, which
> won't work on anything else, maybe rdma device handle is a better choice)
>
> Jason
>
I think to control access to a VLAN for RoCE there would have to labels for GIDs, since that's how you select which VLAN to use.  It'd be very similar to how the pkey labels works, but it doesn't help with Infiniband, so I think the pkey labeling scheme is still required.  RDMA device handle labeling isn't granular enough for what I'm trying to accomplish.  We want users with different levels of permission to be able to use the same device, but restrict who they can communicate with by isolating them to separate partitions.


_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
