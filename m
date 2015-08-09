From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Remove some sysfs files
Date: Sun, 9 Aug 2015 12:40:16 +0300
Message-ID: <CAJ3xEMiz-d3nst2D8Q_Fs9hG++-XDj6G9FbsmFcxd5bEeXteSg@mail.gmail.com>
References: <20150807133610.12421.73468.stgit@phlsvslse11.ph.intel.com>
	<alpine.DEB.2.11.1508070948510.14626@east.gentwo.org>
	<32E1700B9017364D9B60AED9960492BC2577B0B5@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2577B0B5-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 7, 2015 at 7:43 PM, Marciniszyn, Mike
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> Could you get some experienced engineers to look at the driver internally to
>> Intel before publishing? There are numerous other drivers in the kernel by
>> Intel that do the right thing.

> I will try to get a review from internal engineers.

In the latest posted you made a note on 125 changes done as of
internal review but didn't spare
a word on the nature/content of these changes. There's no way to
realize from your V4 cover letter if these
changes made things better and in what direction.

I checked and none of the 24 authors of the OPA driver is among the
222 over-git-history committers
of all drivers under drivers/net/ethernet/intel
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
