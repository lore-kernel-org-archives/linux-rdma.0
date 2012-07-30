From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/qib: Add support for per-device/per-port parameters
Date: Mon, 30 Jul 2012 11:22:58 -0700
Message-ID: <CAL1RGDV3YjyDTzXcR3f5z9RJhd1-vC-BDbJvp7kkwqt-GF9zgQ@mail.gmail.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
 <20120719130411.4706.88736.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDVb964pLxx=gvuvP5SWcXT2+g2pPssH6YRSq0LFhup7yA@mail.gmail.com>
 <CAJZOPZJaNiKqKWpT=Jj2fXKf-X+6wLXrqXGCc+d0oH8ZQsNsZA@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC0D47D8D1@FMSMSX108.amr.corp.intel.com>
 <CAJZOPZ+uK3c69ThX-Apwdj9cR2=XwNO4e7CVbmXYT4PuSPVKPA@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC0D47DA6B@FMSMSX108.amr.corp.intel.com> <32E1700B9017364D9B60AED9960492BC0D4810A2@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D4810A2-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 30, 2012 at 11:18 AM, Marciniszyn, Mike
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> In our case, we need to get parameters from user space to the kernel.
>
> There are other alternatives, like configfs that seem more suitable.
>
> Again, the key requirement is that the more flexible configuration must be available at module load as does the current module parameter patch.   If we enlist a user space helper to assist in passing the more flexible parameter, the lack of the helper cannot prevent the load of a module.

configfs or sysfs seem like a reasonably good fit.

Do you really need the configuration at the time of module load, or
would it work to tear down the device and reinitialize it if userspace
decides to update the configuration?  In other words, at module load
time, configure yourself with default parameters, and then if
userspace changes them, act like a hot unplug followed by a hot plug,
so you reinitialize your device from scratch.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
