From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3 TRIVIAL] IB/core: Documentation fix to
 ib_mad_snoop_handler in the MAD header file
Date: Tue, 5 Jan 2016 21:56:44 +0200
Message-ID: <CAJ3xEMgw9Y9sX=4_hZvhDcPaQ53ss5CgLO4R-LYrYXqDiLvosw@mail.gmail.com>
References: <568B98A6.3010908@dev.mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A82373AAFF512F@ORSMSX109.amr.corp.intel.com>
	<568C1028.3090309@dev.mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A82373AAFF51A5@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFF51A5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 5, 2016 at 9:00 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > There are no in tree users and the only attempt at adding one was
>> rejected.
>>
>> There are no in tree users of this but there is your madeye tool (which
>> is out of tree). This is still a useful debug tool for MADs and there
>> are people who still use that.
>
> It's an out of tree tool.  Maintain the snooping hooks into the mad layer out of tree as well.

Any real reason not to pick this good tool into the kernel code?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
