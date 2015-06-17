From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 39/49] IB/hfi1: add sysfs routines
Date: Wed, 17 Jun 2015 18:50:39 +0300
Message-ID: <CAJ3xEMjdhyk2OOfeCV4sZMF=Fh06H-hJn_2y85V0eBLYBBgPiA@mail.gmail.com>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com>
	<20150615132929.29741.87559.stgit@phlsvslse11.ph.intel.com>
	<CAJ3xEMiiqY04q4pnjRSm=7UBnS_jQJP-KhAkYEvu7FAu-F98sA@mail.gmail.com>
	<CAJ3xEMiJ_0pFUvPJN7ov50v0hOZVsN7qC27ZbG5+pfmVuZQuMw@mail.gmail.com>
	<32E1700B9017364D9B60AED9960492BC257513D9@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC257513D9-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 17, 2015 at 2:48 PM, Marciniszyn, Mike
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> what's SC and what's SC-to-VL? aren't you using SM to do such mappings? if this
>> and the below sysfs work-around/s for the maybe current lack of SM to
>> configure the port? why do the upstream kernel has to carry ~hundreds of sysfs
>> entries forever for such non-documented things?

> This sysfs entries are used by PSM2 to form packets from user space.

You didn't explain what's SC and what's SC-to-VL and why PSM2 can't
talk to the SM to query that.

>> >> +HFI1_SL2SC_ATTR(0);
>>
>> same comment on SL2SC

same response as the above

>> >> +HFI1_VL2MTU_ATTR(0);

>> same comment on VL2MTU, why in sysfs?!

> Same answer.

same response as the above

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
