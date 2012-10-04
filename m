From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] OFED-3.5-rc2 is available
Date: Thu, 04 Oct 2012 17:49:28 +0200
Message-ID: <506DB008.5070209@dev.mellanox.co.il>
References: <506C5FBE.1080004@dev.mellanox.co.il> <506D5F5D.9050308@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506D5F5D.9050308-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/04/2012 12:05 PM, Sebastian Riemer wrote:
> Hi Vladimir,
>
> why do you put OFED together for a kernel nobody uses? Perhaps SLES and
> Red Hat do it like this but nobody else.
>

Hi Sebastian,
The point of OFED-3.5 was to provide an infrastructure to make the latest
upstream RDMA features be available and tested on Distros.
By the time the work started the latest upstream kernel version
was 3.5-rc3 and, therefore, we started with this kernel.
The plan is to create such OFED for every kernel version, or, maybe skip odd versions as you suggest.
Due to limited resources we did not start to work on 3.6 yet, but once OFED-3.5 will have stable infrastructure it will be easier to build OFED-3.6...

> Have a look at http://en.wikipedia.org/wiki/Linux_kernel - 3.0, 3.2 and
> 3.4 are the long-term stable releases.
>
> This approach is worse than the approach before IMHO. Since 1.5.4.1
> there is no real stable release. No wonder that everyone puts his own
> OFED together.

This approach should increase motivation to push new features/fixes upstream which will lead to more stable drivers in all Distros (in-box).

> I'm so glad that we don't need too much OFED user space and we just use
> the IB stuff from the mainline kernel. We need to surf close to mainline
> kernel development anyway.
>
> The only thing that we would need is a list which packet with which
> version matches our mainline kernel. Updating it from Git directly from
> a tag or branch with no external patches or SRPM/tar.gz stuff would make
> it much easier - also for other distributions. Things are getting better
> for us with the switch-over to Gentoo. There, we can leave out the
> packages that we don't actually need.
>

For the list of packages and maintainers please refer to http://www.openfabrics.org/downloads/MAINTAINERS

Regards,
Vladimir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
