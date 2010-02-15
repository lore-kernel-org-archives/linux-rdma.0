From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: ibutils license problems + a few other minor issues
Date: Mon, 15 Feb 2010 22:50:28 +0200
Message-ID: <4B79B394.50407@mellanox.co.il>
References: <4B743A4A.90004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B743A4A.90004-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/11/2010 7:11 PM, Doug Ledford wrote:
> The ibutils tarball as found for download on the openfabrics web site
> has some licensing issues that need resolved ASAP.  The tarball in its
> current form is probably illegal to distribute until the items are
> fixed.  So, here's what popped up in review (done by Jay Fenlason):
>
> The COPYING files sprinkled around in the tarball are not consistent.
> Some of them contain a copy of the GPLv2, some of them contain a
> statement that the package is licensed under either GPLv2 in the file
> COPYING or the OFA BSD license included here in.  Of course, it doesn't
> work to reference a COPYING file from within the COPYING file you are
> referencing and say it has the information you aren't including here.  I
> would suggest that the proper place for the statement of GPLv2 or BSD is
> in possibly a LICENSE file with the COPYING file being the GPLv2 as
> stated.  It also seems redundant to have multiple COPYING files and
> possibly also multiple LICENSE files in a single tarball, so cleanup of
> unnecessary files seems in order here.
>    

Hi Doug
Thanks for providing the info (I  guess it was in this way from the 
first days we submitted the code to OFA)
Yevgeny will fix this soon

Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
