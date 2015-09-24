From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: libibverbs-1.2.0-rc1 release
Date: Thu, 24 Sep 2015 11:12:04 -0400 (EDT)
Message-ID: <E53FE4F4-5D69-4291-992B-D8CB8710A79E@redhat.com>
References: <5602DB41.5070700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5602DB41.5070700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks!

Sent from my iPhone

> On Sep 23, 2015, at 1:03 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> I have done a pre-release of the upcoming libibverbs-1.2.0 release.  The
> code has been pushed to the official git repo and also an -rc1 tarball
> uploaded to the https://ww.openfabrics.org/downloads/verbs download
> area.  From the tag message:
> 
> tag libibverbs-1.2.0-rc1
> Tagger: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Wed Sep 23 12:47:04 2015 -0400
> 
> Ininitial roundup of 1.2.0 release items
> 
> - Add support for RoCE
> - Add support for On Demand Paging
> - No longer assume that no driver for a verbs device should be considered
>  an error condition (usnic devices in particular are moving to libfabric
>  drivers only, so we will emit a useless warning/error in the presence
>  of usnic enabled machines)
> - Harden some of the argument processing in example programs
> - Add support for s390x
> - Fix the broken create/destroy flow API
> - First release under new management (hence the decision to update to
>  version 1.2.0 instead of 1.1.9)
> 
> In particular, as this release fixes the create/destroy flow API, there
> is a need for an updated libmlx4 sources in order to compile against the
> fixed API (binary compatibility was maintained, but source compatibility
> was not, so you will need the new libmlx4 to compile against the new
> libibverbs).  Yishai, please post an updated libmlx4 head of repo and
> preferably also a source tarball for libmlx4 when it's ready.
> Preferably it would include an embedded check for the proper flow API in
> your configure scripts.
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>              GPG KeyID: 0E572FDD
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
