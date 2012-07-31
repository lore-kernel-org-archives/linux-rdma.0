From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/qib: Add support for per-device/per-port
 parameters
Date: Tue, 31 Jul 2012 15:57:35 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D481515@FMSMSX108.amr.corp.intel.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
 <20120719130411.4706.88736.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDVb964pLxx=gvuvP5SWcXT2+g2pPssH6YRSq0LFhup7yA@mail.gmail.com>
 <CAJZOPZJaNiKqKWpT=Jj2fXKf-X+6wLXrqXGCc+d0oH8ZQsNsZA@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC0D47D8D1@FMSMSX108.amr.corp.intel.com>
 <CAJZOPZ+uK3c69ThX-Apwdj9cR2=XwNO4e7CVbmXYT4PuSPVKPA@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC0D47DA6B@FMSMSX108.amr.corp.intel.com>
 <32E1700B9017364D9B60AED9960492BC0D4810A2@FMSMSX108.amr.corp.intel.com>
 <CAL1RGDV3YjyDTzXcR3f5z9RJhd1-vC-BDbJvp7kkwqt-GF9zgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV3YjyDTzXcR3f5z9RJhd1-vC-BDbJvp7kkwqt-GF9zgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> configfs or sysfs seem like a reasonably good fit.
> 

configfs would seem the more natural fit since user mode creates the files and the directory hierarchy naturally fits the ring down of global -> HCA ->port specialization.

> Do you really need the configuration at the time of module load, or would it
> work to tear down the device and reinitialize it if userspace decides to
> update the configuration?  In other words, at module load time, configure
> yourself with default parameters, and then if userspace changes them, act
> like a hot unplug followed by a hot plug, so you reinitialize your device from
> scratch.
> 

That is probably not possible.   I'm guessing it is better to react to a "configfs" module parameter to wait on a completion and a "commit" configfs global attribute to release the driver to complete its initialization with a complete call once user mode has setup the attributes critical for initialization.   Without setting configfs, qib would load as it currently does.

It sure would be nice if there was a way to buffer keyed attribute information before a module is loaded and then provide an interface to read it when a module is initializing.

Mike




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
