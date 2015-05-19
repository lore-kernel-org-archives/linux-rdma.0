From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Tue, 19 May 2015 21:30:03 +0300
Message-ID: <CAJ3xEMhkpYYtzrsOw=8JQOekpVT6xQC9P2itH3H3oAjjPfWrng@mail.gmail.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
	<1431975616-23529-4-git-send-email-kaike.wan@intel.com>
	<555AC36D.5050904@mellanox.com>
	<3F128C9216C9B84BB6ED23EF16290AFB0CAB243E@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CAB243E-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 3:24 PM, Wan, Kaike <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On 5/18/2015 10:00 PM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

>> > --- a/drivers/infiniband/core/sa_query.c
>> > +++ b/drivers/infiniband/core/sa_query.c
>> > @@ -45,12 +45,22 @@

>> what's actually the role of the module param? why it belongs here? is that
>> really unavoidable to have it?

> It's nice to provide the capability for the user to adjust the netlink timeout based his/her fabric setup.

NO, adding module params should be really your last resort when
everything else wouldn't work, definitely not the case here, remove
it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
