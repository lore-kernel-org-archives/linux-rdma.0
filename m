From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 5/9] selinux: Create policydb version for Infiniband
 support
Date: Fri, 22 Jul 2016 16:52:04 +0000
Message-ID: <AM4PR0501MB225730F35A2EAED6F53CCB46C40A0@AM4PR0501MB2257.eurprd05.prod.outlook.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
 <1468537011-20407-6-git-send-email-danielj@mellanox.com>
 <CAHC9VhTRQ_jvdOPn-eszzHkb1+HL7ySaM5qK2pgX=9GFdjOcpg@mail.gmail.com>
 <20160722164652.GA19770@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2016 11:47 AM, Jason Gunthorpe wrote:
> On Fri, Jul 22, 2016 at 12:29:25PM -0400, Paul Moore wrote:
>> We had a discussion about this in the last patchset and I think things
>> may have gotten confused.  From what I remember, according to the IB
>> developers the proper term is "end port"; if that is true, we probably
>> should use "end port", but I would prefer if we drop the underscore in
>> most of the places, e.g. "ib_endport" instead of "ib_end_port".
> Yes, the proper term is end port, (contrasted with switch port).
>
> Jason
>
I can add the 'end'.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
